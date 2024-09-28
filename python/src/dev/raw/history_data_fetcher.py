import warnings
warnings.filterwarnings("ignore", category=FutureWarning)

import os
import sys
import logging
from datetime import datetime
import yfinance as yf
import pandas as pd
import adbc_driver_postgresql.dbapi as pg_dbapi

# Add your application directory to the system path
sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')

# Import configurations and helper functions
from dev.config.config import TICKERS
from dev.config.helpers import save_to_database

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


def build_df(tickers):
    """Fetches historical stock data for given tickers and returns it as a DataFrame."""
    try:
        df = pd.DataFrame()  # Initialize an empty DataFrame
        for ticker in tickers:
            # Fetch stock data using yfinance
            stock_data = yf.Ticker(ticker)
            dx = stock_data.history(period="max")  # Fetch historical data for the maximum period
            
            # Rename columns to lowercase
            dx.rename(columns={
                'Open': 'open',
                'High': 'high',
                'Low': 'low',
                'Close': 'close',
                'Adj Close': 'adj_close',
                'Volume': 'volume'
            }, inplace=True)
            
            # Convert 'open' to numeric, forcing errors to NaN (optional: raise if strict validation needed)
            dx['open'] = pd.to_numeric(dx['open'], errors='coerce').round(2)

            # Convert other columns to numeric and round appropriately
            dx['high'] = pd.to_numeric(dx['high'], errors='coerce').round(2)
            dx['low'] = pd.to_numeric(dx['low'], errors='coerce').round(2)
            dx['close'] = pd.to_numeric(dx['close'], errors='coerce').round(2)

            # Check if 'adj_close' column exists before rounding
            if 'adj_close' in dx.columns:
                dx['adj_close'] = pd.to_numeric(dx['adj_close'], errors='coerce').round(2)
            
            # Leave the volume as float to allow NaN values
            dx['volume'] = pd.to_numeric(dx['volume'], errors='coerce')
            
            # Add a column to identify the ticker
            dx['ticker'] = ticker
            
            # Concatenate the dataframes
            df = pd.concat([df, dx], sort=False) if not df.empty else dx
        
        # Reset index and rename date column
        df.reset_index(inplace=True)
        df.rename(columns={'Date': 'date'}, inplace=True)
        
        # Format the date column to exclude time and timezone
        df['date'] = pd.to_datetime(df['date']).dt.date
        
        # Add the processed_at column with the current timestamp
        df['processed_at'] = datetime.now()

        return df  # Return the constructed DataFrame
    except Exception as e:
        logging.exception("Error building DataFrame")
        raise


if __name__ == "__main__":
    table_name = 'history_data_fetcher'  # Name of the table to create or replace
    
    # Retrieve connection string from environment variables
    connection_string = os.getenv('DB_CONNECTION_STRING')
    
    if connection_string is None:
        logging.error("DB_CONNECTION_STRING environment variable not set")
    else:
        try:
            # Fetch the data for the tickers defined in config.py
            df = build_df(TICKERS)
            logging.info(f"Data fetched for {len(TICKERS)} tickers")
            print(df.head())  # Optionally print the first few rows for verification
            
            # Save the DataFrame to the specified table in the database
            save_to_database(df, table_name, connection_string, schema_name='raw')
        except Exception as e:
            logging.exception("Unexpected error occurred")
