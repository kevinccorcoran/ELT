import sys
import os
import polars as pl
import psycopg2
import io

sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')

connection_string = os.getenv('DB_CONNECTION_STRING')
if not connection_string:
    print("DB_CONNECTION_STRING environment variable not set")
    sys.exit(1)

try:
    with psycopg2.connect(connection_string) as conn:
        schema_name = 'raw'
        table_name = 'api_raw_data_ingestion'

        query = f"SELECT * FROM {schema_name}.{table_name}"
        with conn.cursor() as cursor:
            cursor.execute(query)
            data = cursor.fetchall()
            colnames = [desc[0] for desc in cursor.description]

        # Log initial data
        print("Sample data:", data[:5])
        print("Column names:", colnames)

        # Create Polars DataFrame
        pl_df = pl.DataFrame(data, schema=colnames, orient="row")
        print("Initial DataFrame Schema:", pl_df.schema)
        print("Sample Initial Rows:", pl_df.head())

        # Transform DataFrame
        pl_df = pl_df.with_columns([
            pl.col("volume").fill_null(0).alias("volume"),
            pl.col("open").fill_null(-1).alias("open"),
            pl.col("close").fill_null(-1).alias("close"),
             pl.col("Stock Splits").cast(pl.Float64),
            pl.when(pl.col("date").is_null())
            .then(pl.lit("synthetic"))
            .otherwise(pl.lit("natural"))
            .alias("date_type"),
        ])

        # Debug transformed DataFrame
        print("Transformed DataFrame Schema:", pl_df.schema)
        print("Sample Rows After Transformation:", pl_df.head())

        # Recalculate 'ticker_date_id'
        pl_df = pl_df.with_columns([
            (pl.col("ticker") + "_" + pl.col("date").cast(pl.Utf8)).alias("ticker_date_id")
        ])
        print("After recalculating `ticker_date_id`:")
        print(pl_df.head())

        # Save DataFrame to PostgreSQL
        csv_buffer = io.StringIO()
        pl_df.to_pandas().to_csv(csv_buffer, index=False)
        csv_buffer.seek(0)

        target_schema = "cdm"
        target_table = "api_cdm_data_ingestion"
        with conn.cursor() as cursor:
            cursor.copy_expert(
                f"COPY {target_schema}.{target_table} FROM STDIN WITH (FORMAT CSV, HEADER TRUE)",
                csv_buffer
            )
        conn.commit()
        print(f"Data successfully saved to {target_schema}.{target_table}")

except Exception as e:
    print(f"Error: {e}")








# import sys
# import os
# import polars as pl
# import psycopg2
# import io

# # Add application directory to system path for custom module access
# sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')

# # Retrieve the connection string from environment variables
# connection_string = os.getenv('DB_CONNECTION_STRING')

# if connection_string is None:
#     print("DB_CONNECTION_STRING environment variable not set")
# else:
#     try:
#         # Establish connection using psycopg2
#         with psycopg2.connect(connection_string) as conn:
#             # Define schema and table details
#             schema_name = 'raw'
#             table_name = 'api_raw_data_ingestion'

#             # Create a SQL query to fetch data
#             query = f"SELECT * FROM {schema_name}.{table_name}"

#             # Fetch data as Polars DataFrame
#             with conn.cursor() as cursor:
#                 cursor.execute(query)
#                 data = cursor.fetchall()
#                 colnames = [desc[0] for desc in cursor.description]
#                 pl_df = pl.DataFrame(data, schema=colnames, orient="row")

#             # Debug: Print schema and columns
#             print("Initial DataFrame Schema:")
#             print(pl_df.schema)
#             print("Columns in DataFrame:", pl_df.columns)

#             # Process the DataFrame
#             pl_df = pl_df.with_columns([
#                 pl.col("date").cast(pl.Date),
#                 pl.col("ticker").cast(pl.Utf8),
#                 pl.col("open").cast(pl.Float64),
#                 pl.col("high").cast(pl.Float64),
#                 pl.col("low").cast(pl.Float64),
#                 pl.col("close").cast(pl.Float64),
#                 pl.col("volume").cast(pl.Int64),  # Cast volume to Int64 for BIGINT compatibility
#                 pl.col("Dividends").cast(pl.Float64),
#                 pl.col("Stock Splits").cast(pl.Float64),
#                 pl.col("processed_at").cast(pl.Datetime),
#                 pl.col("adj_close").cast(pl.Float64),
#                 pl.col("Capital Gains").cast(pl.Utf8),
#                 pl.col("ticker_date_id").cast(pl.Utf8)
#             ])

#             # Add synthetic dates and fill missing values
#             ticker_dates = pl_df.group_by("ticker").agg([
#                 pl.col("date").min().alias("min_date"),
#                 pl.col("date").max().alias("max_date")
#             ])

#             # Generate full date ranges for each ticker
#             date_ranges = []
#             for row in ticker_dates.iter_rows(named=True):
#                 date_range_df = pl.select(
#                     pl.date_range(
#                         start=row["min_date"],
#                         end=row["max_date"],
#                         interval="1d"
#                     ).alias("date")
#                 ).with_columns([
#                     pl.lit(row["ticker"]).alias("ticker")
#                 ])
#                 date_ranges.append(date_range_df)

#             all_dates = pl.concat(date_ranges)

#             # Left join the original data onto the full date ranges
#             pl_df_full = all_dates.join(pl_df, on=["ticker", "date"], how="left")

#             # Add 'date_type' column
#             pl_df_full = pl_df_full.with_columns([
#                 pl.when(pl.col("open").is_null())
#                 .then(pl.lit("synthetic"))
#                 .otherwise(pl.lit("natural"))
#                 .alias("date_type")
#             ])

#             # Forward-fill null values within each ticker group
#             columns_to_fill = [col for col in pl_df_full.columns if col not in ["ticker", "date", "date_type"]]
#             pl_df_full = pl_df_full.sort(["ticker", "date"]).with_columns([
#                 pl.col(col).fill_null(strategy="forward").over("ticker") for col in columns_to_fill
#             ])

#             # Debug: Print final schema and DataFrame
#             print("Final DataFrame Schema:")
#             print(pl_df_full.schema)
#             print("Sample rows:")
#             print(pl_df_full.head())

#             # Recalculate 'ticker_date_id' if necessary
#             pl_df_full = pl_df_full.with_columns([
#                 (pl.col("ticker") + "_" + pl.col("date").cast(pl.Utf8)).alias("ticker_date_id")
#             ])

#             # Save the DataFrame to PostgreSQL
#             try:
#                 csv_buffer = io.StringIO()
#                 pl_df_full.to_pandas().to_csv(csv_buffer, index=False)
#                 csv_buffer.seek(0)

#                 target_schema = "cdm"
#                 target_table = "api_cdm_data_ingestion"

#                 with conn.cursor() as cursor:
#                     cursor.copy_expert(
#                         f"COPY {target_schema}.{target_table} FROM STDIN WITH (FORMAT CSV, HEADER TRUE)",
#                         csv_buffer
#                     )
#                 conn.commit()
#                 print(f"Data successfully saved to {target_schema}.{target_table}")
#             except Exception as e:
#                 print(f"Error while saving data: {e}")

#     except Exception as e:
#         print(f"Unexpected error occurred: {e}")