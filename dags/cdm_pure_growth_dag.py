from datetime import timedelta
from airflow import DAG
# Updated import paths for ExternalTaskSensor and BashOperator
from airflow.sensors.external_task import ExternalTaskSensor
from airflow.operators.bash import BashOperator
from airflow.operators.dagrun_operator import TriggerDagRunOperator
# New import for SQLExecuteQueryOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
import pendulum  # For handling dates

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
    dag_id="cdm_pure_growth_dag",
    description="A DAG for processing pure growth data with Postgres, triggered after build_df_to_sql_dag",
    default_args=default_args,
    # Replaced start_date with pendulum and schedule_interval with schedule
    start_date=pendulum.today('UTC').subtract(days=1),
    #schedule=None,  # Updated parameter name
    catchup=False,
    tags=['example', 'postgres'],
) as dag:

    # Wait for build_df_to_sql_dag.py to complete
    # wait_for_build_df_to_sql = ExternalTaskSensor(
    #     task_id='wait_for_build_df_to_sql',
    #     external_dag_id='build_df_to_sql_dag',
    #     external_task_id=None,
    #     mode='reschedule',
    #     poke_interval=10,  # Checks every 60 seconds; adjust based on your needs
    #     timeout=20,  # Increased timeout to 10 minutes
    # )

    # Task to test the database connection, updated to use SQLExecuteQueryOperator
    test_connection = SQLExecuteQueryOperator(
        task_id='test_connection',
        conn_id='postgres_default',
        sql="SELECT 1;",
    )

    # Task to run a DBT command or any bash command
    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command='cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app/ && dbt run --models pure_growth',
    )
   

    # Set task dependencies
    test_connection >> dbt_run
