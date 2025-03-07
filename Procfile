release: ./release.sh
release: airflow db upgrade
web: gunicorn "airflow.www.app:cached_app()" --bind 0.0.0.0:$PORT
scheduler: airflow scheduler
worker: airflow celery worker
