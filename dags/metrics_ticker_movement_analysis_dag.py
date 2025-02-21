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
            f'/app/.heroku/python/bin/python3 /app/python/src/dev/metrics/ticker_movement_analysis.py '
            f'--start_date "1950-01-01" --end_date "{{{{ ds }}}}"'
        )
    else:
        bash_command = (
            'export ENV={{ var.value.ENV }} && '
            'echo "Airflow ENV: $ENV" && '
            '/Users/kevin/.pyenv/shims/python3 /Users/kevin/repos/ELT_private/python/src/dev/metrics/ticker_movement_analysis.py '
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
    dag_id="metrics_ticker_movement_analysis_dag",
    default_args=default_args,
    description="DAG to run a Python script that updates metrics.ticker_movement_analysis",
    schedule_interval=None,  # Manual trigger only
    catchup=False,
)

# Get the Bash command and environment variables
bash_command, env_vars = get_bash_command(env, db_connection_string)

# Task to run the Python script
run_metrics_ticker_movement_analysis_py = BashOperator(
    task_id='run_metrics_ticker_movement_analysis_py',
    bash_command=bash_command,
    env=env_vars,  # Pass the environment variables to the task
    dag=dag,
)

# # Task to trigger the next DAG for creating the lookup table
# cdm_company_cagr_model = TriggerDagRunOperator(
#     task_id='trigger_dag_cdm_company_cagr_model',
#     trigger_dag_id="cdm_company_cagr_dag",  # ID of the DAG to trigger
#     dag=dag,
# )

# Set task dependencies
run_metrics_ticker_movement_analysis_py


# # Standard library imports
# from datetime import timedelta

# # Third-party imports
# import pendulum  # For handling dates

# # Airflow imports
# from airflow import DAG
# from airflow.models import Variable
# from airflow.utils.dates import days_ago
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator
# from airflow.operators.python import PythonOperator
# from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
# from airflow.sensors.external_task import ExternalTaskSensor

# # Retrieve environment-specific variables
# env = Variable.get("ENV", default_var="staging")
# if env == "dev":
#     db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
# elif env == "staging":
#     db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
# else:
#     raise ValueError("Invalid environment specified")

# # Define the default arguments for the DAG
# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'email_on_failure': False,
#     'email_on_retry': False,
#     'retries': 1,
#     'retry_delay': timedelta(minutes=5),
# }

# with DAG(
#     dag_id="metrics_ticker_movement_analysis_dag",
#     description="A DAG for assigning data types to columns and modeling the raw table.",
#     default_args=default_args,
#     start_date=pendulum.today('UTC').subtract(days=1),
#     catchup=False,
# ) as dag:

#     # Task to test the database connection
#     test_connection = SQLExecuteQueryOperator(
#         task_id='test_connection',
#         conn_id='postgres_default',
#         sql="SELECT 1;",
#     )

#     # Define environment variables for the BashOperator
#     env_vars = {
#         'DB_CONNECTION_STRING': db_connection_string,
#         'ENV': env,
#         'JAVA_HOME': '/usr/local/opt/openjdk@11',
#         'PATH': '/Users/kevin/.pyenv/shims:/usr/local/bin:/usr/bin:/bin',
#         'PYTHONPATH': '/Users/kevin/Dropbox/applications/ELT/python/src',
#     }

#     # Task to execute the ETL script
#     run_metrics_ticker_movement_analysis_py = BashOperator(
#         task_id='run_metrics_ticker_movement_analysis_py',
#         bash_command=(
#             'echo "DB_CONNECTION_STRING: $DB_CONNECTION_STRING"; '
#             'echo "ENV: $ENV"; '  # Print the ENV variable
#             '/Users/kevin/.pyenv/shims/python3 /Users/kevin/Dropbox/applications/ELT/python/src/dev/metrics/ticker_movement_analysis.py'
#         ),
#         env=env_vars,
#     )   

#     # Set task dependencies
#     test_connection >> run_metrics_ticker_movement_analysis_py
