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
    dag_id="build_df_to_sql_dag",
    default_args=default_args,
    description="DAG to run Python script to update raw.historical_daily_main",
    schedule_interval="0 23 * * *", # Run daily at 9 AM UTC
    catchup=False,
    tags=['yfinance', 'raw_data', 'build_df_to_sql'],
)

# Task to run the Python script
run_build_df_to_sql_py = BashOperator(
    task_id='run_build_df_to_sql.py',
    bash_command='python3 /Users/kevin/Dropbox/applications/ELT/UtilityScripts/build_df_to_sql.py ',
    dag=dag,
)

# Task to trigger cdm_historical_daily_main_clean_dag
trigger_cdm_historical_daily_main_clean_dag = TriggerDagRunOperator(
    task_id='trigger_cdm_historical_daily_main_clean_dag',
    trigger_dag_id="cdm_historical_daily_main_clean_dag", # The ID of the DAG to trigger
    dag=dag, 
)

# Set task dependencies
run_build_df_to_sql_py >> trigger_cdm_historical_daily_main_clean_dag
