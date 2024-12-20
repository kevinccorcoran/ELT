web: airflow webserver --port $PORT
worker: airflow celery worker
scheduler: airflow scheduler
web: gunicorn "airflow.www.app:cached_app()" --bind 0.0.0.0:$PORT
web: gunicorn "airflow.www.app:cached_app()"
web: ./init.sh && airflow webserver
worker: ./init.sh && airflow worker

