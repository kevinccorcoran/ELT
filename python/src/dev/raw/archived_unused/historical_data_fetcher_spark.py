import warnings
warnings.filterwarnings("ignore", category=FutureWarning)

import os
import sys
import logging
from datetime import datetime
import yfinance as yf
import pandas as pd
import adbc_driver_postgresql.dbapi as pg_dbapi
from pyspark.sql import SparkSession
from pyspark.sql import functions as F

# Add your application directory to the system path
sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')

# Import configurations and helper functions
from dev.config.config import TICKERS
from dev.config.helpers import save_to_database

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Initialize Spark session
spark = SparkSession.builder.appName("StockDataFetcher").getOrCreate()

def fetch_ticker_data(ticker):
    """Fetch and process historical stock data for a given ticker."""
    try:
        stock_data = yf.Ticker(ticker)
        dx = stock_data.history(period="max")
        
        # Rename columns to lowercase
        dx.rename(columns={
            'Open': 'open',
            'High': 'high',
            'Low': 'low',
            'Close': 'close',
            'Adj Close': 'adj_close',
            'Volume': 'volume'
        }, inplace=True)
        
        # Convert columns to numeric and handle NaNs
        dx['open'] = pd.to_numeric(dx['open'], errors='coerce').round(2)
        dx['high'] = pd.to_numeric(dx['high'], errors='coerce').round(2)
        dx['low'] = pd.to_numeric(dx['low'], errors='coerce').round(2)
        dx['close'] = pd.to_numeric(dx['close'], errors='coerce').round(2)
        if 'adj_close' in dx.columns:
            dx['adj_close'] = pd.to_numeric(dx['adj_close'], errors='coerce').round(2)
        dx['volume'] = pd.to_numeric(dx['volume'], errors='coerce')
        
        # Add ticker and format date
        dx['ticker'] = ticker
        dx.reset_index(inplace=True)
        dx.rename(columns={'Date': 'date'}, inplace=True)
        dx['date'] = pd.to_datetime(dx['date']).dt.date
        
        # Add the processed_at column
        dx['processed_at'] = datetime.now()
        
        return dx
    except Exception as e:
        logging.error(f"Error fetching data for ticker {ticker}: {str(e)}")
        return pd.DataFrame()  # Return an empty DataFrame on failure

def build_df(tickers):
    """Fetch and process data for all tickers in parallel using Spark."""
    try:
        # Create an RDD of tickers and process them in parallel
        rdd = spark.sparkContext.parallelize(tickers)
        ticker_data_rdd = rdd.map(lambda ticker: fetch_ticker_data(ticker))
        
        # Collect all the DataFrames
        ticker_data_list = ticker_data_rdd.collect()
        
        # Concatenate all the DataFrames into one
        df = pd.concat(ticker_data_list, sort=False)
        
        return df
    except Exception as e:
        logging.exception("Error building DataFrame")
        raise

if __name__ == "__main__":
    table_name = 'history_data_fetcher_spark'  # Name of the table to create or replace
    
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
            
            # Convert Pandas DataFrame to Spark DataFrame for further processing
            spark_df = spark.createDataFrame(df)
            
            # Save the Spark DataFrame to the specified table in the database
            save_to_database(spark_df, table_name, connection_string, schema_name='raw')
        except Exception as e:
            logging.exception("Unexpected error occurred")
