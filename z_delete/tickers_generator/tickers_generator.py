import sys
from pathlib import Path
import yfinance as yf
import pandas as pd

# Add the directory to Python's search path
sys.path.insert(0, str(Path("/Users/kevin/Dropbox/applications/ELT/python/src/dev/config/exchanges")))

# Import the tickers variable from the russell2000 module
#from russell2000 import russell2000_tickers

# Function to fetch S&P 500 tickers from Wikipedia
def fetch_sp500_tickers():
    sp500_url = 'https://en.wikipedia.org/wiki/List_of_S%26P_500_companies'
    table = pd.read_html(sp500_url)[0]
    sp500_tickers = table['Symbol'].tolist()
    return [ticker.replace('.', '-') for ticker in sp500_tickers]

# Function to fetch NASDAQ tickers from Wikipedia
def fetch_nasdaq_tickers():
    nasdaq_tickers = [
        'AACG'
        ]
    return nasdaq_tickers

#Full list of Nasdaq tickers provided by you
def fetch_nasdaq_tickers():
    return nasdaq_tickers

# Function to fetch Dow Jones tickers from Wikipedia (enhanced for multiple tables)
def fetch_dow_tickers():
    dow_url = 'https://en.wikipedia.org/wiki/Dow_Jones_Industrial_Average'
    tables = pd.read_html(dow_url)  # Fetch all tables from the page
    
    for table in tables:
        if isinstance(table.columns[0], str):  # Check if the first column contains strings
            # Check if we can identify tickers based on typical column names
            for column in table.columns:
                if 'Symbol' in column or 'Ticker' in column or 'Component' in column:
                    print(f"Identified ticker column: {column}")
                    dow_tickers = table[column].tolist()
                    return [ticker.replace('.', '-') for ticker in dow_tickers]
        else:
            print(f"Skipping table with non-string columns: {table.columns}")

    print("No suitable ticker table found.")
    return []


# Full list of Russell 2000 tickers provided by you
# def fetch_russell2000_tickers():
#     return russell2000_tickers

# Fetch tickers for all indexes
sp500_tickers = fetch_sp500_tickers()
nasdaq_tickers = fetch_nasdaq_tickers()
dow_tickers = fetch_dow_tickers()
#russell2000_tickers = fetch_russell2000_tickers()

# Combine all tickers into one list and ensure no duplicates
#all_tickers = list(set(sp500_tickers + nasdaq_tickers + dow_tickers + russell2000_tickers))
all_tickers = list(set(sp500_tickers + nasdaq_tickers + dow_tickers ))

# Sort the tickers alphabetically (optional but helpful)
all_tickers.sort()

# Write the combined tickers to the config file
config_file_path = '/Users/kevin/Dropbox/applications/ELT/python/src/dev/config/config_2.py'

with open(config_file_path, 'w') as file:
    file.write(f"TICKERS = {all_tickers}\n")

# Optionally, fetch detailed data for all tickers
tickers_data = yf.download(all_tickers, period="1d")

# Display the first few rows of the data (for testing purposes)
print(tickers_data.head())

