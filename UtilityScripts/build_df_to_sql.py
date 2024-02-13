import pandas as pd
import yfinance as yf
from sqlalchemy import create_engine

import logging 

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def build_df(tickers):
    try:
        df = pd.DataFrame()
        for ticker in tickers:
            dx = yf.download(ticker, progress=True)
            dx.rename(columns={'Open': 'open',
                               'High': 'high',
                               'Low': 'low',
                               'Close': 'close',
                               'Adj Close': 'adj_close',
                               'Volume': 'volume'}, inplace=True)
            dx['ticker'] = ticker  # Add ticker column to the DataFrame
            if df.empty:
                df = dx
            else:
                df = pd.concat([df, dx])
        df.reset_index(inplace=True)  # Reset index to make 'Date' a column
        return df
    except Exception as e:
        logging.exception("Error building DataFrame")
        raise

def save_to_database(df, table_name, connection_string):
    try:
        engine = create_engine(connection_string)
        df.to_sql(table_name, engine, if_exists='replace', schema='raw', index=False)
        logging.info(f"Data successfully saved to {table_name}")
    except Exception as e:
        logging.exception("Failed to save data to database")

if __name__ == "__main__":
    tickers = ['^GSPC']  # Example ticker
    table_name = 'historical_daily_master'
    connection_string = 'postgresql://postgres:9356@localhost:5433/cp'
    
    try:
        result_df = build_df(tickers)
        print(result_df)
        save_to_database(result_df, table_name, connection_string)
    except Exception as e:
        logging.exception("Unexpected error occurred")
=======
from contextlib import suppress
import sys

import logging
try:
    # tickers = ['VIX','^GSPC','GD=F','CL=F','GC=F','^TNX', 'ZC=F','PA=F','ZS=F','LBS=F','ZW=F','HG=F']
    tickers = ['^GSPC']

    # tickers = ['ABNB']
    def build_df(tickers):
        df = pd.DataFrame(yf.download(tickers[0],
                                      # start='2000-01-01',
                                      # end='2022-12-31',
                                      progress='True'))
        df.rename(columns={'Date': 'date',
                           'Open': 'open',
                           'High': 'high',
                           'Low': 'low',
                           'Close': 'close',
                           'Adj Close': 'adjclose',
                           'Volume': 'volume'}, inplace=True)
        df.insert(0, 'TICKER', tickers[0])
        for ticker in tickers[1:]:
            dx = pd.DataFrame(yf.download(ticker,
                                          # start='2000-01-01',
                                          # end='2022-12-31',
                                          progress='True'))
            dx.insert(0, 'TICKER', ticker)
            dx.rename(columns={'Date': 'date',
                               'Open': 'open',
                               'High': 'high',
                               'Low': 'low',
                               'Close': 'close',
                               'Adj Close': 'adjclose',
                               'Volume': 'volume'}, inplace=True)
            df = pd.concat([df, dx])
        return df

    result = build_df(tickers)

    print(result)

    engine = create_engine('postgresql://postgres:9356@localhost:5433/QA')
    result.to_sql('historical_daily_master_staging', engine,
                  if_exists='replace', schema='stats')


except Exception as e:
    # log exception info at CRITICAL log level
    logging.NOTSET(e, exc_info=True)

