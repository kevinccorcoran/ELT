# Standard library imports
from datetime import timedelta

# Related third-party imports
from airflow import DAG
from airflow.operators.bash import BashOperator  # Updated import path for Airflow 2.x
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
    dag_id="build_df_to_sql_dag_crypto",
    default_args=default_args,
    description="DAG to run Python script to update raw.crypto_main",
    schedule_interval="* * * 9 *",  # Run every 5 minutes "*/5 * * * *"
    catchup=False,
    tags=['crypto', 'raw'],
)

# Task to run the Python script
run_build_df_to_sql_py_crypto = BashOperator(
    task_id='run_build_df_to_sql.py',
    bash_command='python3 /Users/kevin/Dropbox/applications/ELT/UtilityScripts/build_df_to_sql_crypto.py ',
    dag=dag,
)

# Set task dependencies
run_build_df_to_sql_py_crypto
