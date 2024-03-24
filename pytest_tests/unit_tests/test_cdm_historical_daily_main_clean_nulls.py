#Standard Library Imports
import os
import pytest
#Third-Party Imports
import psycopg2
from psycopg2 import pool
#Local Application/Library Specific Imports
from dotenv import load_dotenv
import requests
from pytest_tests.matrix_notify.send_notification import send_notification

import pytest
from pytest_tests.utilities.database_utils import Database  # Import the Database class from your utility module

def get_ticker_count():
    # Ensure the connection pool is initialized
    Database.initialize()
    
    # Get a connection from the pool
    connection = Database.get_connection()
    cursor = connection.cursor()
    
    # Execute the query
    cursor.execute(""" 
    SELECT
        VOLUME,
        PROCESSED_AT,
        DATE,
        TICKER,
        OPEN,
        HIGH,
        LOW,
        CLOSE,
        ADJ_CLOSE
    FROM
        CDM.HISTORICAL_DAILY_MAIN_CLEAN
    WHERE
        (OPEN <= 0 OR OPEN IS NULL)
        AND (HIGH <= 0 OR HIGH IS NULL)
        AND (LOW <= 0 OR LOW IS NULL)
    """)
    
    # Fetch the result
    result = cursor.fetchone()
    count = result[0] if result else 0  # Set count to 0 if result is None
    
    # Close the cursor and return the connection to the pool
    cursor.close()
    Database.return_connection(connection)
    
    return count

def test_ticker_count():
    count = get_ticker_count()
    assert count == 1, f"Count is greater than 0: {count}"

# Here you can add more tests or business logic functions


# # Load environment variables from .env file
# # load_dotenv()
# load_dotenv('/Users/kevin/Dropbox/applications/ELT/.env.py') # Adjust the path as necessary

# class Database:
#     __connection_pool = None

#     @staticmethod
#     def initialize():
#         if Database.__connection_pool is None:
#             Database.__connection_pool = pool.SimpleConnectionPool(
#                 1,
#                 10,
#                 dbname=os.getenv('DB_NAME'),
#                 user=os.getenv('DB_USER'),
#                 password=os.getenv('DB_PASSWORD'),
#                 host=os.getenv('DB_HOST'),
#                 port=os.getenv('DB_PORT')
#             )

#     @staticmethod
#     def get_connection():
#         Database.initialize() # Ensure the connection pool is initialized
#         return Database.__connection_pool.getconn()

#     @staticmethod
#     def return_connection(connection):
#         Database.__connection_pool.putconn(connection)

#     @staticmethod
#     def close_all_connections():
#         Database.__connection_pool.closeall()

# def get_ticker_count():
#     # Ensure the connection pool is initialized
#     Database.initialize()
    
#     # Get a connection from the pool
#     connection = Database.get_connection()
#     cursor = connection.cursor()
    
#     # Execute the query
#     cursor.execute(""" 
#     SELECT
#         VOLUME,
#         PROCESSED_AT,
#         DATE,
#         TICKER,
#         OPEN,
#         HIGH,
#         LOW,
#         CLOSE,
#         ADJ_CLOSE
#     FROM
#         CDM.HISTORICAL_DAILY_MAIN_CLEAN
#     WHERE
#         (OPEN <= 0 OR OPEN IS NULL)
#         AND (HIGH <= 0 OR HIGH IS NULL)
#         AND (LOW <= 0 OR LOW IS NULL)
#         --Exceptions 
#         AND (TICKER != 'WMT' OR (DATE NOT IN ('1974-12-11', '1974-12-12')))
#     """)
    
#     # Fetch the result
#     # Fetch the result
#     result = cursor.fetchone()
#     count = result[0] if result else 0  # Set count to 0 if result is None
    
#     # Close the cursor and return the connection to the pool
#     cursor.close()
#     Database.return_connection(connection)
    
#     return count


# def test_ticker_count():
#     count = get_ticker_count()
#     # Assert that count is not greater than 1
#     assert count == 0, f"Count is greater than 0: {count}"

# File: test_ticker_data.py


