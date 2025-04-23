from datetime import timedelta, datetime
from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
import logging
from typing import Tuple, Dict

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_db_connection_string(env: str) -> str:
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
    if env == "heroku_postgres":
        bash_command = (
            f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
            f'/app/.heroku/python/bin/python3 /app/python/src/dev/raw/yfinance_to_raw_etl.py '
            f'--start_date {{ ds }} --end_date {{ data_interval_end | ds }}'
        )
    else:
        bash_command = (
            'export ENV={{ var.value.ENV }} && '
            'echo "Airflow ENV: $ENV" && '
            '/Users/kevin/.pyenv/shims/python3 /Users/kevin/repos/ELT_private/python/src/dev/raw/yfinance_to_raw_etl.py '
            '--start_date {{ ds }} --end_date {{ data_interval_end | ds }}'
        )
    env_vars = {'DATABASE_URL': db_connection_string, 'ENV': env}
    return bash_command, env_vars

# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="dev")
db_connection_string = get_db_connection_string(env)

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,  # No dependency on previous runs
    'start_date': datetime(1950, 1, 1),  # Start date to support backfill
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG for ad hoc triggering
dag = DAG(
    dag_id="raw_api_data_ingestion_backfill",
    default_args=default_args,
    description="Ad hoc DAG for historical yfinance data",
    schedule_interval=None,  # Ad hoc execution only
    catchup=True,  # Disable automatic backfills
    max_active_runs=1  # Only allow one active run at a time
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
    wait_for_completion=True,
    dag=dag,
)

# Set task dependencies
fetch_yfinance_data >> trigger_cdm_api_data_ingestion