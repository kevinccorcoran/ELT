import os
import logging
import dropbox
from dropbox.oauth import DropboxOAuth2FlowNoRedirect

class DropboxLogHandler(logging.Handler):
    def __init__(self, access_token, refresh_token, app_key, app_secret, dropbox_folder):
        super().__init__()
        if not access_token or not refresh_token or not app_key or not app_secret:
            raise Exception("Dropbox credentials not provided.")
        self.access_token = access_token
        self.refresh_token = refresh_token
        self.app_key = app_key
        self.app_secret = app_secret
        self.dbx = dropbox.Dropbox(self.access_token)
        self.dropbox_folder = dropbox_folder.rstrip("/")
        self.validate_token()

    def validate_token(self):
        try:
            self.dbx.users_get_current_account()
        except dropbox.exceptions.AuthError:
            self.refresh_access_token()

    def refresh_access_token(self):
        auth_flow = DropboxOAuth2FlowNoRedirect(
            self.app_key, self.app_secret, token_access_type="offline"
        )
        response = auth_flow.refresh_token(self.refresh_token)
        self.access_token = response.access_token
        self.dbx = dropbox.Dropbox(self.access_token)

    def emit(self, record: logging.LogRecord):
        try:
            log_entry = self.format(record) + "\n"
            dropbox_path = f"{self.dropbox_folder}/airflow_combined.log"

            try:
                _, res = self.dbx.files_download(dropbox_path)
                existing_data = res.content.decode("utf-8")
            except dropbox.exceptions.ApiError:
                existing_data = ""

            updated_data = existing_data + log_entry

            self.dbx.files_upload(
                updated_data.encode("utf-8"),
                dropbox_path,
                mode=dropbox.files.WriteMode.overwrite
            )
        except Exception as e:
            self.handleError(record)
