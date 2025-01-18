import os
from datetime import datetime, timedelta
from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="staging")
db_connection_string = None

if env == "dev":
    db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
elif env == "staging":
    db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
elif env == "heroku_dev":
    db_connection_string = Variable.get("DATABASE_URL")
else:
    raise ValueError("Invalid environment specified. Please set a valid ENV variable.")

# Ensure DATABASE_URL or DB_CONNECTION_STRING is set
assert db_connection_string, f"DATABASE_URL or {env}_DB_CONNECTION_STRING must be set."

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
    dag_id="yfinance_to_raw_test_dag",
    default_args=default_args,
    description="DAG to run a Python script that updates raw data.",
    schedule_interval=None,
    catchup=False,
)

# Set the Bash command based on the environment
if env == "heroku_dev":
    bash_command = (
        f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
        f'/app/.heroku/python/bin/python3 /app/python/src/dev/raw/yfinance_to_raw_etl.py '
        f'--start_date "1950-01-01" --end_date "{{{{ ds }}}}"'
    )
else:
    bash_command = (
        'export ENV={{ var.value.ENV }} && '
        'echo "Airflow ENV: $ENV" && '
        '/Users/kevin/.pyenv/shims/python3 /Users/kevin/Dropbox/applications/ELT/python/src/dev/raw/yfinance_to_raw_etl.py '
        '--start_date "1950-01-01" --end_date "{{ macros.ds_add(ds, 0) }}"'
    )

# Task to run the yfinance_to_raw_etl.py Python script
fetch_yfinance_data = BashOperator(
    task_id='fetch_yfinance_data',
    bash_command=bash_command,
    env={
        'DATABASE_URL': db_connection_string,
        'ENV': env,
    },
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

# import os
# from datetime import datetime, timedelta
# from airflow import DAG
# from airflow.models import Variable
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator

# # Retrieve environment-specific variables
# env = Variable.get("ENV", default_var="staging")

# if env == "dev":
#     db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
# elif env == "staging":
#     db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
# elif env in {"heroku_dev"}:
#     db_connection_string = Variable.get("DATABASE_URL")
# else:
#     raise ValueError("Invalid environment specified")

# # Ensure DATABASE_URL is set
# assert db_connection_string, f"DATABASE_URL or {env}_DB_CONNECTION_STRING is not set in Airflow Variables."

# # Define the default arguments for the DAG
# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'start_date': datetime(2023, 1, 1),
#     'email_on_failure': False,
#     'email_on_retry': False,
#     'retries': 0,
#     'retry_delay': timedelta(minutes=5),
# }

# # Define the DAG
# dag = DAG(
#     dag_id="yfinance_to_raw_test_dag",
#     default_args=default_args,
#     description="DAG to run a Python script that updates raw.",
#     schedule_interval=None,
#     catchup=False,
# )

# # Task to run the yfinance_to_raw_etl.py Python script
# bash_command = (
#     f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
#     f'/app/.heroku/python/bin/python3 /app/python/src/dev/raw/yfinance_to_raw_etl.py '
#     f'--start_date "1950-01-01" --end_date "{{{{ ds }}}}"'
# )

# fetch_yfinance_data = BashOperator(
#     task_id='fetch_yfinance_data',
#     bash_command=bash_command,
#     env={
#         'DATABASE_URL': db_connection_string,
#         'ENV': env,
#     },
#     dag=dag,
# )

# # Task to trigger the next DAG
# trigger_api_cdm_data_ingestion = TriggerDagRunOperator(
#     task_id='trigger_dag_for_cdm_api_cdm_data_ingestion_table',
#     trigger_dag_id="raw_to_api_cdm_data_ingestion_dag",
#     dag=dag,
# )

# # Set task dependencies
# fetch_yfinance_data >> trigger_api_cdm_data_ingestion

# simplied dotenv and postgres WORKS
# import os
# from datetime import datetime, timedelta
# from airflow import DAG
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator

# # Retrieve DATABASE_URL from Heroku config vars
# database_url = os.getenv("DATABASE_URL")
# assert database_url, "DATABASE_URL is required but not set in Heroku config vars."

# # Define the default arguments for the DAG
# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'start_date': datetime(2023, 1, 1),
#     'email_on_failure': False,
#     'email_on_retry': False,
#     'retries': 0,
#     'retry_delay': timedelta(minutes=5),
# }

# # Define the DAG
# dag = DAG(
#     dag_id="yfinance_to_raw_test_dag",
#     default_args=default_args,
#     description="DAG to run a Python script that updates raw.",
#     schedule_interval=None,
#     catchup=False,
# )

# # Task to run the yfinance_to_raw_etl.py Python script
# bash_command = (
#     f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
#     f'/app/.heroku/python/bin/python3 /app/python/src/dev/raw/yfinance_to_raw_etl.py '
#     f'--start_date "1950-01-01" --end_date "{{{{ ds }}}}"'
# )

# fetch_yfinance_data = BashOperator(
#     task_id='fetch_yfinance_data',
#     bash_command=bash_command,
#     env={
#         'DATABASE_URL': database_url,
#         'ENV': 'staging',
#     },
#     dag=dag,
# )

# # Task to trigger the next DAG
# trigger_api_cdm_data_ingestion = TriggerDagRunOperator(
#     task_id='trigger_dag_for_cdm_api_cdm_data_ingestion_table',
#     trigger_dag_id="raw_to_api_cdm_data_ingestion_dag",
#     dag=dag,
# )

# # Set task dependencies
# fetch_yfinance_data >> trigger_api_cdm_data_ingestion


# work heroku
# import os
# from dotenv import load_dotenv
# from datetime import datetime, timedelta
# from airflow import DAG
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator

# # Load .env for local development
# load_dotenv()

# # Retrieve environment-specific variables
# env = os.getenv("ENV", "staging")  # Default to staging
# database_url = os.getenv("DATABASE_URL", "")

# if not database_url:
#     raise ValueError("DATABASE_URL is not set in the Heroku config vars or environment")

# # Modify DATABASE_URL for SQLAlchemy if needed
# if database_url.startswith("postgres://"):
#     database_url = database_url.replace("postgres://", "postgresql+psycopg2://", 1)

# is_local = env == "local"

# # Define the default arguments for the DAG
# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'start_date': datetime(2023, 1, 1),
#     'email_on_failure': False,
#     'email_on_retry': False,
#     'retries': 0,
#     'retry_delay': timedelta(minutes=5),
# }

# # Define the DAG
# dag = DAG(
#     dag_id="yfinance_to_raw_test_dag",
#     default_args=default_args,
#     description="DAG to run a Python script that updates raw.",
#     schedule_interval=None,
#     catchup=False,
# )

# # Task to run the yfinance_to_raw_etl.py Python script
# bash_command = (
#     f'set -x && '
#     f'export PYTHONPATH=$PYTHONPATH:{"." if is_local else "/app/python/src"} && '
#     f'echo "Using DATABASE_URL: $DATABASE_URL" && '
#     f'{"python3" if is_local else "/app/.heroku/python/bin/python3"} '
#     f'{"python/src/dev/raw/yfinance_to_raw_etl.py" if is_local else "/app/python/src/dev/raw/yfinance_to_raw_etl.py"} '
#     f'--start_date "1950-01-01" --end_date "{{{{ ds }}}}"'
# )

# fetch_yfinance_data = BashOperator(
#     task_id='fetch_yfinance_data',
#     bash_command=bash_command,
#     env={
#         'DATABASE_URL': database_url,
#         'ENV': env,
#     },
#     dag=dag,
# )

# # Task to trigger the next DAG
# trigger_api_cdm_data_ingestion = TriggerDagRunOperator(
#     task_id='trigger_dag_for_cdm_api_cdm_data_ingestion_table',
#     trigger_dag_id="raw_to_api_cdm_data_ingestion_dag",
#     dag=dag,
# )

# # Set task dependencies
# fetch_yfinance_data >> trigger_api_cdm_data_ingestion
