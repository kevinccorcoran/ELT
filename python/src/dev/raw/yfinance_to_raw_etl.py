import sys
import os
import warnings
import logging
import argparse
import time
from datetime import datetime

import yfinance as yf
import pandas as pd
import adbc_driver_postgresql.dbapi as pg_dbapi
from airflow.models import Variable  # Import Airflow Variable

# Suppress FutureWarnings from libraries
warnings.filterwarnings("ignore", category=FutureWarning)

# Add application directory to system path for module access
sys.path.append('/Users/kevin/repos/ELT_private/python/src/')

# Import configurations and helper functions
from dev.config.config import TICKERS, TICKERS_FULL
from dev.config.helpers import save_to_database

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def chunk_list(lst, n):
    """Yield successive n-sized chunks from a list."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

def fetch_stock_data(ticker, start_date=None, end_date=None, retries=3):
    attempt = 0
    while attempt < retries:
        try:
            #time.sleep(5)  # Increase delay to 5 seconds
            stock_data = yf.Ticker(ticker)
            dx = stock_data.history(start=start_date, end=end_date) if start_date and end_date else stock_data.history(period="max")

            if dx.empty:
                logging.warning(f"No data found for ticker {ticker}, it may be delisted or inactive.")
                return None  # Return None instead of an empty DataFrame
            
            return dx
        
        except Exception as e:
            logging.warning(f"Error fetching data for {ticker}: {e}. Retrying ({attempt + 1}/{retries})...")
            #time.sleep(5 * (attempt + 1))  # Exponential backoff (5s, 10s, 15s)
            #attempt += 1

    logging.error(f"Failed to fetch data for {ticker} after {retries} attempts.")
    return None


def build_df(tickers, start_date=None, end_date=None):
    """
    Fetches historical stock data for a batch of tickers and returns it as a DataFrame.
    """
    df = pd.DataFrame()  # Initialize an empty DataFrame
    for ticker in tickers:
        dx = fetch_stock_data(ticker, start_date, end_date)
        if dx is not None:
            # Rename columns to lowercase
            dx.rename(columns={
                'Open': 'open',
                'High': 'high',
                'Low': 'low',
                'Close': 'close',
                'Adj Close': 'adj_close',
                'Volume': 'volume'
            }, inplace=True)

            # Convert columns to numeric and round where applicable
            for column in ['open', 'high', 'low', 'close', 'adj_close', 'volume']:
                if column in dx.columns:
                    dx[column] = pd.to_numeric(dx[column], errors='coerce').round(2)

            dx['ticker'] = ticker
            df = pd.concat([df, dx], sort=False)

    # Reset index and rename date column
    if not df.empty:
        df.reset_index(inplace=True)
        df.rename(columns={'Date': 'date'}, inplace=True)
        
        # Convert 'date' to a proper date and remove NaT values
        df['date'] = pd.to_datetime(df['date']).dt.tz_localize(None).dt.date
        df = df.dropna(subset=["date"])

        # Add processed_at timestamp
        df['processed_at'] = datetime.now()

        # Create a unique identifier for each row
        df['ticker_date_id'] = df['ticker'].astype(str) + '_' + df['date'].astype(str)

        # Remove null bytes in other string columns
        for col in df.select_dtypes(include=['object', 'string']).columns:
            if col != 'date':  # Skip 'date' since it's not a string anymore
                df[col] = df[col].astype(str).str.replace("\x00", "", regex=False)

    return df  # Return the constructed DataFrame

if __name__ == "__main__":
    # Retrieve environment variable from Airflow
    ENV = Variable.get("ENV", default_var="dev")

    # Select tickers based on environment
    SELECTED_TICKERS = TICKERS if ENV == "dev" else TICKERS_FULL

    # Argument parser for optional start_date and end_date
    parser = argparse.ArgumentParser(description="Fetch stock data.")
    parser.add_argument("--start_date", help="Start date for data fetch (format YYYY-MM-DD)", required=False)
    parser.add_argument("--end_date", help="End date for data fetch (format YYYY-MM-DD)", required=False)
    args = parser.parse_args()

    # Set default dates to today if not provided
    today = datetime.now().strftime('%Y-%m-%d')
    start_date = args.start_date if args.start_date else today
    end_date = args.end_date if args.end_date else today

    # Database table information
    table_name = 'api_raw_data_ingestion'
    key_columns = ['ticker_date_id']

    # Retrieve connection string from environment variables
    connection_string = os.getenv('DATABASE_URL')
    
    if connection_string is None:
        logging.error("DATABASE_URL environment variable not set")
        raise ValueError("DATABASE_URL environment variable not set")
    
    # Adjust DATABASE_URL for SQLAlchemy compatibility
    if connection_string.startswith("postgres://"):
        connection_string = connection_string.replace("postgres://", "postgresql+psycopg2://", 1)
    
    try:
        # Process tickers in batches of specified size
        batch_size = 100  # Reduce batch size to avoid API rate limits
        ticker_batches = chunk_list(SELECTED_TICKERS, batch_size)
        
        for batch in ticker_batches:
            # Fetch data for the current batch
            df = build_df(batch, start_date=start_date, end_date=end_date)
            
            if not df.empty:
                logging.info(f"Data fetched for {len(df['ticker'].unique())} tickers in current batch.")
                
                # Print the first few rows for verification
                print(df.head())
                
                # Save the DataFrame to the database
                save_to_database(df, table_name, connection_string, schema_name='raw', key_columns=key_columns)
            
            else:
                logging.info("No data fetched for any tickers in current batch; check if tickers are inactive or delisted.")
                
    except Exception as e:
        logging.exception("Unexpected error occurred")