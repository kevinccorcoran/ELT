from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.models import Variable
from airflow.operators.python import PythonOperator
import logging

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

# Ensure DB_CONNECTION_STRING is set
assert db_connection_string, f"DATABASE_URL or {env}_DB_CONNECTION_STRING must be set."

# Logging environment for debugging
def log_environment():
    logging.info(f"Environment: {env}")
    logging.info(f"Database Connection String: {db_connection_string}")

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),  # Supports a wide backfill range
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
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

# Log environment task
log_env = PythonOperator(
    task_id='log_env',
    python_callable=log_environment,
    dag=dag,
)

# Set the Bash command and environment dynamically based on the environment
if env == "heroku_postgres":
    bash_command = (
        f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
        f'/app/.heroku/python/bin/python3 /app/python/src/dev/cdm/api_cdm_data_ingestion.py '
    )
    env_vars = {
        'DATABASE_URL': db_connection_string,
        'ENV': env,
    }
else:
    bash_command = (
        'export ENV={{ var.value.ENV }} && '
        'echo "Airflow ENV: $ENV" && '
        '/Users/kevin/.pyenv/shims/python3 /Users/kevin/repos/ELT_private/python/src/dev/cdm/api_cdm_data_ingestion.py '
    )
    env_vars = {
        'DATABASE_URL': db_connection_string,
        'ENV': env,
    }

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
log_env >> insert_api_cdm_data_ingestion >> trigger_raw_to_lookup_dag

# from datetime import datetime, timedelta
# from airflow import DAG
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator
# from airflow.models import Variable
# from airflow.operators.python import PythonOperator

# # Retrieve environment-specific variables
# env = Variable.get("ENV", default_var="dev")
# db_connection_string = None

# if env == "dev":
#     db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
# elif env == "staging":
#     db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
# elif env == "heroku_postgres":
#     db_connection_string = Variable.get("DATABASE_URL")
# else:
#     raise ValueError("Invalid environment specified. Please set a valid ENV variable.")

# # Ensure DB_CONNECTION_STRING is set
# assert db_connection_string, f"DATABASE_URL or {env}_DB_CONNECTION_STRING must be set."

# # Log environment
# log_env = PythonOperator(
#     task_id='log_env',
#     python_callable=lambda: print(f"Environment: {Variable.get('ENV')}"),
# )

# # Define the default arguments for the DAG
# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'start_date': datetime(2023, 1, 1),  # Start date to support a wide backfill range if needed
#     'email_on_failure': False,
#     'email_on_retry': False,
#     'retries': 1,
#     'retry_delay': timedelta(minutes=5),
# }

# # Define the DAG
# dag = DAG(
#     dag_id="raw_to_api_cdm_data_ingestion_dag",
#     default_args=default_args,
#     description="DAG to run a Python script that updates cdm.raw_to_api_cdm_data_ingestion",
#     schedule_interval=None,  # Run only when manually triggered
#     catchup=False,  # Ensures it does not backfill from start_date to now
# )

# # Set the Bash command and environment dynamically based on the environment
# if env == "heroku_postgres":
#     bash_command = (
#         f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
#         f'/app/.heroku/python/bin/python3 /app/python/src/dev/cdm/api_cdm_data_ingestion.py '
#     )
#     env_vars = {
#         'DATABASE_URL': db_connection_string,
#         'ENV': env,
#     }
# else:
#     bash_command = (
#         'export ENV={{ var.value.ENV }} && '
#         'echo "Airflow ENV: $ENV" && '
#         '/Users/kevin/.pyenv/shims/python3 /Users/kevin/repos/ELT_private/python/src/dev/cdm/api_cdm_data_ingestion.py '
#     )
#     env_vars = {
#         'DATABASE_URL': db_connection_string,
#         'ENV': env,
#     }

# # Task to run the yfinance_to_raw_etl.py Python script, passing environment-specific DB connection
# insert_api_cdm_data_ingestion = BashOperator(
#     task_id='insert_api_cdm_data_ingestion',
#     bash_command=bash_command,
#     dag=dag,
# )

# # Task to trigger the next DAG for creating the cdm.fibonacci_transform_dates table
# trigger_raw_to_lookup_dag = TriggerDagRunOperator(
#     task_id='trigger_dag_for_cdm_fibonacci_transform_dates_lookup_table',
#     trigger_dag_id="raw_to_lookup_dag",  # ID of the DAG to trigger
#     dag=dag,
# )

# # Set task dependencies
# insert_api_cdm_data_ingestion >> trigger_raw_to_lookup_dag
