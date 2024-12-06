import sys
import os
import pandas as pd
from pandas.tseries.offsets import DateOffset
from datetime import datetime
import adbc_driver_postgresql.dbapi as pg_dbapi

# Add application directory and utils to system path
sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')
sys.path.append(os.path.join(os.path.dirname(__file__), '../utils'))

# Import custom modules
from dev.config.config import TICKERS
from dev.config.fibonacci import cumulative_fibonacci
from dev.config.helpers import save_to_database, fetch_data_from_database

def get_next_trading_day(date):
    """Returns the next available trading day."""
    return pd.bdate_range(date, periods=1)[0].date()

def process_stock_data(df, years_to_add=3):
    """Processes the stock data to find and extend minimum dates for each ticker."""
    
    # Ensure 'date' column is in datetime.date format to prevent merging errors
    df['date'] = pd.to_datetime(df['date']).dt.date

    # Group by 'ticker' and select the minimum date for each group
    min_dates = df.groupby('ticker')['date'].min().reset_index()

    # Initialize a list to store all the dataframes
    all_years_dfs = [min_dates]  # Start with the minimum dates (unshifted)

    # Loop through the range to add multiple years
    for year in range(1, years_to_add + 1):
        min_dates_shifted = min_dates.copy()
        min_dates_shifted['date'] = min_dates_shifted['date'] + DateOffset(years=year)
        min_dates_shifted['date'] = min_dates_shifted['date'].apply(get_next_trading_day)

        # Ensure consistent 'date' format before merging
        min_dates_shifted['date'] = pd.to_datetime(min_dates_shifted['date']).dt.date

        # Merge with the original DataFrame to get other columns for the shifted dates
        shifted_df = pd.merge(min_dates_shifted, df, on=['ticker', 'date'], how='left')[['ticker', 'date']]
        all_years_dfs.append(shifted_df)

    # Concatenate all DataFrames
    result_df = pd.concat(all_years_dfs, ignore_index=True)

    # Ensure all dates are in datetime.date format
    result_df['date'] = pd.to_datetime(result_df['date']).dt.date
    result_df.dropna(inplace=True)

    # Add a row number partitioned by 'ticker' and ordered by 'date'
    result_df['row_number'] = result_df.sort_values('date').groupby('ticker').cumcount()

    return result_df

if __name__ == "__main__":
    schema_name = 'raw'  # Define the schema where the table is located
    table_name = 'api_raw_data_ingestion'  # Table to fetch data from
    new_table_name = 'date_lookup'  # Table to save processed data

    # Retrieve connection string from environment variables
    connection_string = os.getenv('DB_CONNECTION_STRING')

    if connection_string is None:
        print("DB_CONNECTION_STRING environment variable not set")
    else:
        try:
            # Fetch the full dataset
            df = fetch_data_from_database(schema_name, table_name, connection_string)

            if df is not None:
                # Split the tickers into batches of 100
                unique_tickers = df['ticker'].unique()
                ticker_batches = [unique_tickers[i:i + 10] for i in range(0, len(unique_tickers), 10)]

                for batch_num, ticker_batch in enumerate(ticker_batches, start=1):
                    print(f"Processing batch {batch_num} with {len(ticker_batch)} tickers...")

                    # Filter the DataFrame for the current batch of tickers
                    batch_df = df[df['ticker'].isin(ticker_batch)]

                    # Process the batch data
                    result_df = process_stock_data(batch_df, years_to_add=100)

                    # Generate the cumulative Fibonacci series for filtering
                    cumulative_fib_sequence = cumulative_fibonacci(len(result_df))

                    # Filter the result_df to only include rows with 'row_number' in the Fibonacci series
                    matching_rows = result_df[result_df['row_number'].isin(cumulative_fib_sequence)].copy()

                    # Sort the DataFrame by ticker before saving
                    matching_rows = matching_rows.sort_values(by=['ticker', 'date', 'row_number'], ascending=True)

                    # Save the filtered and sorted DataFrame for the current batch
                    save_to_database(matching_rows, new_table_name, connection_string, 'cdm', ['ticker', 'date'])

                    # Optional: Log progress
                    print(f"Batch {batch_num} saved successfully.")

                print("All batches processed and saved successfully.")
            else:
                print("No data fetched from the database.")
        except Exception as e:
            print("Unexpected error occurred:", e)
