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
    dag_id="history_data_fetcher_dag",
    default_args=default_args,
    description="DAG to run Python script to update raw.history_data_fetcher",
    schedule_interval="0 23 * * *", # Run daily at 9 AM UTC
    catchup=False,
    tags=['yfinance', 'raw_data', 'history_data_fetcher'],
)

# Task to run the Python script
run_build_df_to_sql_py = BashOperator(
    task_id='run_history_data_fetcher_py',
    bash_command='python /Users/kevin/Dropbox/applications/ELT/python/src/dev/raw/history_data_fetcher.py',
    dag=dag,
)

# Task to trigger cdm_historical_daily_main_clean_dag
trigger_cdm_fibonacci_transform_dates_dag = TriggerDagRunOperator(
    task_id='trigger_dag_cdm_fibonacci_transform_dates_table',
    trigger_dag_id="cdm_fibonacci_transform_dates_dag", # The ID of the DAG to trigger
    dag=dag, 
)

# Set task dependencies
run_build_df_to_sql_py >> trigger_cdm_fibonacci_transform_dates_dag
