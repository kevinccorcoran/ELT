import sys
import os
import logging
import pandas as pd
import adbc_driver_postgresql.dbapi as pg_dbapi
import psycopg2
import polars as pl
from decimal import Decimal
from datetime import datetime, timedelta
import io

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Retrieve the database connection string from environment variables
connection_string = os.getenv('DATABASE_URL')
if not connection_string:
    logging.error("DATABASE_URL environment variable not set.")
    sys.exit(1)

# Adjust the connection string for psycopg2 compatibility
if connection_string.startswith("postgresql+psycopg2://"):
    connection_string = connection_string.replace("postgresql+psycopg2://", "postgresql://", 1)

# Import custom helper functions
sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')
from dev.config.helpers import fetch_data_from_database, save_to_database

try:
    # Connect to the database
    conn = pg_dbapi.connect(connection_string)
    cur = conn.cursor()

    # Truncate the table before running the main process
    truncate_statement = "TRUNCATE TABLE metrics.ticker_movement_analysis;"
    cur.execute(truncate_statement)
    conn.commit()
    cur.close()
    conn.close()

    # Define schema and table details
    schema_name = 'cdm'
    table_name = 'company_cagr'

    # Fetch data from the database
    df = fetch_data_from_database(schema_name, table_name, connection_string)

    if df is not None:
        df = df.sort_values(by=['ticker', 'n', 'type'])
        df['next_cagr_group'] = df.groupby(['ticker', 'type'])['cagr_group'].shift(-1)
        df['next_n'] = df.groupby(['ticker', 'type'])['n'].shift(-1)
        df = df.dropna(subset=['next_cagr_group', 'next_n'])
        df['next_cagr_group'] = df['next_cagr_group'].astype(int)
        df['next_n'] = df['next_n'].astype(int)

        transitions = df.groupby(['n', 'next_n', 'cagr_group', 'next_cagr_group', 'type']).size().reset_index(name='count')
        transitions['total'] = transitions.groupby(['n', 'cagr_group', 'type'])['count'].transform('sum')
        transitions['probability'] = transitions['count'] / transitions['total']

        logging.info("Transition data calculated successfully.")
        save_to_database(transitions, 'ticker_movement_analysis', connection_string, 'metrics')
    else:
        logging.info("No data fetched from the database.")

except Exception as e:
    logging.error(f"Unexpected error occurred: {e}")


# import sys
# import os
# import pandas as pd
# import adbc_driver_postgresql.dbapi as pg_dbapi

# # Add application directory to system path for custom module access
# sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')

# # Import custom helper functions
# from dev.config.helpers import fetch_data_from_database, save_to_database

# # Retrieve the connection string from environment variables
# connection_string = os.getenv('DB_CONNECTION_STRING')

# if connection_string is None:
#     print("DB_CONNECTION_STRING environment variable not set")
# else:
#     try:
#         # Connect to the database
#         conn = pg_dbapi.connect(connection_string)
#         cur = conn.cursor()

#         # Truncate the table before running the main process
#         # Adjust schema and table names if needed
#         truncate_statement = "TRUNCATE TABLE metrics.ticker_movement_analysis;"
#         cur.execute(truncate_statement)
#         conn.commit()

#         # Close cursor and connection before running the main logic (optional but recommended)
#         cur.close()
#         conn.close()

#         # Define schema and table details
#         schema_name = 'cdm'  # Set the appropriate schema name
#         table_name = 'company_cagr'

#         # Fetch data from the database
#         df = fetch_data_from_database(schema_name, table_name, connection_string)

#         if df is not None:
#             # Sort and prepare the DataFrame
#             df = df.sort_values(by=['ticker', 'n', 'type'])
#             df['next_cagr_group'] = df.groupby(['ticker', 'type'])['cagr_group'].shift(-1)
#             df['next_n'] = df.groupby(['ticker', 'type'])['n'].shift(-1)
#             df = df.dropna(subset=['next_cagr_group', 'next_n'])
#             df['next_cagr_group'] = df['next_cagr_group'].astype(int)
#             df['next_n'] = df['next_n'].astype(int)

#             # Calculate transitions and probabilities
#             transitions = df.groupby(['n', 'next_n', 'cagr_group', 'next_cagr_group', 'type']).size().reset_index(name='count')
#             transitions['total'] = transitions.groupby(['n', 'cagr_group', 'type'])['count'].transform('sum')
#             transitions['probability'] = transitions['count'] / transitions['total']

#             # Display calculated transitions
#             print(transitions)

#             # Save transitions DataFrame back to the database
#             save_to_database(transitions, 'ticker_movement_analysis', connection_string, 'metrics')

#         else:
#             print("No data fetched from the database.")

#     except Exception as e:
#         print(f"Unexpected error occurred: {e}")
