# Standard library imports
from datetime import timedelta

# Related third-party imports
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
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
    dag_id="metrics_cagr_metric_dag",
    description="DAG for creating metrics.cagr_metric",
    default_args=default_args,
    # Replaced start_date with pendulum and schedule_interval with schedule
    start_date=pendulum.today('UTC').subtract(days=1),
    #schedule=None,  # Updated parameter name
    catchup=False,
    #tags=['example', 'postgres'],
) as dag:

    # Task to test the database connection, updated to use SQLExecuteQueryOperator
    test_connection = SQLExecuteQueryOperator(
        task_id='test_connection',
        conn_id='postgres_default',
        sql="SELECT 1;",
    )

    # Task to run a DBT command or any bash command
    dbt_run = BashOperator(
        task_id='dbt_run_model_cagr_metric',
        bash_command='cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app/models/app/metrics/ && dbt run --models company_cagr_metrics',
    )

    # Set task dependencies
    test_connection >> dbt_run
