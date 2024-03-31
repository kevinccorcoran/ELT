import requests
import logging



# Setup basic configuration for logging
# This line can be adjusted or moved to the main script/module initialization section
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def send_telegram_message(chat_id, message, bot_token):
    """
    Send a message to a Telegram chat using a bot.

    Parameters:
    chat_id (str): The chat ID of the Telegram chat to send the message to.
    message (str): The message to send.
    bot_token (str): The token of the Telegram bot used to send the message.

    Returns:
    response (dict): The response from the Telegram API.
    """
    # URL for the Telegram API
    url = f"https://api.telegram.org/bot{bot_token}/sendMessage"
    
    # Data to be sent to the API
    data = {
        "chat_id": chat_id,
        "text": message,
        "parse_mode": "Markdown",  # Optional: Allows for markdown formatting in the message
    }
    
    try:
        # Sending the request to the Telegram API
        response = requests.post(url, data=data)
        response.raise_for_status()  # Raises an exception for HTTP errors
        
        # If the request is successful
        if response.status_code == 200:
            logging.info("Message sent successfully")
            return response.json()  # Return the JSON response from the API
        else:
            logging.error("Failed to send message, status code: %s", response.status_code)
    except Exception as e:
        logging.error("An error occurred while sending the message: %s", e)
        return None





# import requests
# # Example usage
# bot_token = '6652019781:AAGbMJQy9qOKPJQPkVKipCk1acZ89BxeOeo'
# chat_id = '6473008661'
# message = 'This is a test message from my bot.'

# def send_telegram_message(chat_id, text, bot_token):
#     url = f"https://api.telegram.org/bot{bot_token}/sendMessage"
#     payload = {
#         "chat_id": chat_id,
#         "text": text,
#     }
#     response = requests.post(url, data=payload)
#     return response.json()



# send_telegram_message(chat_id, message, bot_token)
