#works well with pandas
import warnings
import os
import sys
import logging
import argparse
from datetime import datetime
import yfinance as yf
import pandas as pd
import adbc_driver_postgresql.dbapi as pg_dbapi

# Suppress FutureWarnings from libraries
warnings.filterwarnings("ignore", category=FutureWarning)

# Add your application directory to the system path
sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')

# Import configurations and helper functions
from dev.config.config import TICKERS
from dev.config.helpers import save_to_database

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def chunk_list(lst, n):
    """Yield successive n-sized chunks from lst."""
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
            
            # Fetch historical data within the date range if provided, otherwise fetch max period
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
            
            # Concatenate the dataframes
            df = pd.concat([df, dx], sort=False)
        
        except Exception as e:
            logging.warning(f"Error processing ticker {ticker}: {e}")
    
    # Reset index and rename date column
    if not df.empty:
        df.reset_index(inplace=True)
        df.rename(columns={'Date': 'date'}, inplace=True)
        
        # Format the date column to exclude time and timezone
        df['date'] = pd.to_datetime(df['date']).dt.date
        
        # Add the processed_at column with the current timestamp
        df['processed_at'] = datetime.now()

        # Add ticker_date_id by concatenating ticker and date
        df['ticker_date_id'] = df['ticker'].astype(str) + '_' + df['date'].astype(str)

    return df  # Return the constructed DataFrame

if __name__ == "__main__":
    # Argument parser to take optional start_date and end_date
    parser = argparse.ArgumentParser(description="Fetch stock data.")
    parser.add_argument("--start_date", help="Start date for data fetch (format YYYY-MM-DD)", required=False)
    parser.add_argument("--end_date", help="End date for data fetch (format YYYY-MM-DD)", required=False)
    args = parser.parse_args()

    # Set dates to today if not provided
    today = datetime.now().strftime('%Y-%m-%d')
    start_date = args.start_date if args.start_date else today
    end_date = args.end_date if args.end_date else today

    table_name = 'api_raw_data_ingestion'  # Name of the table to create or replace
    key_columns = ['ticker_date_id']  # Key columns to check for duplicates

    # Retrieve connection string from environment variables
    connection_string = os.getenv('DB_CONNECTION_STRING')
    
    if connection_string is None:
        logging.error("DB_CONNECTION_STRING environment variable not set")
    else:
        try:
            # Process tickers in batches of 30
            batch_size = 100
            ticker_batches = chunk_list(TICKERS, batch_size)
            
            for batch in ticker_batches:
                # Fetch the data for the current batch
                df = build_df(batch, start_date=start_date, end_date=end_date)
                if not df.empty:
                    logging.info(f"Data fetched for {len(df['ticker'].unique())} tickers in current batch.")
                    # Optionally print the first few rows for verification
                    print(df.head())
                    
                    # Save the DataFrame to the specified table in the database
                    save_to_database(df, table_name, connection_string, schema_name='raw', key_columns=key_columns)
                else:
                    logging.info("No data fetched for any tickers in current batch; check if tickers are inactive or delisted.")
                    
        except Exception as e:
            logging.exception("Unexpected error occurred")


# # works but slow
# import warnings
# import os
# import sys
# import logging
# import argparse
# from datetime import datetime, timedelta
# import yfinance as yf
# import pandas as pd
# from pyspark.sql import SparkSession
# from pyspark.sql import functions as F
# from pyspark.sql.window import Window
# import time
# import concurrent.futures

# # Suppress warnings
# warnings.filterwarnings("ignore", category=FutureWarning)

# # Add your application directory to the system path
# sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')

# # Import configurations and helper functions
# from dev.config.config import TICKERS

# # Set up Spark session with optimized settings
# spark = SparkSession.builder \
#     .appName("StockDataProcessing") \
#     .master("local[4]") \
#     .config("spark.driver.memory", "4g") \
#     .config("spark.executor.memory", "4g") \
#     .config("spark.sql.shuffle.partitions", "4") \
#     .config("spark.sql.adaptive.enabled", "true") \
#     .config("spark.jars", "/Users/kevin/Dropbox/applications/ELT/jars/postgresql-42.7.4.jar") \
#     .getOrCreate()

# # Configure logging
# logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# def fetch_ticker_data(ticker, start_date, end_date):
#     try:
#         # Fetch data using yfinance
#         stock_data = yf.Ticker(ticker)
#         dx = stock_data.history(start=start_date, end=end_date)
#         if dx.empty:
#             logging.warning(f"No data found for ticker {ticker}, it may be delisted or inactive.")
#             return None

#         dx = dx.rename(columns={
#             'Open': 'open',
#             'High': 'high',
#             'Low': 'low',
#             'Close': 'close',
#             'Adj Close': 'adj_close',
#             'Volume': 'volume'
#         }).reset_index()

#         dx['ticker'] = ticker
#         dx['processed_at'] = datetime.now()
#         dx['ticker_date_id'] = dx['ticker'] + "_" + dx['Date'].astype(str)
#         return dx

#     except Exception as e:
#         logging.warning(f"Error processing ticker {ticker}: {e}")
#         return None

# def build_spark_df(tickers, start_date=None, end_date=None):
#     all_data = []

#     with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
#         futures = [executor.submit(fetch_ticker_data, ticker, start_date, end_date) for ticker in tickers]
#         for future in concurrent.futures.as_completed(futures):
#             data = future.result()
#             if data is not None:
#                 all_data.append(data)

#     if all_data:
#         combined_df = pd.concat(all_data, ignore_index=True)
#         spark_df = spark.createDataFrame(combined_df)
#         return spark_df
#     else:
#         return None

# if __name__ == "__main__":
#     parser = argparse.ArgumentParser(description="Fetch stock data.")
#     parser.add_argument("--start_date", help="Start date for data fetch (format YYYY-MM-DD)", required=False)
#     parser.add_argument("--end_date", help="End date for data fetch (format YYYY-MM-DD)", required=False)
#     args = parser.parse_args()

#     # Set default date range to the last 30 days if not provided
#     default_start_date = (datetime.now() - timedelta(days=30)).strftime('%Y-%m-%d')
#     start_date = args.start_date or default_start_date
#     end_date = args.end_date or datetime.now().strftime('%Y-%m-%d')

#     # Use tickers from imported config
#     tickers = TICKERS

#     # Fetch data as Spark DataFrame
#     spark_df = build_spark_df(tickers, start_date=start_date, end_date=end_date)

#     if spark_df:
#         # Repartition DataFrame before writing
#         num_partitions = 4  # Adjust based on your system
#         spark_df = spark_df.repartition(num_partitions)

#         # Define a smaller batch size for database writes
#         batch_size = 5000

#         # Add a row number column for batch processing
#         window_spec = Window.orderBy("ticker_date_id")
#         spark_df = spark_df.withColumn("row_num", F.row_number().over(window_spec))

#         # Calculate the number of batches
#         total_rows = spark_df.count()
#         num_batches = (total_rows // batch_size) + (1 if total_rows % batch_size != 0 else 0)

#         # Save in batches to PostgreSQL
#         db_url = "jdbc:postgresql://localhost:5433/staging"
#         db_properties = {
#             "user": "postgres",
#             "password": "9356",
#             "driver": "org.postgresql.Driver",
#             "batchsize": "5000"
#         }

#         # Retry configuration
#         max_retries = 3
#         retry_delay = 5  # seconds

#         for i in range(num_batches):
#             # Define start and end for each batch
#             start_idx = i * batch_size + 1
#             end_idx = start_idx + batch_size - 1

#             # Filter the DataFrame for the current batch
#             batch_df = spark_df.filter((F.col("row_num") >= start_idx) & (F.col("row_num") <= end_idx)).drop("row_num")

#             attempt = 0
#             success = False

#             logging.info(f"Starting insertion for batch {i + 1} of {num_batches}, rows {start_idx} to {end_idx}")

#             while attempt < max_retries and not success:
#                 try:
#                     # Attempt to write the batch to the database
#                     batch_df.write \
#                         .jdbc(url=db_url, table="raw.api_raw_data_ingestion", mode="append", properties=db_properties)

#                     logging.info(f"Successfully inserted batch {i + 1} of {num_batches}, rows {start_idx} to {end_idx}")
#                     success = True  # Mark as successful to exit retry loop

#                 except Exception as e:
#                     attempt += 1
#                     logging.warning(f"Attempt {attempt} failed for batch {i + 1} of {num_batches} due to error: {e}")

#                     if attempt < max_retries:
#                         logging.info(f"Retrying in {retry_delay} seconds...")
#                         time.sleep(retry_delay)
#                     else:
#                         logging.error(f"Batch {i + 1} failed after {max_retries} attempts.")

#     else:
#         logging.info("No data to insert into the database.")

#     # Stop Spark session
#     spark.stop()





# import warnings
# import os
# import sys
# import logging
# import argparse
# from datetime import datetime
# import yfinance as yf
# import pandas as pd
# import adbc_driver_postgresql.dbapi as pg_dbapi

# # Suppress FutureWarnings from libraries
# warnings.filterwarnings("ignore", category=FutureWarning)

# # Add your application directory to the system path
# sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')

# # Import configurations and helper functions
# from dev.config.config import TICKERS
# from dev.config.helpers import save_to_database

# # Configure logging
# logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

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
            
#             # Fetch historical data within the date range if provided, otherwise fetch max period
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
            
#             # Concatenate the dataframes
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
#     # Argument parser to take optional start_date and end_date
#     parser = argparse.ArgumentParser(description="Fetch stock data.")
#     parser.add_argument("--start_date", help="Start date for data fetch (format YYYY-MM-DD)", required=False)
#     parser.add_argument("--end_date", help="End date for data fetch (format YYYY-MM-DD)", required=False)
#     args = parser.parse_args()

#     # Set dates to today if not provided
#     today = datetime.now().strftime('%Y-%m-%d')
#     start_date = args.start_date if args.start_date else today
#     end_date = args.end_date if args.end_date else today

#     table_name = 'api_raw_data_ingestion'  # Name of the table to create or replace
#     key_columns = ['ticker_date_id']  # Key columns to check for duplicates

#     # Retrieve connection string from environment variables
#     connection_string = os.getenv('DB_CONNECTION_STRING')
    
#     if connection_string is None:
#         logging.error("DB_CONNECTION_STRING environment variable not set")
#     else:
#         try:
#             # Fetch the data for the specified date range
#             df = build_df(TICKERS, start_date=start_date, end_date=end_date)
#             if not df.empty:
#                 logging.info(f"Data fetched for {len(df['ticker'].unique())} tickers with records.")
#                 print(df.head())  # Optionally print the first few rows for verification
                
#                 # Save the DataFrame to the specified table in the database
#                 save_to_database(df, table_name, connection_string, schema_name='raw', key_columns=key_columns)
#             else:
#                 logging.info("No data fetched for any tickers; check if tickers are inactive or delisted.")
                
#         except Exception as e:
#             logging.exception("Unexpected error occurred")
