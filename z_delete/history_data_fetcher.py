# Standard library imports
from datetime import datetime
import logging
import os
from pandas.tseries.offsets import DateOffset

# Related third-party imports
import adbc_driver_postgresql.dbapi as pg_dbapi
from sqlalchemy import create_engine
import pandas as pd
import yfinance as yf

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def build_df(tickers):
    try:
        df = pd.DataFrame()
        for ticker in tickers:
            # Fetch stock data
            stock_data = yf.Ticker(ticker)
            dx = stock_data.history(period="max")  # Fetch historical data for 1 year
            
            # Rename columns
            dx.rename(columns={
                'Open': 'open',
                'High': 'high',
                'Low': 'low',
                'Close': 'close',
                'Adj Close': 'adj_close',
                'Volume': 'volume'
            }, inplace=True)
            
            # Round the necessary columns
            dx['open'] = dx['open'].round(2)
            dx['high'] = dx['high'].round(2)
            dx['low'] = dx['low'].round(2)
            dx['close'] = dx['close'].round(2)
            
            # Check if 'adj_close' column exists before rounding
            if 'adj_close' in dx.columns:
                dx['adj_close'] = dx['adj_close'].round(2)
            
            # Add a column to identify the ticker
            dx['ticker'] = ticker
            
            # Concatenate the dataframes
            if df.empty:
                df = dx
            else:
                df = pd.concat([df, dx], sort=False)
        
        # Reset index and rename date column
        df.reset_index(inplace=True)
        df.rename(columns={'Date': 'date'}, inplace=True)

        # Format the date column to exclude time and timezone
        df['date'] = pd.to_datetime(df['date']).dt.date
        
        return df
    except Exception as e:
        logging.exception("Error building DataFrame")
        raise

if __name__ == "__main__":
    tickers = ['MSFT']  # Define the tickers you want to retrieve
    df = build_df(tickers)
    print(df)

    # # Filter the DataFrame for a specific date
    # specific_date = '2021-11-17'
    # df_filtered = df[df['date'] == specific_date]
    
    # # Display the filtered DataFrame
    # print(f"Data for {specific_date}:\n", df_filtered)
