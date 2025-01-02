# Standard library imports
from datetime import timedelta

# Related third-party imports
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.utils.dates import days_ago
from airflow.models import Variable

# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="staging")
if env == "dev":
    db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
elif env == "staging":
    db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
else:
    raise ValueError("Invalid environment specified")

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    dag_id="yfinance_to_raw",
    default_args=default_args,
    description="DAG to run a Python script that updates raw.",
    schedule_interval="45 23 * * *",  # Run daily at 23:45 UTC
    catchup=False,
)

# Task to run the yfinance_to_raw_etl.py script, fetching data from the yfinance API and saving it into the PostgreSQL table dev.raw.yfinance_to_raw_etl
fetch_yfinance_data = BashOperator(
    task_id='fetched_yfinance_data',
    bash_command='python /Users/kevin/Dropbox/applications/ELT/python/src/dev/raw/yfinance_to_raw_etl.py',
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
