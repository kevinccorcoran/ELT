web: gunicorn "airflow.www.app:cached_app()" --bind 0.0.0.0:$PORT
worker: airflow celery worker
scheduler: airflow scheduler
