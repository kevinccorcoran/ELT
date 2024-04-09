import importlib.util
import logging
from pytest_tests.utilities.database_utils import Database
#from pytest_tests 
#import send_telegram_message
from pytest_tests.send_telegram_message import send_telegram_message


# Initialize logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Function to load environment variables from a specific Python file
def load_env_variables(path):
    spec = importlib.util.spec_from_file_location("env", path)
    env = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(env)
    return env

# Load the .env.py variables
env_path = '/Users/kevin/Dropbox/applications/ELT/.env.py'
env = load_env_variables(env_path)

def get_ticker_count():
    # Ensure the connection pool is initialized
    Database.initialize()
    
    # Get a connection from the pool
    connection = Database.get_connection()
    cursor = connection.cursor()
    
    # Execute the query
    cursor.execute(""" 
    SELECT COUNT(*)
    FROM CDM.CRYPTO_MAIN_CLEAN
    WHERE (OPEN <= 0 OR OPEN IS NULL)
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
    # Use variables loaded from .env.py
    chat_id = getattr(env, 'TELEGRAM_CHAT_ID', None)
    bot_token = getattr(env, 'TELEGRAM_BOT_TOKEN', None)

    logging.info(f"Loaded chat ID: {chat_id}, and bot token: {bot_token[:10]}...")

    
    try:
        count = get_ticker_count()
        assert count == 0, "Expected count to be 0."
    except Exception as e:  # Catching a broader range of exceptions
        test_name = "test_ticker_count"
        error_message = str(e)
        custom_message = f"Test failed - {test_name}: {error_message}"
        
        # Send notification to Telegram
        send_telegram_message(chat_id, custom_message, bot_token)
        
        # Log the error message
        logging.error(custom_message)
        
        # Reraise the exception to ensure Pytest marks this as a failed test
        raise