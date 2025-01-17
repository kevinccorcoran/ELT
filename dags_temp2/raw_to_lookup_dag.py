from datetime import timedelta
import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.models import Variable
from airflow.operators.python import PythonOperator

# Retrieve the environment-specific connection string variable
env = Variable.get("ENV", default_var="staging")
if env == "DEV":
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
    dag_id="raw_to_lookup_dag",
    description="DAG to create date lookup table cdm.date_lookup",
    default_args=default_args,
    start_date=pendulum.today('UTC').subtract(days=1),
    catchup=False,
) as dag:

    # Log environment
    log_env = PythonOperator(
        task_id='log_env',
        python_callable=lambda: print(f"Environment: {Variable.get('ENV')}"),
    )

    # Log connection string
    log_db_connection_string = PythonOperator(
        task_id='log_db_connection_string',
        python_callable=lambda: print(f"DB Connection String: {db_connection_string}"),
    )
    
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
        'JAVA_HOME': '/usr/local/opt/openjdk@11',  # Ensure JAVA_HOME is correctly set
        'PATH': '/Users/kevin/.pyenv/shims:/usr/local/bin:/usr/bin:/bin',
        'PYTHONPATH': '/Users/kevin/Dropbox/applications/ELT/python/src',  # Add PYTHONPATH to locate dev module
    }

    # Task to execute the ETL script
    create_cdm_date_lookup_table = BashOperator(
        task_id='create_cdm_date_lookup_table',
        bash_command=(
            'echo "DB_CONNECTION_STRING: $DB_CONNECTION_STRING"; '
            'echo "ENV: $ENV"; '  # Print the ENV variable
            '/Users/kevin/.pyenv/shims/python3 /Users/kevin/Dropbox/applications/ELT/python/src/dev/cdm/raw_to_lookup_etl.py'
        ),
        env=env_vars,
    )   

    # Task to trigger the next DAG for the company CAGR calculation
    cdm_company_cagr_model = TriggerDagRunOperator(
        task_id='trigger_dag_cdm_company_cagr_model',
        trigger_dag_id="cdm_company_cagr_dag",
    )

    # Set task dependencies
    log_env >> log_db_connection_string >> test_connection >> create_cdm_date_lookup_table >> cdm_company_cagr_model
