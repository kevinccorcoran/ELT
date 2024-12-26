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
        super().__init__(base_log_folder)
        self.dropbox_folder = dropbox_folder
        self.dbx = dropbox.Dropbox(access_token)
        self.log = logging.getLogger(self.__class__.__name__)

    def upload_to_dropbox(self, local_log_path):
        if not os.path.isfile(local_log_path):
            self.log.debug(f"Log file not found: {local_log_path}")
            return

        try:
            relative_path = os.path.relpath(local_log_path, self.base_log_folder)
            dropbox_path = os.path.join(self.dropbox_folder, relative_path)
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
        super().close()
        for handler in self.handler.handlers:
            if hasattr(handler, "baseFilename"):
                self.upload_to_dropbox(handler.baseFilename)
