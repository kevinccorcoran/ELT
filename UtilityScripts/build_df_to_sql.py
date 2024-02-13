# Working script 11/16

import pandas as pd
import yfinance as yf
import os
import json
from sqlalchemy import create_engine
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
