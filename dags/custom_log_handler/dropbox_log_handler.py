import os
import dropbox
from airflow.utils.log.file_task_handler import FileTaskHandler

class DropboxTaskHandler(FileTaskHandler):
    def __init__(self, base_log_folder, remote_base_log_folder, dropbox_access_token):
        super().__init__(base_log_folder)
        self.remote_base_log_folder = remote_base_log_folder
        self.dbx = dropbox.Dropbox(dropbox_access_token)

    def upload_to_dropbox(self, local_file_path, remote_file_path):
        """Uploads a log file from local storage to Dropbox."""
        if os.path.exists(local_file_path):
            with open(local_file_path, "rb") as f:
                self.dbx.files_upload(f.read(), remote_file_path, mode=dropbox.files.WriteMode.overwrite)

    def set_context(self, ti):
        """Sets the logging context and triggers the upload to Dropbox."""
        super().set_context(ti)
        local_file_path = self.handler.baseFilename
        remote_file_path = f"{self.remote_base_log_folder}/{ti.dag_id}/{ti.task_id}/{ti.execution_date}.log"
        self.upload_to_dropbox(local_file_path, remote_file_path)

    def read(self, task_instance, try_number):
        """
        Reads the log file from Dropbox for display in the Airflow UI.
        """
        remote_file_path = f"{self.remote_base_log_folder}/{task_instance.dag_id}/{task_instance.task_id}/{task_instance.execution_date}.log"
        try:
            _, res = self.dbx.files_download(remote_file_path)
            log_content = res.content.decode("utf-8")
            return log_content, {"end_of_log": True}
        except dropbox.exceptions.ApiError as e:
            return f"Log not found in Dropbox: {remote_file_path}\nError: {str(e)}", {"end_of_log": True}
