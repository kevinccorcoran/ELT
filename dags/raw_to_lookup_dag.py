from datetime import timedelta
import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.models import Variable

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

    # Task to test the database connection
    test_connection = SQLExecuteQueryOperator(
        task_id='test_connection',
        conn_id='postgres_default',
        sql="SELECT 1;",
    )

    # Retrieve the environment-specific connection string variable
    env = Variable.get("ENV", default_var="dev")
    if env == "dev":
        db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
    elif env == "staging":
        db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
    else:
        raise ValueError("Invalid environment specified")

    # Define environment variables to pass to the BashOperator
    env_vars = {
        'DB_CONNECTION_STRING': db_connection_string,
        'JAVA_HOME': '/usr/local/opt/openjdk@11',  # Ensure JAVA_HOME is correctly set
        'PATH': '/Users/kevin/.pyenv/shims:/usr/local/bin:/usr/bin:/bin',
        'PYTHONPATH': '/Users/kevin/Dropbox/applications/ELT/python/src',  # Add PYTHONPATH to locate dev module
    }

    # Task to execute the ETL script
    create_cdm_date_lookup_table = BashOperator(
        task_id='created_cdm_date_lookup_table',
        bash_command='python3 /Users/kevin/Dropbox/applications/ELT/python/src/dev/cdm/raw_to_lookup_etl.py',
        env=env_vars,
    )

    # Task to trigger the next DAG for the company CAGR calculation
    cdm_company_cagr_model = TriggerDagRunOperator(
        task_id='trigger_dag_cdm_company_cagr_model',
        trigger_dag_id="cdm_company_cagr_dag",  # ID of the DAG to trigger
    )

    # Set task dependencies
    test_connection >> create_cdm_date_lookup_table >> cdm_company_cagr_model

# WORKS
# from datetime import timedelta
# import pendulum
# from airflow import DAG
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator
# from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
# from airflow.models import Variable

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
#     dag_id="raw_to_lookup_dag",
#     description="DAG to create date lookup table cdm.date_lookup",
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

#     # Retrieve the environment-specific connection string variable
#     env = Variable.get("ENV", default_var="dev")
#     if env == "dev":
#         db_connection_string = Variable.get("DEV_DB_CONNECTION_STRING")
#     elif env == "staging":
#         db_connection_string = Variable.get("STAGING_DB_CONNECTION_STRING")
#     else:
#         raise ValueError("Invalid environment specified")

#     # Define environment variables to pass to the BashOperator
#     env_vars = {
#         'DB_CONNECTION_STRING': db_connection_string,
#         'JAVA_HOME': '/usr/local/opt/openjdk@11',  # Ensure JAVA_HOME is correctly set
#         'PATH': '/Users/kevin/.pyenv/shims:/usr/local/bin:/usr/bin:/bin',
#     }

#     # Task to execute the ETL script
#     create_cdm_date_lookup_table = BashOperator(
#         task_id='created_cdm_date_lookup_table',
#         bash_command='python3 /Users/kevin/Dropbox/applications/ELT/python/src/dev/cdm/raw_to_lookup_etl.py',
#         env=env_vars,
#     )

#     # Task to trigger the next DAG for the company CAGR calculation
#     cdm_company_cagr_model = TriggerDagRunOperator(
#         task_id='trigger_dag_cdm_company_cagr_model',
#         trigger_dag_id="cdm_company_cagr_dag",  # ID of the DAG to trigger
#     )

#     # Set task dependencies
#     test_connection >> create_cdm_date_lookup_table >> cdm_company_cagr_model


# # Standard library imports
# from datetime import timedelta

# # Third-party imports
# from airflow import DAG
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator
# from airflow.operators.python import PythonOperator
# from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
# from airflow.sensors.external_task import ExternalTaskSensor
# import pendulum  # For handling dates

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
#     dag_id="raw_to_lookup_dag",
#     description="DAG to create date lookup table cdm.date_lookup",
#     default_args=default_args,
#     # Replaced start_date with pendulum and schedule_interval with schedule
#     start_date=pendulum.today('UTC').subtract(days=1),
#     #schedule=None,  # Updated parameter name
#     catchup=False,
#     #tags=['cdm', 'fibonacci_transform_dates'],
# ) as dag:

#     # Task to test the database connection, updated to use SQLExecuteQueryOperator
#     test_connection = SQLExecuteQueryOperator(
#         task_id='test_connection',
#         conn_id='postgres_default',
#         sql="SELECT 1;",
#     )

# # This script processes and saves stock data in lookup table, ensuring no duplicates  exists
# create_cdm_date_lookup_table = BashOperator(
#     task_id='created_cdm_date_lookup_table',
#     bash_command='python /Users/kevin/Dropbox/applications/ELT/python/src/dev/cdm/raw_to_lookup_etl.py',
#     dag=dag,
# ) 
#     # Task to trigger cdm_company_cagr_dag
# cdm_company_cagr_model = TriggerDagRunOperator(
#     task_id='trigger_dag_cdm_company_cagr_model',
#     trigger_dag_id="cdm_company_cagr_dag", # The ID of the DAG to trigger
#     dag=dag, 
# )
   
# # Set task dependencies
# test_connection >> create_cdm_date_lookup_table >> cdm_company_cagr_model
