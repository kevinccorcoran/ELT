import logging
import dropbox
from airflow.utils.log.file_task_handler import FileTaskHandler
import os

class DropboxTaskHandler(FileTaskHandler):
    def __init__(self, base_log_folder, remote_base_log_folder, dropbox_access_token):
        super().__init__(base_log_folder)
        self.remote_base_log_folder = remote_base_log_folder
        self.dbx = dropbox.Dropbox(dropbox_access_token)

    def upload_to_dropbox(self, local_file_path, remote_file_path):
        """Uploads a log file from local storage to Dropbox."""
        logging.info(f"Attempting to upload {local_file_path} to Dropbox at {remote_file_path}")
        if os.path.exists(local_file_path):
            with open(local_file_path, "rb") as f:
                try:
                    self.dbx.files_upload(f.read(), remote_file_path, mode=dropbox.files.WriteMode.overwrite)
                    logging.info(f"Successfully uploaded {local_file_path} to {remote_file_path}")
                except Exception as e:
                    logging.error(f"Failed to upload {local_file_path} to Dropbox: {e}")
        else:
            logging.warning(f"Log file does not exist: {local_file_path}")

    def set_context(self, ti):
        """Sets the logging context and triggers the upload to Dropbox."""
        super().set_context(ti)
        local_file_path = self.handler.baseFilename
        remote_file_path = f"{self.remote_base_log_folder}/{ti.dag_id}/{ti.task_id}/{ti.execution_date}.log"
        logging.info(f"Setting context for task: {ti.task_id} | Local log path: {local_file_path} | Remote path: {remote_file_path}")
        self.upload_to_dropbox(local_file_path, remote_file_path)
