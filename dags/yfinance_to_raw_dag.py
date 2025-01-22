# Standard library imports
from datetime import timedelta
from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.utils.dates import days_ago

# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="dev")
db_connection_string = None

if env == "dev":
    db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
elif env == "staging":
    db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
elif env == "heroku_postgres":
    db_connection_string = Variable.get("DATABASE_URL")
else:
    raise ValueError("Invalid environment specified. Please set a valid ENV variable.")

assert db_connection_string, f"DATABASE_URL or {env}_DB_CONNECTION_STRING must be set."

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(2),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    dag_id="yfinance_to_raw",
    default_args=default_args,
    description="Daily run updates raw data",
    schedule_interval="45 23 * * *",
    catchup=False,
)

# Bash command and environment
if env == "heroku_postgres":
    bash_command = (
        f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
        f'/app/.heroku/python/bin/python3 /app/python/src/dev/raw/yfinance_to_raw_etl.py '
    )
    env_vars = {'DATABASE_URL': db_connection_string, 'ENV': env}
else:
    bash_command = (
        'export ENV={{ var.value.ENV }} && '
        'echo "Airflow ENV: $ENV" && '
        '/Users/kevin/.pyenv/shims/python3 /Users/kevin/repos/ELT_private/python/src/dev/raw/yfinance_to_raw_etl.py '
    )
    env_vars = {'DATABASE_URL': db_connection_string, 'ENV': env}

# Task to run the yfinance_to_raw_etl.py script
fetch_yfinance_data = BashOperator(
    task_id='fetch_yfinance_data',
    bash_command=bash_command,
    env=env_vars,
    dag=dag,
)

# Task to trigger the next DAG
trigger_api_cdm_data_ingestion = TriggerDagRunOperator(
    task_id='trigger_dag_for_cdm_api_cdm_data_ingestion_table',
    trigger_dag_id="raw_to_api_cdm_data_ingestion_dag",
    dag=dag,
)

# Set task dependencies
fetch_yfinance_data >> trigger_api_cdm_data_ingestion
