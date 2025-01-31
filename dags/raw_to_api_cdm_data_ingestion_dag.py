# Standard library imports
from datetime import datetime, timedelta
# test
# Airflow-specific imports
from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

# Import Tuple and Dict for Python <3.9 compatibility
from typing import Tuple, Dict

# Configure logging
import logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


def get_db_connection_string(env: str) -> str:
    """
    Retrieve the database connection string based on the environment.
    """
    env_to_var_map = {
        "dev": "DEV_DB_CONNECTION_STRING",
        "staging": "STAGING_DB_CONNECTION_STRING",
        "heroku_postgres": "DATABASE_URL",
    }
    
    if env not in env_to_var_map:
        raise ValueError(f"Invalid environment specified: {env}. Please set a valid ENV variable.")
    
    connection_string = Variable.get(env_to_var_map[env], default_var=None)
    if not connection_string:
        raise ValueError(f"Environment variable {env_to_var_map[env]} is not set.")
    
    return connection_string


def get_bash_command(env: str, db_connection_string: str) -> Tuple[str, Dict[str, str]]:
    """
    Generate the Bash command and environment variables dynamically based on the environment.
    """
    if env == "heroku_postgres":
        bash_command = (
            f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
            f'/app/.heroku/python/bin/python3 /app/python/src/dev/cdm/api_cdm_data_ingestion.py '
            f'--start_date "1950-01-01" --end_date "{{{{ ds }}}}"'
        )
    else:
        bash_command = (
            'export ENV={{ var.value.ENV }} && '
            'echo "Airflow ENV: $ENV" && '
            '/Users/kevin/.pyenv/shims/python3 /Users/kevin/repos/ELT_private/python/src/dev/cdm/api_cdm_data_ingestion.py '
            '--start_date "1950-01-01" --end_date "{{ macros.ds_add(ds, 0) }}"'
        )
    
    env_vars = {
        'DATABASE_URL': db_connection_string,
        'ENV': env,
    }
    
    return bash_command, env_vars


# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="dev")  # Default to "dev" if ENV is not set
db_connection_string = get_db_connection_string(env)

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    dag_id="raw_to_api_cdm_data_ingestion_dag",
    default_args=default_args,
    description="DAG to run a Python script that updates cdm.raw_to_api_cdm_data_ingestion",
    schedule_interval=None,  # Manual trigger only
    catchup=False,
)

# Get the Bash command and environment variables
bash_command, env_vars = get_bash_command(env, db_connection_string)

# Task to run the Python script
insert_api_cdm_data_ingestion = BashOperator(
    task_id='insert_api_cdm_data_ingestion',
    bash_command=bash_command,
    env=env_vars,  # Pass the environment variables to the task
    dag=dag,
)

# Task to trigger the next DAG for creating the lookup table
trigger_raw_to_lookup_dag = TriggerDagRunOperator(
    task_id='trigger_dag_for_cdm_fibonacci_transform_dates_lookup_table',
    trigger_dag_id="raw_to_lookup_dag",  # ID of the DAG to trigger
    dag=dag,
)

# Set task dependencies
insert_api_cdm_data_ingestion >> trigger_raw_to_lookup_dag
