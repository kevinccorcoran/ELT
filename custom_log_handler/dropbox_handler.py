import logging
import dropbox
from airflow.utils.log.file_task_handler import FileTaskHandler

class DropboxTaskHandler(FileTaskHandler):
    def __init__(self, base_log_folder, remote_base_log_folder, dropbox_token):
        super().__init__(base_log_folder)
        self.remote_base_log_folder = remote_base_log_folder.strip("/")
        self.client = dropbox.Dropbox(dropbox_token)
        logging.info("Initialized DropboxTaskHandler with remote base log folder: %s", self.remote_base_log_folder)

    def set_context(self, ti):
        super().set_context(ti)
        self.log_relative_path = f"/{self.remote_base_log_folder}/{ti.dag_id}/{ti.task_id}/{ti.execution_date}/{ti.try_number}.log"
        logging.info("Log relative path set to: %s", self.log_relative_path)

    def close(self):
        if self.handler:
            self.handler.close()
            local_log = self.handler.stream.name
            try:
                with open(local_log, "rb") as f:
                    self.client.files_upload(f.read(), self.log_relative_path, mode=dropbox.files.WriteMode("overwrite"))
                logging.info("Successfully uploaded log to Dropbox: %s", self.log_relative_path)
            except Exception as e:
                logging.error("Failed to upload log to Dropbox: %s", str(e))
        else:
            logging.warning("No handler found to close or upload logs.")

    def read(self, task_instance):
        try:
            log_path = f"/{self.remote_base_log_folder}/{task_instance.dag_id}/{task_instance.task_id}/{task_instance.execution_date}/{task_instance.try_number}.log"
            metadata, res = self.client.files_download(log_path)
            return res.content.decode("utf-8")
        except dropbox.exceptions.ApiError as e:
            logging.error("Failed to retrieve log from Dropbox: %s", str(e))
            return f"Failed to retrieve log: {str(e)}"
