# import os
# import requests
# import toml

# def send_notification(message):
#     url = "https://matrix.org/_matrix/client/r0/rooms/syt_a2V2aW4uY29yY29yYW4_TvHFcMAQAgpqQPVWrcRU_0n2sgP/send/m.room.message?access_token=syt_a2V2aW4uY29yY29yYW4_TvHFcMAQAgpqQPVWrcRU_0n2sgP"
#     #url = matrix_config['url'] 
#     data = {
#         "msgtype": "m.text",
#         "body": message,
#     }
#     try:
#         response = requests.post(url, json=data)
#         response.raise_for_status()  # This will raise an exception for HTTP error codes
#         print("Notification sent successfully")
#     except requests.RequestException as e:
#         print(f"Failed to send notification: {e}")

# send_notification("Hello, world!")  # Test the function  