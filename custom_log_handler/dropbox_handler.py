import os
import logging
import dropbox
import posixpath  # Ensure cross-platform compatibility for Dropbox paths
from airflow.utils.log.file_task_handler import FileTaskHandler
from airflow.configuration import conf
from airflow.utils.log.logging_mixin import LoggingMixin


class DropboxTaskHandler(FileTaskHandler, LoggingMixin):
    """
    A custom log handler that writes logs to a local file (via FileTaskHandler),
    then uploads them to Dropbox for persistence.
    """
    def __init__(self, base_log_folder=None, dropbox_folder=None, access_token=None):
        # Set base log folder and fallback to Airflow's default if not provided
        default_base_log_folder = conf.get("logging", "BASE_LOG_FOLDER", fallback="/tmp/airflow_logs")
        self.base_log_folder = base_log_folder or default_base_log_folder

        # Dropbox folder where logs will be uploaded
        self.dropbox_folder = dropbox_folder or "/airflow_logs"

        # Dropbox API access token (required)
        self.dbx = dropbox.Dropbox(access_token or os.getenv("DROPBOX_ACCESS_TOKEN"))

        # Logger setup
        self.log = logging.getLogger(self.__class__.__name__)

        # Initialize parent FileTaskHandler
        super().__init__(self.base_log_folder)

    def upload_to_dropbox(self, local_log_path):
        """
        Upload a local log file to Dropbox.
        """
        if not os.path.isfile(local_log_path):
            self.log.debug(f"Log file not found: {local_log_path}")
            return

        try:
            # Get relative path to maintain directory structure
            relative_path = os.path.relpath(local_log_path, self.base_log_folder)
            if ".." in relative_path or relative_path.startswith("../"):
                self.log.error(f"Invalid relative path for log: {local_log_path}")
                return

            # Build the Dropbox file path
            dropbox_path = posixpath.join(self.dropbox_folder, relative_path)

            # Upload the file to Dropbox
            with open(local_log_path, "rb") as f:
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
        Close the log handler and upload the log to Dropbox.
        """
        super().close()
        if hasattr(self.handler, "baseFilename"):
            self.upload_to_dropbox(self.handler.baseFilename)
