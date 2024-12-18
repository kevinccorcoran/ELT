# gunicorn_config.py
import os

bind = "0.0.0.0:{}".format(os.getenv("PORT", 8000))  # Bind to Heroku's port
workers = 2  # Reduce worker count to fit Heroku's resource limits
timeout = 60  # Ensure app starts within Heroku's boot timeout limit
