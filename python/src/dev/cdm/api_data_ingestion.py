import os
import psycopg2
import logging
import polars as pl
from decimal import Decimal
from datetime import datetime, timedelta
import io
import sys

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Retrieve the database connection string from environment variables
connection_string = os.getenv('DATABASE_URL')
if not connection_string:
    logging.error("DATABASE_URL environment variable not set.")
    sys.exit(1)

# Adjust the connection string for psycopg2 compatibility
if connection_string.startswith("postgresql+psycopg2://"):
    connection_string = connection_string.replace("postgresql+psycopg2://", "postgresql://", 1)

# Function to clean a row and convert values
def clean_row(row, colnames):
    return {
        col: (
            float(val) if isinstance(val, Decimal) else
            None if val is None else
            val
        )
        for col, val in zip(colnames, row)
    }

# Function to generate a full date range and forward-fill missing values
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

try:
    # Connect to the database
    with psycopg2.connect(connection_string) as conn:
        schema_name = 'raw'
        table_name = 'api_data_ingestion'
        target_schema = 'cdm'
        target_table = 'api_data_ingestion'

        query = f"SELECT * FROM {schema_name}.{table_name}"
        with conn.cursor() as cursor:
            cursor.execute(query)
            data = cursor.fetchall()
            colnames = [desc[0] for desc in cursor.description]

        # Define schema for Polars DataFrame
        schema = {
            "date": pl.Date,
            "open": pl.Float64,
            "high": pl.Float64,
            "low": pl.Float64,
            "close": pl.Float64,
            "volume": pl.Int64,
            "dividends": pl.Float64,
            "stock_splits": pl.Float64,
            "ticker": pl.Utf8,
            "processed_at": pl.Datetime,
            "adj_close": pl.Float64,
            "capital_gains": pl.Utf8,
            "ticker_date_id": pl.Utf8,
        }

        # Clean data and create Polars DataFrame
        cleaned_data = [clean_row(row, colnames) for row in data]
        pl_df = pl.DataFrame(cleaned_data, schema=schema)

        logging.info("Sample cleaned data: %s", cleaned_data[:5])
        logging.info("Column names: %s", colnames)
        logging.info("Initial DataFrame Schema: %s", pl_df.schema)

        # Generate full date range and forward-fill missing values
        full_pl_df = generate_full_date_range(pl_df)
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

        # Calculate `ticker_date_id` and reorder columns
        full_pl_df = full_pl_df.with_columns(
            (pl.col("ticker") + "_" + pl.col("date").cast(pl.Utf8)).alias("ticker_date_id")
        )
        full_pl_df = full_pl_df.select([
            "date", "ticker", "open", "high", "low", "close", "volume",
            "dividends", "stock_splits", "processed_at", "adj_close",
            "capital_gains", "date_type", "ticker_date_id"
        ])

        # Ensure distinct rows
        full_pl_df = full_pl_df.unique(subset=["ticker_date_id"])

        logging.info("Transformed DataFrame Schema: %s", full_pl_df.schema)
        logging.info("Sample Rows After Transformation: %s", full_pl_df.head())

        # Step: Remove already existing ticker_date_ids
        with conn.cursor() as cursor:
            cursor.execute(f'SELECT ticker_date_id FROM {target_schema}.{target_table}')
            existing_ids = {row[0] for row in cursor.fetchall()}

        logging.info("Fetched %d existing ticker_date_ids from target table.", len(existing_ids))

        full_pl_df = full_pl_df.filter(~pl.col("ticker_date_id").is_in(existing_ids))
        logging.info("Filtered down to %d new rows to insert.", full_pl_df.shape[0])

        # Insert new rows in batches
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
                        dividends, "stock_splits", processed_at, adj_close,
                        "capital_gains", date_type, ticker_date_id
                    ) FROM STDIN WITH (FORMAT CSV, HEADER TRUE)""",
                    csv_buffer
                )
            conn.commit()
            logging.info("Batch of %d rows saved.", len(batch))

except psycopg2.Error as db_err:
    logging.error("Database error: %s", db_err)
except Exception as e:
    logging.error("Unexpected error: %s", e)
