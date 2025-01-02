import sys
import os
import polars as pl
import psycopg2
from decimal import Decimal
import io
from datetime import datetime, timedelta

# Ensure the connection string is set
connection_string = os.getenv('DB_CONNECTION_STRING')
if not connection_string:
    print("DB_CONNECTION_STRING environment variable not set")
    sys.exit(1)

try:
    with psycopg2.connect(connection_string) as conn:
        schema_name = 'raw'
        table_name = 'api_raw_data_ingestion'
        target_schema = 'cdm'
        target_table = 'api_cdm_data_ingestion'

        query = f"SELECT * FROM {schema_name}.{table_name}"
        with conn.cursor() as cursor:
            cursor.execute(query)
            data = cursor.fetchall()
            colnames = [desc[0] for desc in cursor.description]

        # Define schema for Polars DataFrame explicitly
        schema = {
            "date": pl.Date,
            "open": pl.Float64,
            "high": pl.Float64,
            "low": pl.Float64,
            "close": pl.Float64,
            "volume": pl.Int64,
            "dividends": pl.Float64,
            "Stock Splits": pl.Float64,
            "ticker": pl.Utf8,
            "processed_at": pl.Datetime,
            "adj_close": pl.Float64,
            "Capital Gains": pl.Utf8,
            "ticker_date_id": pl.Utf8,
        }

        # Convert Decimal to float and prepare data as list of dicts
        def clean_row(row):
            return {
                col: (
                    float(val) if isinstance(val, Decimal) else
                    None if val is None else
                    val
                )
                for col, val in zip(colnames, row)
            }

        cleaned_data = [clean_row(row) for row in data]

        # Create Polars DataFrame with explicit schema
        pl_df = pl.DataFrame(cleaned_data, schema=schema)

        # Debug: Log initial data
        print("Sample cleaned data:", cleaned_data[:5])
        print("Column names:", colnames)
        print("Initial DataFrame Schema:", pl_df.schema)

        # Add missing synthetic rows and forward-fill data
        def generate_full_date_range(df):
            unique_tickers = df.select(pl.col("ticker")).unique().to_series().to_list()
            full_data = []
            for ticker in unique_tickers:
                ticker_data = df.filter(pl.col("ticker") == ticker)
                min_date = ticker_data.select(pl.col("date").min())[0, 0]
                max_date = ticker_data.select(pl.col("date").max())[0, 0]
                date_range = [min_date + timedelta(days=i) for i in range((max_date - min_date).days + 1)]
                full_dates = pl.DataFrame({
                    "date": date_range,
                    "ticker": [ticker] * len(date_range),
                })
                joined_data = full_dates.join(ticker_data, on=["date", "ticker"], how="left")
                joined_data = joined_data.with_columns(
                    pl.when(pl.col("open").is_null())
                    .then(pl.lit("synthetic"))
                    .otherwise(pl.lit("natural"))
                    .alias("date_type")
                )
                full_data.append(joined_data)
            return pl.concat(full_data)

        full_pl_df = generate_full_date_range(pl_df)

        # Forward-fill missing values
        full_pl_df = full_pl_df.sort(["ticker", "date"]).with_columns(
            [
                pl.col("open").forward_fill().alias("open"),
                pl.col("high").forward_fill().alias("high"),
                pl.col("low").forward_fill().alias("low"),
                pl.col("close").forward_fill().alias("close"),
                pl.col("adj_close").forward_fill().alias("adj_close"),
                pl.col("processed_at").forward_fill().alias("processed_at"),
            ]
        )

        # Calculate `ticker_date_id`
        full_pl_df = full_pl_df.with_columns(
            (pl.col("ticker") + "_" + pl.col("date").cast(pl.Utf8)).alias("ticker_date_id")
        )

        # Reorder columns for PostgreSQL compatibility
        full_pl_df = full_pl_df.select([
            "date", "ticker", "open", "high", "low", "close", "volume",
            "dividends", "Stock Splits", "processed_at", "adj_close",
            "Capital Gains", "date_type", "ticker_date_id"
        ])

        # **Ensure Distinct Rows**
        # Keep only distinct rows based on the unique key, here assumed as 'ticker_date_id'.
        full_pl_df = full_pl_df.unique(subset=["ticker_date_id"])

        # Debug transformed DataFrame
        print("Transformed DataFrame Schema:", full_pl_df.schema)
        print("Sample Rows After Transformation:", full_pl_df.head())

        # Insert into target PostgreSQL table in batches
        batch_size = 10000
        num_rows = full_pl_df.shape[0]
        for start in range(0, num_rows, batch_size):
            end = min(start + batch_size, num_rows)
            batch = full_pl_df[start:end]

            csv_buffer = io.StringIO()
            batch.write_csv(csv_buffer)
            csv_buffer.seek(0)

            with conn.cursor() as cursor:
                cursor.copy_expert(
                    f"""COPY {target_schema}.{target_table} (
                        "date", ticker, "open", high, low, "close", volume,
                        dividends, "Stock Splits", processed_at, adj_close,
                        "Capital Gains", date_type, ticker_date_id
                    ) FROM STDIN WITH (FORMAT CSV, HEADER TRUE)""",
                    csv_buffer
                )
            conn.commit()
            print(f"Batch of {len(batch)} rows saved.")

except psycopg2.Error as db_err:
    print(f"Database error: {db_err}")
except Exception as e:
    print(f"Unexpected error: {e}")