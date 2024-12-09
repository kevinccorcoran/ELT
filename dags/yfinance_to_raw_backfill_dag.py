from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.models import Variable
from datetime import datetime, timedelta

# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="staging")
if env == "dev":
    db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
elif env == "staging":
    db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
else:
    raise ValueError("Invalid environment specified")

# Define the default arguments for the backfill DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the backfill DAG, set to only run when manually triggered
backfill_dag = DAG(
    dag_id="yfinance_to_raw_backfill_dag",
    default_args=default_args,
    description="Backfill DAG for historical yfinance data",
    schedule_interval='@daily',  # Temporarily set to @daily for backfilling range
    start_date=datetime(1950, 1, 1),  # Start date to support a wide backfill range
    catchup=True,  # Enable catchup for CLI range backfill
)

# Task to run the Python script with date ranges passed as environment variables
backfill_yfinance_data = BashOperator(
    task_id='backfill_yfinance_data_task',
    bash_command=(
        'export ENV={{ var.value.ENV }} && '
        'echo "Airflow ENV: $ENV" &&'
        '/Users/kevin/.pyenv/shims/python3 /Users/kevin/Dropbox/applications/ELT/python/src/dev/raw/yfinance_to_raw_etl.py '
        '--start_date {{ ds }} --end_date {{ data_interval_end | ds }}'
    ),
    env={
        'DB_CONNECTION_STRING': db_connection_string,
        'ENV': env
    },
    dag=backfill_dag,
)

# Task to trigger the next DAG for creating the cdm.fibonacci_transform_dates table
trigger_api_cdm_data_ingestion = TriggerDagRunOperator(
    task_id='trigger_dag_for_cdm_api_cdm_data_ingestion_table',
    trigger_dag_id="raw_to_api_cdm_data_ingestion_dag",  # ID of the DAG to trigger
    dag=backfill_dag,
)

# Set task dependencies
backfill_yfinance_data >> trigger_api_cdm_data_ingestion
