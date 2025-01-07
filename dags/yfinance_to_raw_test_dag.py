from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
import os
from datetime import datetime, timedelta

env = os.getenv("ENV", "staging")
database_url = os.getenv("DATABASE_URL", "")

if not database_url:
    raise ValueError("DATABASE_URL is not set in the Heroku config vars or environment")

# Convert 'postgres://' to 'postgresql+psycopg2://'
if database_url.startswith("postgres://"):
    database_url = database_url.replace("postgres://", "postgresql+psycopg2://", 1)

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    dag_id="yfinance_to_raw_test_dag",
    default_args=default_args,
    description="DAG to run a Python script that updates raw.",
    schedule_interval=None,
    catchup=False,
)

fetch_yfinance_data = BashOperator(
    task_id='fetch_yfinance_data',
    bash_command=(
        'set -x && '
        'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
        'echo "Using database URL: $DB_CONNECTION_STRING" && '
        '/app/.heroku/python/bin/python3 /app/python/src/dev/raw/yfinance_to_raw_etl.py '
        '--start_date "1950-01-01" --end_date "{{ ds }}"'
    ),
    # Pass in the environment variables exactly as the script expects
    env={
        'DB_CONNECTION_STRING': database_url,
        'ENV': env,  # optional if your script also needs 'ENV'
    },
    dag=dag,
)

trigger_api_cdm_data_ingestion = TriggerDagRunOperator(
    task_id='trigger_dag_for_cdm_api_cdm_data_ingestion_table',
    trigger_dag_id="raw_to_api_cdm_data_ingestion_dag",
    dag=dag,
)

fetch_yfinance_data >> trigger_api_cdm_data_ingestion
