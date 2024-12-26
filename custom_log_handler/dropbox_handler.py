import logging
import dropbox
from airflow.utils.log.file_task_handler import FileTaskHandler

class DropboxTaskHandler(FileTaskHandler):
    def __init__(self, base_log_folder, dropbox_folder, access_token):
        super().__init__(base_log_folder)
        self.dropbox_folder = dropbox_folder
        self.dbx = dropbox.Dropbox(access_token)

    def upload_to_dropbox(self, log_file):
        try:
            with open(log_file, "rb") as f:
                self.dbx.files_upload(f.read(), f"{self.dropbox_folder}/{log_file}")
        except Exception as e:
            logging.error(f"Failed to upload log file to Dropbox: {e}")

    def close(self):
        super().close()
        # Upload logs to Dropbox
        for handler in self.handler.handlers:
            if hasattr(handler, "baseFilename"):
                self.upload_to_dropbox(handler.baseFilename)
