from dropbox_log_handler import DropboxTaskHandler
import os

LOGGING_CONFIG = {
    'handlers': {
        'task': {
            'class': 'dropbox_log_handler.DropboxTaskHandler',
            'base_log_folder': '/tmp/airflow_logs',  # Temporary local folder
            'remote_base_log_folder': 'airflow_logs_dev',  # Dropbox folder
            'dropbox_token': os.getenv('DROPBOX_ACCESS_TOKEN'),  # Use environment variable
        }
    },
    'root': {
        'handlers': ['task'],
        'level': 'INFO',
    },
}
