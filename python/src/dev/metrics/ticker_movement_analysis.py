import sys
import os
import pandas as pd
import adbc_driver_postgresql.dbapi as pg_dbapi

# Add application directory to system path for custom module access
sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src/')

# Import custom helper functions
from dev.config.helpers import fetch_data_from_database, save_to_database

# Retrieve the connection string from environment variables
connection_string = os.getenv('DB_CONNECTION_STRING')

if connection_string is None:
    print("DB_CONNECTION_STRING environment variable not set")
else:
    try:
        # Define schema and table details
        schema_name = 'cdm'  # Set the appropriate schema name
        table_name = 'company_cagr'

        # Fetch data from the database
        df = fetch_data_from_database(schema_name, table_name, connection_string)

        if df is not None:
            # Sort and prepare the DataFrame
            df = df.sort_values(by=['ticker', 'n', 'type'])
            df['next_cagr_group'] = df.groupby(['ticker', 'type'])['cagr_group'].shift(-1)
            df['next_n'] = df.groupby(['ticker', 'type'])['n'].shift(-1)
            df = df.dropna(subset=['next_cagr_group', 'next_n'])
            df['next_cagr_group'] = df['next_cagr_group'].astype(int)
            df['next_n'] = df['next_n'].astype(int)

            # Calculate transitions and probabilities
            transitions = df.groupby(['n', 'next_n', 'cagr_group', 'next_cagr_group', 'type']).size().reset_index(name='count')
            transitions['total'] = transitions.groupby(['n', 'cagr_group', 'type'])['count'].transform('sum')
            transitions['probability'] = transitions['count'] / transitions['total']

            # Display calculated transitions
            print(transitions)

            # Save transitions DataFrame to the database
            save_to_database(transitions, 'ticker_movement_analysis', connection_string, 'metrics')

        else:
            print("No data fetched from the database.")

    except Exception as e:
        print(f"Unexpected error occurred: {e}")