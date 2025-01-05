from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
import os

# Retrieve environment-specific variables from environment variables
env = os.getenv("ENV", "staging")  # Default to staging
db_connection_string = os.getenv("DB_CONNECTION_STRING", "")

if not db_connection_string:
    raise ValueError("DB_CONNECTION_STRING is not set in the environment")

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),  # Start date to support a wide backfill range if needed
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    dag_id="yfinance_to_raw_test_dag",
    default_args=default_args,
    description="DAG to run a Python script that updates raw.",
    schedule_interval=None,  # Run only when manually triggered
    catchup=False,  # Ensures it does not backfill from start_date to now
)

# # Task to run the yfinance_to_raw_etl.py Python script, passing environment-specific DB connection
# fetch_yfinance_data = BashOperator(
#     task_id='fetch_yfinance_data',
#     bash_command=(
#         'if [ -x /app/.heroku/python/bin/python3 ]; then '
#         'PYTHON_EXEC=/app/.heroku/python/bin/python3; '
#         'else '
#         'PYTHON_EXEC=python3; '
#         'fi && '
#         'export ENV={{ var.value.ENV }} && '
#         'echo "Airflow ENV: $ENV" && '
#         '$PYTHON_EXEC /app/python/src/dev/raw/yfinance_to_raw_etl.py '
#         '--start_date "1950-01-01" --end_date "{{ macros.ds_add(ds, 0) }}"'
#     ),
#     env={
#         'DB_CONNECTION_STRING': db_connection_string,
#         'ENV': env,
#     },
#     dag=dag,
# )

fetch_yfinance_data = BashOperator(
    task_id='fetch_yfinance_data',
    bash_command=(
        'set -x && '
        'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
        'export ENV=postgresql+psycopg2://postgres:9356@localhost:5433/dev && '
        'echo "Airflow ENV: $ENV" && '
        '/app/.heroku/python/bin/python3 /app/python/src/dev/raw/yfinance_to_raw_etl.py '
        '--start_date "1950-01-01" --end_date "2025-01-05"'
    ),
    env={
        'DB_CONNECTION_STRING': db_connection_string,
    },
    dag=dag,
)

# Task to trigger the next DAG for creating the cdm.fibonacci_transform_dates table
trigger_api_cdm_data_ingestion = TriggerDagRunOperator(
    task_id='trigger_dag_for_cdm_api_cdm_data_ingestion_table',
    trigger_dag_id="raw_to_api_cdm_data_ingestion_dag",  # ID of the DAG to trigger
    dag=dag,
)

# Set task dependencies
fetch_yfinance_data >> trigger_api_cdm_data_ingestion
