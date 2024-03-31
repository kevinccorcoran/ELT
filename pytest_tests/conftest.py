# conftest.py
import pytest
from .send_telegram_message import send_telegram_message
  # Adjust the import path as necessary

@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    report = outcome.get_result()
    if report.when == 'call' and report.failed:
        chat_id = '6473008661'  # Replace with your actual chat ID
        bot_token = '6652019781:AAGbMJQy9qOKPJQPkVKipCk1acZ89BxeOeo'  # Replace with your actual bot token
        message = f"Test failed: {item.nodeid}"
        send_telegram_message(chat_id, message, bot_token)

# Standard library imports
# import os

# # Related third-party imports
# import pytest
# import requests
# import toml

# def load_config():
#     # Get the directory of the current file (conftest.py)
#     dir_path = os.path.dirname(os.path.abspath(__file__))
#     # Construct the absolute path to config.toml
#     config_path = os.path.join(dir_path, 'config.toml')
#     with open(config_path, 'r') as config_file:
#         config = toml.load(config_file)
#     return config

# matrix_config = load_config().get('matrix', {})

# def send_notification(message):
#     url = matrix_config['url']
#     data = {"msgtype": "m.text", "body": message}
#     response = requests.post(url, json=data)
#     if response.status_code != 200:
#         print(f"Failed to send notification: {response.text}")

# # Send notification to Element
# @pytest.hookimpl(tryfirst=True, hookwrapper=True)
# def pytest_runtest_makereport(item, call):
#     outcome = yield
#     report = outcome.get_result()
#     if report.when == 'call' and report.failed:
#         test_name = item.name
#         test_file_path = item.location[0]
#         line_number = item.location[1]
#         error_msg = report.longreprtext
#         message = f"Test Failed: {test_name} in {test_file_path}:{line_number}\nError: {error_msg}"
#         send_notification(message)