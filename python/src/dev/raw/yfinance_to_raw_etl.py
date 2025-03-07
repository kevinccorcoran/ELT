import sys
import os
import warnings
import logging
import argparse
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

def build_df(tickers, start_date=None, end_date=None):
    """
    Fetches historical stock data for given tickers within an optional date range
    and returns it as a DataFrame.
    """
    df = pd.DataFrame()  # Initialize an empty DataFrame
    for ticker in tickers:
        try:
            # Fetch stock data using yfinance
            stock_data = yf.Ticker(ticker)
            
            # Fetch historical data within the date range if provided; otherwise, fetch max period
            dx = stock_data.history(start=start_date, end=end_date) if start_date and end_date else stock_data.history(period="max")
            
            # Check if data is empty (ticker might be delisted or inactive)
            if dx.empty:
                logging.warning(f"No data found for ticker {ticker}, it may be delisted or inactive.")
                continue  # Skip to the next ticker
            
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
            
            # Add a column to identify the ticker
            dx['ticker'] = ticker
            
            # Concatenate the DataFrames
            df = pd.concat([df, dx], sort=False)
        
        except Exception as e:
            logging.warning(f"Error processing ticker {ticker}: {e}")
    
    # Reset index and rename date column
    if not df.empty:
        df.reset_index(inplace=True)
        df.rename(columns={'Date': 'date'}, inplace=True)
        
        # Format the date column to exclude time and timezone
        #df['date'] = pd.to_datetime(df['date']).dt.date
        # df['date'] = pd.to_datetime(df['date']).dt.strftime('%Y-%m-%d')

        # # Convert 'date' column to string to avoid PostgreSQL COPY format issues
        # df['date'] = df['date'].astype(str)

        df['date'] = pd.to_datetime(df['date']).dt.date  # Ensures values are proper date objects


        # Add the processed_at column with the current timestamp
        df['processed_at'] = datetime.now()

        # Add ticker_date_id by concatenating ticker and date
        df['ticker_date_id'] = df['ticker'].astype(str) + '_' + df['date'].astype(str)

        # Ensure 'Capital Gains' column exists before processing
        if 'Capital Gains' in df.columns:
            df['Capital Gains'] = df['Capital Gains'].astype(str).str.replace("\x00", "", regex=False)

        # Apply null byte fix to all string columns
        for col in df.select_dtypes(include=['object', 'string']).columns:
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
    connection_string = os.getenv('DATABASE_URL')  # Updated to use DATABASE_URL
    
    if connection_string is None:
        logging.error("DATABASE_URL environment variable not set")
        raise ValueError("DATABASE_URL environment variable not set")
    
    # Optional: Adjust DATABASE_URL for SQLAlchemy compatibility
    if connection_string.startswith("postgres://"):
        connection_string = connection_string.replace("postgres://", "postgresql+psycopg2://", 1)
    
    try:
        # Process tickers in batches of specified size
        batch_size = 50
        ticker_batches = chunk_list(SELECTED_TICKERS, batch_size)
        
        for batch in ticker_batches:
            # Fetch data for the current batch
            df = build_df(batch, start_date=start_date, end_date=end_date)
            
            if not df.empty:
                logging.info(f"Data fetched for {len(df['ticker'].unique())} tickers in current batch.")
                
                # Optionally print the first few rows for verification
                print(df.head())
                
                # Save the DataFrame to the specified database table
                save_to_database(df, table_name, connection_string, schema_name='raw', key_columns=key_columns)
            
            else:
                logging.info("No data fetched for any tickers in current batch; check if tickers are inactive or delisted.")
                
    except Exception as e:
        logging.exception("Unexpected error occurred")


# import sys
# import os
# import warnings
# import logging
# import argparse
# from datetime import datetime

# import yfinance as yf
# import pandas as pd
# import adbc_driver_postgresql.dbapi as pg_dbapi
# from airflow.models import Variable  # Import Airflow Variable

# # Suppress FutureWarnings from libraries
# warnings.filterwarnings("ignore", category=FutureWarning)

# # Add application directory to system path for module access
# sys.path.append('/Users/kevin/repos/ELT_private/python/src/')

# # Import configurations and helper functions
# from dev.config.config import TICKERS, TICKERS_FULL
# from dev.config.helpers import save_to_database

# # Configure logging
# logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# def chunk_list(lst, n):
#     """Yield successive n-sized chunks from a list."""
#     for i in range(0, len(lst), n):
#         yield lst[i:i + n]

# def build_df(tickers, start_date=None, end_date=None):
#     """
#     Fetches historical stock data for given tickers within an optional date range
#     and returns it as a DataFrame.
#     """
#     df = pd.DataFrame()  # Initialize an empty DataFrame
#     for ticker in tickers:
#         try:
#             # Fetch stock data using yfinance
#             stock_data = yf.Ticker(ticker)
            
#             # Fetch historical data within the date range if provided; otherwise, fetch max period
#             dx = stock_data.history(start=start_date, end=end_date) if start_date and end_date else stock_data.history(period="max")
            
#             # Check if data is empty (ticker might be delisted or inactive)
#             if dx.empty:
#                 logging.warning(f"No data found for ticker {ticker}, it may be delisted or inactive.")
#                 continue  # Skip to the next ticker
            
#             # Rename columns to lowercase
#             dx.rename(columns={
#                 'Open': 'open',
#                 'High': 'high',
#                 'Low': 'low',
#                 'Close': 'close',
#                 'Adj Close': 'adj_close',
#                 'Volume': 'volume'
#             }, inplace=True)
            
#             # Convert columns to numeric and round where applicable
#             for column in ['open', 'high', 'low', 'close', 'adj_close', 'volume']:
#                 if column in dx.columns:
#                     dx[column] = pd.to_numeric(dx[column], errors='coerce').round(2)
            
#             # Add a column to identify the ticker
#             dx['ticker'] = ticker
            
#             # Concatenate the DataFrames
#             df = pd.concat([df, dx], sort=False)
        
#         except Exception as e:
#             logging.warning(f"Error processing ticker {ticker}: {e}")
    
#     # Reset index and rename date column
#     if not df.empty:
#         df.reset_index(inplace=True)
#         df.rename(columns={'Date': 'date'}, inplace=True)
        
#         # Format the date column to exclude time and timezone
#         df['date'] = pd.to_datetime(df['date']).dt.date
        
#         # Add the processed_at column with the current timestamp
#         df['processed_at'] = datetime.now()

#         # Add ticker_date_id by concatenating ticker and date
#         df['ticker_date_id'] = df['ticker'].astype(str) + '_' + df['date'].astype(str)

#     return df  # Return the constructed DataFrame

# if __name__ == "__main__":
#     # Retrieve environment variable from Airflow
#     ENV = Variable.get("ENV", default_var="dev")

#     # Select tickers based on environment
#     SELECTED_TICKERS = TICKERS if ENV == "dev" else TICKERS_FULL

#     # Argument parser for optional start_date and end_date
#     parser = argparse.ArgumentParser(description="Fetch stock data.")
#     parser.add_argument("--start_date", help="Start date for data fetch (format YYYY-MM-DD)", required=False)
#     parser.add_argument("--end_date", help="End date for data fetch (format YYYY-MM-DD)", required=False)
#     args = parser.parse_args()

#     # Set default dates to today if not provided
#     today = datetime.now().strftime('%Y-%m-%d')
#     start_date = args.start_date if args.start_date else today
#     end_date = args.end_date if args.end_date else today

#     # Database table information
#     table_name = 'api_raw_data_ingestion'
#     key_columns = ['ticker_date_id']

#     # Retrieve connection string from environment variables
#     connection_string = os.getenv('DATABASE_URL')  # Updated to use DATABASE_URL
    
#     if connection_string is None:
#         logging.error("DATABASE_URL environment variable not set")
#         raise ValueError("DATABASE_URL environment variable not set")
    
#     # Optional: Adjust DATABASE_URL for SQLAlchemy compatibility
#     if connection_string.startswith("postgres://"):
#         connection_string = connection_string.replace("postgres://", "postgresql+psycopg2://", 1)
    
#     try:
#         # Process tickers in batches of specified size
#         batch_size = 50
#         ticker_batches = chunk_list(SELECTED_TICKERS, batch_size)
        
#         for batch in ticker_batches:
#             # Fetch data for the current batch
#             df = build_df(batch, start_date=start_date, end_date=end_date)
            
#             if not df.empty:
#                 logging.info(f"Data fetched for {len(df['ticker'].unique())} tickers in current batch.")
                
#                 # Optionally print the first few rows for verification
#                 print(df.head())
                
#                 # Save the DataFrame to the specified database table
#                 save_to_database(df, table_name, connection_string, schema_name='raw', key_columns=key_columns)
            
#             else:
#                 logging.info("No data fetched for any tickers in current batch; check if tickers are inactive or delisted.")
                
#     except Exception as e:
#         logging.exception("Unexpected error occurred")