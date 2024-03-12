from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.utils.dates import days_ago
from datetime import timedelta
from airflow.operators.dagrun_operator import TriggerDagRunOperator # Import TriggerDagRunOperator

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
    description="DAG to run a Python script",
    schedule_interval="0 9 * * *", # Run daily at 10 AM
    catchup=False,
    tags=['example', 'python_script'],
)

# Task to run the Python script
run_python_script = BashOperator(
    task_id='run_python_script',
    bash_command='python3 /Users/kevin/Dropbox/applications/ELT/UtilityScripts/build_df_to_sql.py ',
    dag=dag,
)

# Task to trigger cdm_pure_growth_dag
trigger_cdm_historical_daily_main_clean_dag = TriggerDagRunOperator(
    task_id='trigger_cdm_historical_daily_main_clean_dag',
    trigger_dag_id="cdm_historical_daily_main_clean_dag", # The ID of the DAG to trigger
    dag=dag, 
)

# Set task dependencies
run_python_script >> trigger_cdm_historical_daily_main_clean_dag
