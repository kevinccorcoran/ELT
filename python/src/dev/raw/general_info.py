import pandas as pd
import yfinance as yf

def build_info_df(tickers):
    # Initialize an empty list to collect the data rows
    data = []

    for ticker in tickers:
        # Fetch the ticker object
        stock = yf.Ticker(ticker)

        # Access the 'info' dictionary
        info = stock.info

        # Extract the desired fields
        symbol = info.get('symbol', 'N/A')
        industry = info.get('industry', 'N/A')
        sector = info.get('sector', 'N/A')

        # Append the extracted data as a dictionary to the list
        data.append({'symbol': symbol, 'industry': industry, 'sector': sector})

    # Create a DataFrame from the list of dictionaries
    df = pd.DataFrame(data)
    return df

if __name__ == "__main__":
    tickers = ['MSFT']  # Example tickers
    df = build_info_df(tickers)
    print(df)
