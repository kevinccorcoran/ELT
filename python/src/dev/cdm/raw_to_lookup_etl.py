import os
import sys
import logging
import psycopg2
import pandas as pd
from pandas.tseries.offsets import DateOffset
from datetime import datetime
from decimal import Decimal
import io

# ---------------------------------------------------------------------------
# Configure Logging
# ---------------------------------------------------------------------------
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# ---------------------------------------------------------------------------
# Retrieve DATABASE_URL (or DB_CONNECTION_STRING) from environment variables
# ---------------------------------------------------------------------------
connection_string = os.getenv('DATABASE_URL')
if not connection_string:
    logging.error("DATABASE_URL environment variable not set.")
    sys.exit(1)

# Adjust the connection string for psycopg2 compatibility if needed
if connection_string.startswith("postgresql+psycopg2://"):
    connection_string = connection_string.replace("postgresql+psycopg2://", "postgresql://", 1)

# ---------------------------------------------------------------------------
# Utility Functions
# ---------------------------------------------------------------------------
def get_next_trading_day(date):
    """
    Returns the next available trading day.
    Uses pandas bdate_range (business day range),
    which excludes weekends and can be customized for holidays.
    """
    return pd.bdate_range(date, periods=1)[0].date()

def process_stock_data(df, years_to_add=3):
    """
    Processes the stock data to find and extend minimum dates for each ticker.
    1. Convert 'date' to datetime.date.
    2. Group by 'ticker' and find the earliest date.
    3. For each year up to `years_to_add`, shift that earliest date forward
       and join with the original DataFrame.
    4. Drop rows with missing data, add a row_number partitioned by ticker.
    """
    df['date'] = pd.to_datetime(df['date']).dt.date

    # Find the earliest date for each ticker
    min_dates = df.groupby('ticker')['date'].min().reset_index()

    # Collect DataFrames: the original min dates + each subsequent year shift
    all_years_dfs = [min_dates]
    for year in range(1, years_to_add + 1):
        min_dates_shifted = min_dates.copy()
        min_dates_shifted['date'] = min_dates_shifted['date'] + DateOffset(years=year)
        min_dates_shifted['date'] = min_dates_shifted['date'].apply(get_next_trading_day)
        min_dates_shifted['date'] = pd.to_datetime(min_dates_shifted['date']).dt.date

        # Merge to preserve only columns we need
        shifted_df = pd.merge(min_dates_shifted, df, on=['ticker', 'date'], how='left')[['ticker', 'date']]
        all_years_dfs.append(shifted_df)

    # Concatenate all years and remove missing
    result_df = pd.concat(all_years_dfs, ignore_index=True)
    result_df['date'] = pd.to_datetime(result_df['date']).dt.date
    result_df.dropna(inplace=True)

    # Add row_number for each (ticker) ordered by date
    result_df['row_number'] = (
        result_df.sort_values('date')
                 .groupby('ticker')
                 .cumcount()
    )

    return result_df

def cumulative_fibonacci(n):
    """
    Returns a set of Fibonacci numbers cumulatively generated
    up to the given integer `n`.
    Example usage: if n=100, return all Fibonacci positions <= 100.
    """
    fib_set = set()
    a, b = 0, 1
    while a <= n:
        fib_set.add(a)
        a, b = b, a + b
    return fib_set

# ---------------------------------------------------------------------------
# Main ETL Logic
# ---------------------------------------------------------------------------
try:
    # Connect to PostgreSQL
    with psycopg2.connect(connection_string) as conn:
        schema_name = 'raw'
        table_name = 'api_raw_data_ingestion'
        target_schema = 'cdm'
        target_table = 'date_lookup'

        # -------------------------------------------------------------------
        # 1) Fetch the full dataset from raw.api_raw_data_ingestion
        # -------------------------------------------------------------------
        query = f"SELECT * FROM {schema_name}.{table_name}"
        logging.info("Fetching data from %s.%s ...", schema_name, table_name)

        with conn.cursor() as cursor:
            cursor.execute(query)
            rows = cursor.fetchall()
            colnames = [desc[0] for desc in cursor.description]

        if not rows:
            logging.warning("No rows returned from the database.")
            sys.exit(0)

        # Create a Pandas DataFrame
        df = pd.DataFrame(rows, columns=colnames)
        logging.info("Data fetched. Shape of DataFrame: %s", df.shape)

        # -------------------------------------------------------------------
        # 2) Split the tickers into batches of 10 (or 100, if needed)
        # -------------------------------------------------------------------
        unique_tickers = df['ticker'].unique()
        ticker_batches = [unique_tickers[i:i + 10] for i in range(0, len(unique_tickers), 10)]
        logging.info("Number of batches: %s", len(ticker_batches))

        # -------------------------------------------------------------------
        # 3) Process each ticker batch
        # -------------------------------------------------------------------
        batch_num = 0
        for ticker_batch in ticker_batches:
            batch_num += 1
            logging.info("Processing batch %d with %d tickers...", batch_num, len(ticker_batch))
            
            # Filter the DataFrame for this batch
            batch_df = df[df['ticker'].isin(ticker_batch)]
            
            # Generate the extended date set for each ticker
            result_df = process_stock_data(batch_df, years_to_add=100)

            # ----------------------------------------------------------------
            # 4) Fibonacci filtering
            # ----------------------------------------------------------------
            fib_sequence = cumulative_fibonacci(result_df['row_number'].max())
            matching_rows = result_df[result_df['row_number'].isin(fib_sequence)].copy()

            # Sort results
            matching_rows.sort_values(by=['ticker', 'date', 'row_number'], ascending=True, inplace=True)

            if matching_rows.empty:
                logging.info("Batch %d has no matching rows after Fibonacci filtering.", batch_num)
                continue

            logging.info("Batch %d result shape: %s", batch_num, matching_rows.shape)

            # ----------------------------------------------------------------
            # 5) Write to the target table using COPY
            # ----------------------------------------------------------------
            # We'll just store (ticker, date, row_number) in this example
            # but you can store more columns if needed.
            csv_buffer = io.StringIO()
            matching_rows.to_csv(csv_buffer, index=False, header=True)
            csv_buffer.seek(0)

            columns_to_copy = ['ticker', 'date', 'row_number']
            copy_sql = f"""
                COPY {target_schema}.{target_table} ({', '.join(columns_to_copy)})
                FROM STDIN WITH (FORMAT CSV, HEADER TRUE)
            """

            with conn.cursor() as cursor:
                cursor.copy_expert(copy_sql, csv_buffer)
            conn.commit()

            logging.info("Batch %d saved successfully.", batch_num)

        logging.info("All batches processed and saved successfully.")

except psycopg2.Error as db_err:
    logging.error("Database error: %s", db_err)
    sys.exit(1)
except Exception as e:
    logging.error("Unexpected error: %s", e)
    sys.exit(1)
