# import pytest
# from send_notification import send_notification

# @pytest.hookimpl(tryfirst=True, hookwrapper=True)
# def pytest_runtest_makereport(item, call):
#     outcome = yield
#     report = outcome.get_result()
#     if report.when == 'call' and report.failed:
#         send_notification(f"Test Failed: {item.name}")

import os
import requests
from dotenv import load_dotenv
import pytest


# Load environment variables from .env file
# Adjust the path to where your .env file is located
load_dotenv('/Users/kevin/Dropbox/applications/ELT/.env.py')

def send_notification(message):
    # Get the environment variables
    room_id = os.getenv('ROOM_ID')  # Access the ROOM_ID environment variable
    access_token = os.getenv('ACCESS_TOKEN')  # Access the ACCESS_TOKEN environment variable

    # Check if environment variables are set
    if room_id is None or access_token is None:
        print("ROOM_ID or ACCESS_TOKEN is not set. Please check your .env file.")
        return
    
    # Construct the request URL
    url = f"https://matrix.org/_matrix/client/r0/rooms/{room_id}/send/m.room.message?access_token={access_token}"
    data = {
        "msgtype": "m.text",
        "body": message,
    }
    # Send the POST request
    response = requests.post(url, json=data)
    if response.status_code != 200:
        print("Failed to send notification")

# Send notification to Element
@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    report = outcome.get_result()
    if report.when == 'call' and report.failed:
        test_name = item.name
        test_file_path = item.location[0]
        line_number = item.location[1]
        error_msg = report.longreprtext
        message = f"Test Failed: {test_name} in {test_file_path}:{line_number}\nError: {error_msg}"
        send_notification(message)
