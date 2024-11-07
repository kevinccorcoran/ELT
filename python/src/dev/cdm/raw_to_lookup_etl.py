import os
import sys
from pyspark.sql import SparkSession
from pyspark.sql.functions import min as spark_min, col, row_number, expr, explode
from pyspark.sql.window import Window
from pyspark.sql.functions import broadcast
from dev.config.fibonacci import cumulative_fibonacci
from dev.config.helpers import save_to_database

# Set up environment and database connection
os.environ["JAVA_HOME"] = "/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home"
sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src')

# PostgreSQL JDBC connection details
connection_string = "jdbc:postgresql://localhost:5433/staging"
db_user = "postgres"
db_password = "9356"
postgres_jar_path = "/Users/kevin/Dropbox/applications/ELT/jars/postgresql-42.7.4.jar"

# Initialize Spark session
spark = SparkSession.builder \
    .appName("StockDataProcessing") \
    .config("spark.jars", postgres_jar_path) \
    .config("spark.driver.memory", "8g") \
    .config("spark.executor.memory", "8g") \
    .config("spark.sql.shuffle.partitions", "200") \
    .getOrCreate()

try:
    # Load data from PostgreSQL
    df = spark.read \
        .format("jdbc") \
        .option("url", connection_string) \
        .option("dbtable", "raw.api_raw_data_ingestion") \
        .option("user", db_user) \
        .option("password", db_password) \
        .option("driver", "org.postgresql.Driver") \
        .load()
    

    # Load existing records from the target table to avoid duplicates
    existing_df = spark.read \
        .format("jdbc") \
        .option("url", connection_string) \
        .option("dbtable", "cdm.date_lookup") \
        .option("user", db_user) \
        .option("password", db_password) \
        .option("driver", "org.postgresql.Driver") \
        .load() \
        .select("ticker", "date")

    # Step 1: Get minimum date per ticker
    min_dates_df = df.groupBy("ticker").agg(spark_min("date").alias("min_date"))

    # Step 2: Create a sequence of dates starting from min_date with a range of additional years
    years_to_add = 100  # Adjust years_to_add as needed
    date_sequences = min_dates_df.withColumn("date_sequence", 
                                             expr(f"sequence(min_date, min_date + interval {years_to_add} year, interval 1 year)"))

    # Step 3: Explode date_sequence to create rows for each date
    date_df = date_sequences.select("ticker", explode("date_sequence").alias("date"))

    # Step 4: Assign row numbers within each ticker group
    window_spec = Window.partitionBy("ticker").orderBy("date")
    date_df = date_df.withColumn("row_number", row_number().over(window_spec))

    # Step 5: Generate Fibonacci sequence and filter rows
    row_count = date_df.count()
    fib_sequence = cumulative_fibonacci(row_count)
    fib_df = spark.createDataFrame([(num,) for num in fib_sequence], ["row_number"])

    # Filter date_df to only keep rows with row_number in Fibonacci sequence
    result_df = date_df.join(fib_df, "row_number", "inner")

    # Step 6: Remove records that already exist in the target table
    new_records_df = result_df.join(broadcast(existing_df), on=["ticker", "date"], how="left_anti")

    # Step 7: Write new records to PostgreSQL with batch optimization
    new_records_df.coalesce(1).write \
        .format("jdbc") \
        .option("url", connection_string) \
        .option("dbtable", "cdm.date_lookup") \
        .option("user", db_user) \
        .option("password", db_password) \
        .option("driver", "org.postgresql.Driver") \
        .option("batchsize", "10000") \
        .mode("append") \
        .save()

    print("New records successfully saved to the database.")

except Exception as e:
    print("Unexpected error occurred:", e)

finally:
    spark.stop()






# WORKS
# import sys
# import os
# import pandas as pd
# from pandas.tseries.offsets import DateOffset
# from datetime import datetime
# import adbc_driver_postgresql.dbapi as pg_dbapi

# # Add application directory and utils to system path
# sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')
# sys.path.append(os.path.join(os.path.dirname(__file__), '../utils'))

# # Import custom modules
# from dev.config.config import TICKERS
# from dev.config.fibonacci import cumulative_fibonacci
# from dev.config.helpers import save_to_database, fetch_data_from_database

# def get_next_trading_day(date):
#     """Returns the next available trading day."""
#     return pd.bdate_range(date, periods=1)[0].date()

# def process_stock_data(df, years_to_add=3):
#     """Processes the stock data to find and extend minimum dates for each ticker."""
    
#     # Ensure 'date' column is in datetime.date format to prevent merging errors
#     df['date'] = pd.to_datetime(df['date']).dt.date

#     # Group by 'ticker' and select the minimum date for each group
#     min_dates = df.groupby('ticker')['date'].min().reset_index()

#     # Initialize a list to store all the dataframes
#     all_years_dfs = [min_dates]  # Start with the minimum dates (unshifted)

#     # Loop through the range to add multiple years
#     for year in range(1, years_to_add + 1):
#         min_dates_shifted = min_dates.copy()
#         min_dates_shifted['date'] = min_dates_shifted['date'] + DateOffset(years=year)
#         min_dates_shifted['date'] = min_dates_shifted['date'].apply(get_next_trading_day)

#         # Ensure consistent 'date' format before merging
#         min_dates_shifted['date'] = pd.to_datetime(min_dates_shifted['date']).dt.date

#         # Merge with the original DataFrame to get other columns for the shifted dates
#         shifted_df = pd.merge(min_dates_shifted, df, on=['ticker', 'date'], how='left')[['ticker', 'date']]
#         all_years_dfs.append(shifted_df)

#     # Concatenate all DataFrames
#     result_df = pd.concat(all_years_dfs, ignore_index=True)

#     # Ensure all dates are in datetime.date format
#     result_df['date'] = pd.to_datetime(result_df['date']).dt.date
#     result_df.dropna(inplace=True)

#     # Add a row number partitioned by 'ticker' and ordered by 'date'
#     result_df['row_number'] = result_df.sort_values('date').groupby('ticker').cumcount()

#     return result_df

# if __name__ == "__main__":
#     schema_name = 'raw'  # Define the schema where the table is located
#     table_name = 'api_raw_data_ingestion'  # Table to fetch data from
#     new_table_name = 'date_lookup'  # Table to save processed data

#     # Retrieve connection string from environment variables
#     connection_string = os.getenv('DB_CONNECTION_STRING')

#     if connection_string is None:
#         print("DB_CONNECTION_STRING environment variable not set")
#     else:
#         try:
#             # Fetch the data from the database
#             df = fetch_data_from_database(schema_name, table_name, connection_string)

#             if df is not None:
#                 # Process the fetched data and specify the number of years to add
#                 result_df = process_stock_data(df, years_to_add=100)

#                 # Generate the cumulative Fibonacci series for filtering
#                 cumulative_fib_sequence = cumulative_fibonacci(len(result_df))

#                 # Filter the result_df to only include rows with 'row_number' in the Fibonacci series
#                 matching_rows = result_df[result_df['row_number'].isin(cumulative_fib_sequence)].copy()

#                 # Sort the DataFrame by ticker before saving
#                 matching_rows = matching_rows.sort_values(by=['ticker', 'date', 'row_number'], ascending=True)

#                 # Save the filtered and sorted DataFrame to the specified table in the 'cdm' schema
#                 save_to_database(matching_rows, new_table_name, connection_string, 'cdm', ['ticker', 'date'])

#                 # Display the resulting sorted and filtered DataFrame
#                 print(matching_rows)
#             else:
#                 print("No data fetched from the database.")
#         except Exception as e:
#             print("Unexpected error occurred:", e)
