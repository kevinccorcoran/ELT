from datetime import timedelta
from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.utils.dates import days_ago
import logging
from typing import Tuple, Dict

# Configure logging
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
        f'/app/.heroku/python/bin/python3 /app/python/src/dev/raw/yfinance_to_raw_etl.py '
        f'--start_date "{{{{ macros.ds_add(ds, -1) }}}}" --end_date "{{{{ ds }}}}"'
    )

    else:
        bash_command = (
            'export ENV={{ var.value.ENV }} && '
            'echo "Airflow ENV: $ENV" && '
            '/Users/kevin/repos/ELT_private/airflow_venv/bin/python '  # Use the correct Python
            '/Users/kevin/repos/ELT_private/python/src/dev/raw/yfinance_to_raw_etl.py '
            '--start_date "{{ macros.ds_add(ds, -1) }}" --end_date "{{ ds }}"'
        )


    
    env_vars = {
        'DATABASE_URL': db_connection_string,
        'ENV': env,
    }
    
    return bash_command, env_vars


# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="dev")
db_connection_string = get_db_connection_string(env)

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

# Define the DAG with a daily schedule
dag = DAG(
    dag_id="raw_api_data_ingestion",
    default_args=default_args,
    description="Daily run updates raw data",
    schedule_interval="35 11 * * *",  # Runs at 00:00 and 00:05 daily
    catchup=False,
)

# Get the Bash command and environment variables
bash_command, env_vars = get_bash_command(env, db_connection_string)

# Task to run the yfinance_to_raw_etl.py script
fetch_yfinance_data = BashOperator(
    task_id='fetch_yfinance_data',
    bash_command=bash_command,
    env=env_vars,
    dag=dag,
)

# Task to trigger the next DAG
trigger_cdm_api_data_ingestion = TriggerDagRunOperator(
    task_id='trigger_dag_for_cdm_api_data_ingestion_table',
    trigger_dag_id="cdm_api_data_ingestion",
    dag=dag,
)

# Set task dependencies
fetch_yfinance_data >> trigger_cdm_api_data_ingestion