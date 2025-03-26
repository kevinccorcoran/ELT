from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
import os

# Retrieve environment-specific variables
env = os.getenv("ENV", "staging")  # Default to staging
database_url = os.getenv("DATABASE_URL", "")  # Directly use DATABASE_URL from Heroku config vars

if not database_url:
    raise ValueError("DATABASE_URL is not set in the Heroku config vars or environment")

# Optional: Modify DATABASE_URL for SQLAlchemy if needed
if database_url.startswith("postgres://"):
    database_url = database_url.replace("postgres://", "postgresql+psycopg2://", 1)

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),  # Wide start date for backfills
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
    schedule_interval=None,  # Only run manually
    catchup=False,
)

# Task to run the yfinance_to_raw_etl.py Python script
fetch_yfinance_data = BashOperator(
    task_id='fetch_yfinance_data',
    bash_command=(
        'set -x && '
        'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
        'echo "Using DATABASE_URL: $DATABASE_URL" && '
        '/app/.heroku/python/bin/python3 /app/python/src/dev/raw/yfinance_to_raw_etl.py '
        '--start_date "1950-01-01" --end_date "{{ ds }}"'
    ),
    env={
        'DATABASE_URL': database_url,  # Pass DATABASE_URL directly
        'ENV': env,  # Optionally pass ENV if needed by your script
    },
    dag=dag,
)

# Task to trigger the next DAG
trigger_api_data_ingestion = TriggerDagRunOperator(
    task_id='trigger_dag_for_cdm_api_data_ingestion_table',
    trigger_dag_id="raw_to_api_data_ingestion_dag",  # ID of the DAG to trigger
    dag=dag,
)

# Set task dependencies
fetch_yfinance_data >> trigger_api_data_ingestion
