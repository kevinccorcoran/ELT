import os
import pandas as pd
import yfinance as yf
from sqlalchemy import create_engine
import logging
from datetime import datetime  # Import the datetime module

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
            dx['ticker'] = ticker  # Add ticker column to the DataFrame
            if df.empty:
                df = dx
            else:
                df = pd.concat([df, dx])
        df.reset_index(inplace=True)  # Reset index to make 'Date' a column
        df.rename(columns={'Date': 'date'}, inplace=True)  # Rename 'Date' column to 'date'
        return df
    except Exception as e:
        logging.exception("Error building DataFrame")
        raise

def save_to_database(df, table_name, connection_string):
    try:
        engine = create_engine(connection_string)
        df['processed_at'] = datetime.now()  # Add processed_at column with the current timestamp
        df.to_sql(table_name, engine, if_exists='replace', schema='raw', index=False)
        logging.info(f"Data successfully saved to {table_name}")
    except Exception as e:
        logging.exception("Failed to save data to database")

if __name__ == "__main__":
    tickers = ['^GSPC', 'MSFT']  # Example tickers
    table_name = 'historical_daily_master'
    connection_string = os.getenv('DB_CONNECTION_STRING')

    try:
        result_df = build_df(tickers)
        print(result_df)
        save_to_database(result_df, table_name, connection_string)
    except Exception as e:
        logging.exception("Unexpected error occurred")
