import adbc_driver_postgresql.dbapi as pg_dbapi
import pandas as pd
import polars as pl
from sqlalchemy import create_engine
from urllib.parse import urlparse

def convert_sqlalchemy_to_libpq(connection_string):
    """Convert a SQLAlchemy-style connection string to libpq format."""
    result = urlparse(connection_string)
    libpq_string = (
        f"host={result.hostname} "
        f"port={result.port} "
        f"user={result.username} "
        f"password={result.password} "
        f"dbname={result.path.lstrip('/')}"
    )
    return libpq_string

def save_to_database(df, table_name, connection_string, schema_name, key_columns=None):
    """Saves the DataFrame to the specified table in the given schema of the database."""
    try:
        # --- Handle Polars ---
        if isinstance(df, pl.DataFrame):
            if df.height == 0:
                print(f"No new rows to insert into {schema_name}.{table_name}. (Polars DataFrame empty)")
                return
            df = df.to_pandas()

        # --- Handle pandas ---
        if isinstance(df, pd.DataFrame):
            if df.empty:
                print(f"No new rows to insert into {schema_name}.{table_name}. (pandas DataFrame empty)")
                return
        else:
            raise ValueError(f"Unsupported dataframe type: {type(df)}")

        # --- Convert SQLAlchemy string for ADBC ---
        libpq_connection_string = convert_sqlalchemy_to_libpq(connection_string)

        with pg_dbapi.connect(libpq_connection_string) as conn:
            with conn.cursor() as cur:
                cur.execute(f"SET search_path TO {schema_name};")
                
                if key_columns:
                    key_columns_str = ', '.join(key_columns)
                    existing_query = f"SELECT {key_columns_str} FROM {table_name};"
                    existing_data = pd.read_sql(existing_query, conn)

                    for col in key_columns:
                        if existing_data[col].dtype == 'datetime64[ns]':
                            existing_data[col] = pd.to_datetime(existing_data[col]).dt.date

                    df_to_insert = pd.merge(df, existing_data, on=key_columns, how='left', indicator=True)
                    df_to_insert = df_to_insert[df_to_insert['_merge'] == 'left_only'].drop(columns=['_merge'])
                else:
                    df_to_insert = df  # No key columns, just insert all rows

                if not df_to_insert.empty:
                    df_to_insert.to_sql(table_name, conn, if_exists='append', index=False)
                    print(f"{len(df_to_insert)} new rows successfully saved to {schema_name}.{table_name}")
                else:
                    print(f"No new rows to insert. All data already exists in {schema_name}.{table_name}.")

    except Exception as e:
        print("Failed to save data to database:", e)
        return None

# def save_to_database(df, table_name, connection_string, schema_name, key_columns=None):
#     """Saves the DataFrame to the specified table in the given schema of the database."""
#     try:
#         # Convert SQLAlchemy connection string to libpq format
#         libpq_connection_string = convert_sqlalchemy_to_libpq(connection_string)

#         with pg_dbapi.connect(libpq_connection_string) as conn:
#             with conn.cursor() as cur:
#                 cur.execute(f"SET search_path TO {schema_name};")
                
#                 if key_columns:
#                     key_columns_str = ', '.join(key_columns)
#                     existing_query = f"SELECT {key_columns_str} FROM {table_name};"
#                     existing_data = pd.read_sql(existing_query, conn)

#                     for col in key_columns:
#                         if df[col].dtype == 'datetime64[ns]':
#                             existing_data[col] = pd.to_datetime(existing_data[col]).dt.date

#                     df_to_insert = pd.merge(df, existing_data, on=key_columns, how='left', indicator=True)
#                     df_to_insert = df_to_insert[df_to_insert['_merge'] == 'left_only'].drop(columns=['_merge'])
#                 else:
#                     df_to_insert = df  # No key columns, just insert all rows
                
#                 if not df_to_insert.empty:
#                     df_to_insert.to_sql(table_name, conn, if_exists='append', index=False)
#                     print(f"{len(df_to_insert)} new rows successfully saved to {table_name} in schema '{schema_name}'")
#                 else:
#                     print("No new rows to insert. All data already exists in the database.")
    
#     except Exception as e:
#         print("Failed to save data to database:", e)
#         return None

# Airflow-specific imports
from airflow.models import Variable

def get_db_connection_string(env: str) -> str:
    """
    Retrieve the database connection string based on the environment.

    Args:
        env (str): The environment name ("dev", "staging", "heroku_postgres").

    Returns:
        str: The database connection string for the specified environment.

    Raises:
        ValueError: If the environment is invalid or the corresponding Variable is not set.
    """
    # Mapping of environments to their respective Airflow Variable names
    env_to_var_map = {
        "dev": "DEV_DB_CONNECTION_STRING",
        "staging": "STAGING_DB_CONNECTION_STRING",
        "heroku_postgres": "DATABASE_URL",
    }

    # Validate the environment and retrieve the corresponding variable
    if env not in env_to_var_map:
        raise ValueError(f"Invalid environment specified: {env}. Please set a valid ENV variable.")
    
    # Retrieve the connection string from Airflow Variables
    connection_string = Variable.get(env_to_var_map[env], default_var=None)
    if not connection_string:
        raise ValueError(f"Environment variable {env_to_var_map[env]} is not set. Ensure it is defined in Airflow Variables.")
    
    return connection_string


def fetch_data_from_database(schema_name, table_name, connection_string):
    """Fetches the stock data from the specified schema and table in the database."""
    try:
        # Convert SQLAlchemy connection string to libpq format
        libpq_connection_string = convert_sqlalchemy_to_libpq(connection_string)

        with pg_dbapi.connect(libpq_connection_string) as conn:
            query = f"SELECT * FROM {schema_name}.{table_name};"
            df = pd.read_sql(query, conn)
        return df
    except Exception as e:
        print("Error fetching data from the database:", e)
        return None