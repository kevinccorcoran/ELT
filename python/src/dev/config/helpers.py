import adbc_driver_postgresql.dbapi as pg_dbapi
import pandas as pd

def save_to_database(df, table_name, connection_string, schema_name):
    """Saves the DataFrame to the specified table in the given schema of the database."""
    try:
        with pg_dbapi.connect(connection_string) as conn:
            with conn.cursor() as cur:  # Use a cursor object
                cur.execute(f"SET search_path TO {schema_name};")  # Dynamically set the schema
                
                # Fetch existing ticker and date combinations
                existing_query = f"SELECT ticker, date FROM {table_name};"
                existing_data = pd.read_sql(existing_query, conn)
                
                # Ensure date column is in the correct format for comparison
                existing_data['date'] = pd.to_datetime(existing_data['date']).dt.date
                
                # Merge to find rows that are not already in the database
                df_to_insert = pd.merge(df, existing_data, on=['ticker', 'date'], how='left', indicator=True)
                df_to_insert = df_to_insert[df_to_insert['_merge'] == 'left_only'].drop(columns=['_merge'])
                
                if not df_to_insert.empty:
                    # Insert the new rows into the database
                    df_to_insert.to_sql(table_name, conn, if_exists='append', index=False)
                    print(f"{len(df_to_insert)} new rows successfully saved to {table_name} in schema '{schema_name}'")
                else:
                    print("No new rows to insert. All data already exists in the database.")
                
    except Exception as e:
        print("Failed to save data to database:", e)
        return None

def fetch_data_from_database(table_name, connection_string):
    """Fetches the stock data from the specified table in the database."""
    try:
        with pg_dbapi.connect(connection_string) as conn:
            query = f"SELECT * FROM raw.{table_name};"
            df = pd.read_sql(query, conn)
        return df
    except Exception as e:
        print("Error fetching data from the database:", e)
        return None




