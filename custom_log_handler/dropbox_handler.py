import os
import logging
import dropbox

from airflow.utils.log.file_task_handler import FileTaskHandler
from airflow.configuration import conf
from airflow.utils.log.logging_mixin import LoggingMixin

class DropboxTaskHandler(FileTaskHandler, LoggingMixin):
    """
    A custom log handler that writes logs to a local file (FileTaskHandler),
    then uploads them to Dropbox.
    """
    def __init__(self, base_log_folder, dropbox_folder, access_token):
        """
        :param base_log_folder: Local Airflow log folder (e.g. /tmp/airflow_logs)
        :param dropbox_folder: Dropbox folder path (e.g. /airflow_logs_dev)
        :param access_token: Dropbox API access token
        """
        super().__init__(base_log_folder)
        self.dropbox_folder = dropbox_folder
        self.dbx = dropbox.Dropbox(access_token)

        # Optional: create a dedicated logger for debugging
        self.log = logging.getLogger(self.__class__.__name__)

    def upload_to_dropbox(self, local_log_path):
        """
        Uploads the local log file (local_log_path) to Dropbox.
        """
        if not os.path.isfile(local_log_path):
            self.log.debug(f"Log file not found: {local_log_path}")
            return

        try:
            # Construct a Dropbox path. We use `os.path.relpath` so each log file
            # ends up in a subpath that mirrors local structure. If you prefer a
            # simpler approach, you can just use `os.path.basename(local_log_path)`.
            relative_path = os.path.relpath(local_log_path, self.base_log_folder)
            dropbox_path = os.path.join(self.dropbox_folder, relative_path)

            with open(local_log_path, "rb") as f:
                # Overwrite the file if it already exists in Dropbox
                self.dbx.files_upload(
                    f.read(),
                    dropbox_path,
                    mode=dropbox.files.WriteMode.overwrite
                )
            self.log.debug(f"Uploaded log to Dropbox: {dropbox_path}")

        except Exception as e:
            self.log.error(f"Failed to upload log file to Dropbox: {e}", exc_info=True)

    def close(self):
        """
        Called when the handler is closed (typically after each task run).
        We override this to upload the logs to Dropbox.
        """
        super().close()

        # Our underlying 'handler' is a Python 'logging' Logger which may contain
        # multiple child handlers. We check each for baseFilename to upload it.
        for handler in self.handler.handlers:
            if hasattr(handler, "baseFilename"):
                self.upload_to_dropbox(handler.baseFilename)


def get_dropbox_task_handler():
    """
    Helper function (optional) that reads the config and returns a DropboxTaskHandler.
    This can be used in an `airflow_local_settings.py` or in your own code
    if you want to programmatically construct the handler.
    """
    base_log_folder = conf.get("logging", "base_log_folder")
    dropbox_folder = conf.get("dropbox", "dropbox_folder")  # e.g. "/airflow_logs_dev"
    access_token = conf.get("dropbox", "access_token")
    return DropboxTaskHandler(base_log_folder, dropbox_folder, access_token)
