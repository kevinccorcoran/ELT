# Standard library imports
from datetime import timedelta

# Related third-party imports
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.utils.dates import days_ago


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
    schedule_interval="0 22 * * *", # Run daily at 9 AM UTC
    catchup=False,
    #tags=['yfinance', 'raw_data', 'history_data_fetcher'],
)

# Run the yfinance_to_raw_etl.py Python script, which fetches data from the yfinance API and saves it into the PostgreSQL table dev.raw.yfinance_to_raw_etl
fetch_yfinance_data = BashOperator(
    task_id='fetched_yfinance_data',
    bash_command='python /Users/kevin/Dropbox/applications/ELT/python/src/dev/raw/yfinance_to_raw_etl.py',
    dag=dag,
)

# Trigger the DAG that creates the cdm.fibonacci_transform_dates table
trigger_raw_to_lookup_dag = TriggerDagRunOperator(
    task_id='trigger_dag_for_cdm_fibonacci_transform_dates_lookup_table',
    trigger_dag_id="raw_to_lookup_dag", # The ID of the DAG to trigger
    dag=dag, 
)

# Set task dependencies
fetch_yfinance_data >> trigger_raw_to_lookup_dag