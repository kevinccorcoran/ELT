import sys
import os
import logging

# Add project root to PYTHONPATH dynamically
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))

import polars as pl
import numpy as np
import adbc_driver_postgresql.dbapi as pg_dbapi
from dev.config.helpers import fetch_data_from_database, save_to_database

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

POSITIVE_MOVE_THRESHOLD = 0.001

def apply_rolling_metrics(df: pl.DataFrame, horizons: list[int]) -> pl.DataFrame:
    results = []

    for ticker in df["ticker"].unique():
        group_df = df.filter(pl.col("ticker") == ticker).sort("date")

        for h in horizons:
            group_df = group_df.with_columns([
                (pl.col("log_ret")
                 .map_elements(lambda x: max(x - POSITIVE_MOVE_THRESHOLD, 0.0), return_dtype=pl.Float64)
                 .rolling_sum(h)
                 .alias(f"pos_sum_{h}")),
                (pl.col("log_ret")
                 .gt(POSITIVE_MOVE_THRESHOLD)
                 .cast(pl.Float64)
                 .rolling_mean(h)
                 .alias(f"up_move_ratio_{h}"))
            ])

        group_df = group_df.with_columns(
            (pl.when(pl.col("log_ret") < 0)
               .then(pl.col("log_ret") ** 2)
               .otherwise(None)
             ).rolling_mean(30)
              .sqrt()
              .alias("downside_std")
        )

        results.append(group_df)

    return pl.concat(results)


def calculate_amrms():
    connection_string = os.getenv("DATABASE_URL")
    if not connection_string:
        logging.error("DATABASE_URL environment variable not set.")
        sys.exit(1)

    if connection_string.startswith("postgresql+psycopg2://"):
        connection_string = connection_string.replace("postgresql+psycopg2://", "postgresql://", 1)

    df = fetch_data_from_database(
        table_name="api_data_ingestion",
        schema_name="cdm",
        connection_string=connection_string
    )
    df = pl.DataFrame(df).sort(["ticker", "date"])

    df = df.with_columns(
        (pl.col("adj_close") / pl.col("adj_close").shift(1)).log().alias("log_ret")
    ).filter(
        pl.col("log_ret").is_not_null()
    )

    horizons = [21, 63, 126, 252]
    df = apply_rolling_metrics(df, horizons)

    # ✅ Drop rows where long-term rolling metrics are still null
    df = df.filter(pl.col("up_move_ratio_252").is_not_null())

    entries = []
    for row in df.iter_rows(named=True):
        if row["date"] is None:
            continue

        downside_std = row["downside_std"] if row["downside_std"] not in [None, np.nan] else 1.0
        entry = {
            "ticker": row["ticker"],
            "date": row["date"],
            "downside_std": downside_std
        }

        for h in horizons:
            pos_sum = row.get(f"pos_sum_{h}", 0.0) or 0.0
            up_ratio = row.get(f"up_move_ratio_{h}", 0.0) or 0.0
            if up_ratio not in [0, 1] and not np.isnan(up_ratio):
                entropy = -(up_ratio * np.log2(up_ratio) + (1 - up_ratio) * np.log2(1 - up_ratio))
            else:
                entropy = 0.0
            entry[f"pos_sum_{h}"] = pos_sum
            entry[f"up_move_ratio_{h}"] = up_ratio
            entry[f"entropy_{h}"] = entropy

        entries.append(entry)

    results_df = pl.DataFrame(entries)
    if results_df.is_empty():
        logging.warning("No AMRMS scores computed. Returning.")
        return

    results_df = results_df.fill_null(0.0)

    weighted_sum = None
    for h in horizons:
        col = f"pos_sum_{h}"
        mean = results_df[col].mean()
        std = results_df[col].std()
        results_df = results_df.with_columns(
            ((pl.col(col) - mean) / (std if std != 0 else 1)).alias(f"z_{h}")
        )

    for h in horizons:
        weight = (1 / (1 + results_df[f"entropy_{h}"]))
        component = weight * results_df[f"z_{h}"]
        weighted_sum = component if weighted_sum is None else weighted_sum + component

    results_df = results_df.with_columns(
        (weighted_sum / (pl.col("downside_std").clip(lower_bound=0.01))).alias("amrms_score")
    )

    results_df = results_df.with_columns([
        pl.col("date").cast(pl.Date),
        pl.col("amrms_score").cast(pl.Float64),
        (pl.col("ticker") + "_" + pl.col("date").cast(pl.Utf8)).alias("ticker_date_id")
    ])

    try:
        conn = pg_dbapi.connect(connection_string)
        cur = conn.cursor()
        cur.execute("TRUNCATE TABLE metrics.amrms_score;")
        conn.commit()
        cur.close()
        conn.close()

        if results_df.height > 0:
            df_to_save = results_df.to_pandas()
            df_to_save["date"] = df_to_save["date"].dt.date  # ✅ Ensure Python date
            save_to_database(
                df_to_save,
                table_name="amrms_score",
                schema_name="metrics",
                connection_string=connection_string
            )

        logging.info("AMRMS scores saved successfully.")

    except Exception as e:
        logging.error(f"Unexpected error occurred: {e}")
        sys.exit(1)

    return results_df


if __name__ == "__main__":
    result = calculate_amrms()
    print(result)
