# Standard library imports
from datetime import timedelta

# Third-party imports
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.sensors.external_task import ExternalTaskSensor
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
    dag_id="metrics_ticker_movement_analysis_dag",
    description="A DAG assigns data types to columns, modeling the raw table.",
    default_args=default_args,
    # Replaced start_date with pendulum and schedule_interval with schedule
    start_date=pendulum.today('UTC').subtract(days=1),
    #schedule=None,  # Updated parameter name
    catchup=False,
    #tags=['metrics', 'ticker_movement_analysis'],
) as dag:

    # Task to test the database connection, updated to use SQLExecuteQueryOperator
    test_connection = SQLExecuteQueryOperator(
        task_id='test_connection',
        conn_id='postgres_default',
        sql="SELECT 1;",
    )

# Task to run the Python script
run_metrics_ticker_movement_analysis_py = BashOperator(
    task_id='run_metrics_ticker_movement_analysis_py',
    bash_command='python /Users/kevin/Dropbox/applications/ELT/python/src/dev/metrics/ticker_movement_analysis.py',
    dag=dag,
) 
   
# Set task dependencies
test_connection >> run_metrics_ticker_movement_analysis_py
