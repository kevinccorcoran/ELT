from datetime import timedelta
from airflow import DAG
# Updated import paths for ExternalTaskSensor and BashOperator
from airflow.sensors.external_task import ExternalTaskSensor
from airflow.operators.bash import BashOperator
from airflow.operators.dagrun_operator import TriggerDagRunOperator
# New import for SQLExecuteQueryOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
import pendulum  # For handling dates
from airflow.operators.python import PythonOperator
#from pytest_tests import run_tests


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
    dag_id="cdm_historical_daily_main_clean_dag",
    description="A DAG for processing pure growth data with Postgres, triggered after build_df_to_sql_dag",
    default_args=default_args,
    # Replaced start_date with pendulum and schedule_interval with schedule
    start_date=pendulum.today('UTC').subtract(days=1),
    #schedule=None,  # Updated parameter name
    catchup=False,
    tags=['example', 'postgres'],
) as dag:

    # Task to test the database connection, updated to use SQLExecuteQueryOperator
    test_connection = SQLExecuteQueryOperator(
        task_id='test_connection',
        conn_id='postgres_default',
        sql="SELECT 1;",
    )

    # Task to run a DBT command or any bash command
    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command='cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app/ && dbt run --models historical_daily_main_clean',
    )

    # Task to run the Python script
    run_python_script = BashOperator(
        task_id='run_python_script',
        bash_command='pytest /Users/kevin/Dropbox/applications/ELT/pytest_tests/ || true',
        dag=dag,
)

# Task to run a DBT command or any bash command
    dbt_run_udi = BashOperator(
        task_id='dbt_run_udi',
        bash_command='cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app/ && dbt run --models user_data_integrity',
    )

    # Task to trigger cdm_pure_growth_dag
    trigger_cdm_pure_growth_dag = TriggerDagRunOperator(
        task_id='trigger_cdm_pure_growth_dag',
        trigger_dag_id="cdm_pure_growth_dag", # The ID of the DAG to trigger
        dag=dag, 
)
   
    # Set task dependencies
    test_connection >> dbt_run >> run_python_script >> dbt_run_udi >> trigger_cdm_pure_growth_dag
