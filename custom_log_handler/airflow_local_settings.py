from custom_log_handler.dropbox_log_handler import DropboxTaskHandler

LOGGING_CONFIG = {
    'handlers': {
        'task': {
            'class': 'dropbox_log_handler.DropboxTaskHandler',
            'base_log_folder': '/tmp/airflow_logs',
            'dropbox_base_folder': '/airflow_logs_dev',
            'access_token': 'DROPBOX_ACCESS_TOKEN',
        }
    },
    'root': {
        'handlers': ['task'],
        'level': 'INFO',
    },
}
