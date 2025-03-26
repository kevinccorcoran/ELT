import os
import sys
import pandas as pd
import polars as pl
from datetime import timedelta
from dev.config.fibonacci import cumulative_fibonacci
from dev.config.helpers import save_to_database
from airflow.models import Variable

# Set up environment and add application path
sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src')

# Retrieve environment-specific connection string variable
env = Variable.get("ENV", default_var="staging")
if env == "dev":
    db_connection_string = Variable.get("JDBC_DEV_DB_CONNECTION_STRING")
elif env == "staging":
    db_connection_string = Variable.get("JDBC_STAGING_DB_CONNECTION_STRING")
else:
    raise ValueError("Invalid environment specified")

# Retrieve database user and password from Airflow Variables
db_user = Variable.get("DB_USER")
db_password = Variable.get("DB_PASSWORD")

# Fetch data from the database using pandas and convert to Polars
def fetch_data(schema_name, table_name, connection_string):
    # Use pandas to fetch the data from the database
    query = f"SELECT * FROM {schema_name}.{table_name}"
    data = pd.read_sql(query, connection_string)
    # Convert to a Polars DataFrame
    return pl.DataFrame(data)

# Load data from PostgreSQL
df = fetch_data("raw", "api_data_ingestion", db_connection_string)

# Load existing records to avoid duplicates
existing_df = fetch_data("cdm", "date_lookup", db_connection_string).select(["ticker", "date"])

# Step 1: Get minimum date per ticker
min_dates_df = df.groupby("ticker").agg(pl.col("date").min().alias("min_date"))

# Step 2: Create a sequence of dates starting from min_date with a range of additional years
years_to_add = 100
date_sequences = []
for row in min_dates_df.iter_rows(named=True):
    ticker = row["ticker"]
    min_date = row["min_date"]
    dates = [min_date + timedelta(days=365 * i) for i in range(years_to_add)]
    date_sequences.extend([(ticker, date) for date in dates])

# Convert date sequences to Polars DataFrame
date_df = pl.DataFrame(date_sequences, schema=["ticker", "date"])

# Step 3: Assign row numbers within each ticker group
date_df = date_df.with_column(
    pl.col("date").rank("ordinal").over("ticker").alias("row_number")
)

# Step 4: Generate Fibonacci sequence and filter rows
row_count = date_df.shape[0]
fib_sequence = cumulative_fibonacci(row_count)
fib_df = pl.DataFrame({"row_number": fib_sequence})

# Filter date_df to only keep rows with row_number in Fibonacci sequence
result_df = date_df.join(fib_df, on="row_number", how="inner")

# Step 5: Remove records that already exist in the target table
new_records_df = result_df.join(existing_df, on=["ticker", "date"], how="anti")

# Step 6: Write new records to PostgreSQL with batch optimization
save_to_database(new_records_df, "date_lookup", db_connection_string, "cdm", ["ticker", "date"])

print("New records successfully saved to the database.")
