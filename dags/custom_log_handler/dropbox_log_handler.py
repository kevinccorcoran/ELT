import os
import dropbox
from airflow.utils.log.file_task_handler import FileTaskHandler

class DropboxTaskHandler(FileTaskHandler):
    def __init__(self, base_log_folder, remote_base_log_folder, dropbox_access_token):
        super().__init__(base_log_folder)
        self.remote_base_log_folder = remote_base_log_folder
        self.dbx = dropbox.Dropbox(dropbox_access_token)

    def upload_to_dropbox(self, local_file_path, remote_file_path):
        with open(local_file_path, "rb") as f:
            self.dbx.files_upload(f.read(), remote_file_path, mode=dropbox.files.WriteMode.overwrite)

    def set_context(self, ti):
        super().set_context(ti)
        # Upload the log file to Dropbox after it's written locally
        local_file_path = self.handler.baseFilename
        remote_file_path = f"{self.remote_base_log_folder}/{ti.dag_id}/{ti.task_id}/{ti.execution_date}.log"
        self.upload_to_dropbox(local_file_path, remote_file_path)
