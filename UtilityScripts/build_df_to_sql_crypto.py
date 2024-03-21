import os
import pandas as pd
import yfinance as yf
from sqlalchemy import create_engine
import logging
from datetime import datetime
import adbc_driver_postgresql.dbapi as pg_dbapi



# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def build_df(tickers):
    try:
        df = pd.DataFrame()
        for ticker in tickers:
            dx = yf.download(ticker, progress=True)
            dx.rename(columns={
                'Open': 'open',
                'High': 'high',
                'Low': 'low',
                'Close': 'close',
                'Adj Close': 'adj_close',
                'Volume': 'volume'
            }, inplace=True)
            dx['ticker'] = ticker
            if df.empty:
                df = dx
            else:
                df = pd.concat([df, dx], sort=False)
        df.reset_index(inplace=True)
        df.rename(columns={'Date': 'date'}, inplace=True)
        return df
    except Exception as e:
        logging.exception("Error building DataFrame")
        raise

def save_to_database(df, table_name, connection_string):
    try:
        with pg_dbapi.connect(connection_string) as conn:
            with conn.cursor() as cur: # Use a cursor object
                cur.execute("SET search_path TO raw;") # Execute the statement using the cursor
                df['processed_at'] = datetime.now()
                df.to_sql(table_name, conn, if_exists='replace'
                , index=False)
            logging.info(f"Data successfully saved to {table_name}")
    except Exception as e:
        logging.exception("Failed to save data to database")


if __name__ == "__main__":
    tickers = ['ETH-USD']
    #tickers = ['^GSPC', 'MSFT']
    table_name = 'crypto_main'
    
    # Retrieve connection string from environment variables
    connection_string = os.getenv('DB_CONNECTION_STRING')
    
    if connection_string is None:
        logging.error("DB_CONNECTION_STRING environment variable not set")
    else:
        try:
            result_df = build_df(tickers)
            print(result_df.head())
            save_to_database(result_df, table_name, connection_string)
        except Exception as e:
            logging.exception("Unexpected error occurred")
