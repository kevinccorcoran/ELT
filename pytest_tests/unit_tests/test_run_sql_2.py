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


# Load environment variables from .env file
# load_dotenv()
load_dotenv('/Users/kevin/Dropbox/applications/ELT/.env.py') # Adjust the path as necessary

class Database:
    __connection_pool = None

    @staticmethod
    def initialize():
        if Database.__connection_pool is None:
            Database.__connection_pool = pool.SimpleConnectionPool(
                1,
                10,
                dbname=os.getenv('DB_NAME'),
                user=os.getenv('DB_USER'),
                password=os.getenv('DB_PASSWORD'),
                host=os.getenv('DB_HOST'),
                port=os.getenv('DB_PORT')
            )

    @staticmethod
    def get_connection():
        Database.initialize() # Ensure the connection pool is initialized
        return Database.__connection_pool.getconn()

    @staticmethod
    def return_connection(connection):
        Database.__connection_pool.putconn(connection)

    @staticmethod
    def close_all_connections():
        Database.__connection_pool.closeall()

def get_ticker_count():
    # Ensure the connection pool is initialized
    Database.initialize()
    
    # Get a connection from the pool
    connection = Database.get_connection()
    cursor = connection.cursor()
    
    # Execute the query
    cursor.execute("SELECT count(ticker) FROM cdm.pure_growth")
    
    # Fetch the result
    count = cursor.fetchone()[0]
    
    # Close the cursor and return the connection to the pool
    cursor.close()
    Database.return_connection(connection)
    
    return count


def test_ticker_count():
    count = get_ticker_count()
    # Assert that count is not greater than 1
    assert count == 1, f"Count is greater than 1: {count}"