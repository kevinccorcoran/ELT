from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.models import Variable
from airflow.operators.python import PythonOperator

# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="staging")
if env == "dev":
    db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
elif env == "staging":
    db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
else:
    raise ValueError("Invalid environment specified")

# Log environment
log_env = PythonOperator(
    task_id='log_env',
    python_callable=lambda: print(f"Environment: {Variable.get('ENV')}"),
)

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),  # Start date to support a wide backfill range if needed
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
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

# Task to run the yfinance_to_raw_etl.py Python script, passing environment-specific DB connection
fetch_yfinance_data = BashOperator(
    task_id='fetch_yfinance_data',
    bash_command=(
        'export ENV={{ var.value.ENV }} && '
        'echo "Airflow ENV: $ENV" && '
        '/Users/kevin/.pyenv/shims/python3 /Users/kevin/Dropbox/applications/ELT/python/src/dev/raw/yfinance_to_raw_etl.py '
        '--start_date "1950-01-01" --end_date "{{ macros.ds_add(ds, 0) }}"'
    ),
    env={
        'DB_CONNECTION_STRING': db_connection_string,
        'ENV': env,
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
