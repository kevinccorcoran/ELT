# Standard library imports
from datetime import timedelta

# Third-party imports
import pendulum  # For handling dates

# Airflow imports
from airflow import DAG
from airflow.models import Variable
from airflow.utils.dates import days_ago
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sensors.external_task import ExternalTaskSensor

# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="staging")
if env == "dev":
    db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
elif env == "staging":
    db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
else:
    raise ValueError("Invalid environment specified")

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id="metrics_ticker_movement_analysis_dag",
    description="A DAG for assigning data types to columns and modeling the raw table.",
    default_args=default_args,
    start_date=pendulum.today('UTC').subtract(days=1),
    catchup=False,
) as dag:

    # Task to test the database connection
    test_connection = SQLExecuteQueryOperator(
        task_id='test_connection',
        conn_id='postgres_default',
        sql="SELECT 1;",
    )

    # Define environment variables for the BashOperator
    env_vars = {
        'DB_CONNECTION_STRING': db_connection_string,
        'ENV': env,
        'JAVA_HOME': '/usr/local/opt/openjdk@11',
        'PATH': '/Users/kevin/.pyenv/shims:/usr/local/bin:/usr/bin:/bin',
        'PYTHONPATH': '/Users/kevin/Dropbox/applications/ELT/python/src',
    }

    # Task to execute the ETL script
    run_metrics_ticker_movement_analysis_py = BashOperator(
        task_id='run_metrics_ticker_movement_analysis_py',
        bash_command=(
            'echo "DB_CONNECTION_STRING: $DB_CONNECTION_STRING"; '
            'echo "ENV: $ENV"; '  # Print the ENV variable
            '/Users/kevin/.pyenv/shims/python3 /Users/kevin/Dropbox/applications/ELT/python/src/dev/metrics/ticker_movement_analysis.py'
        ),
        env=env_vars,
    )   

    # Set task dependencies
    test_connection >> run_metrics_ticker_movement_analysis_py
