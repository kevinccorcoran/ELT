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
    dag_id="cdm_ticker_count_by_date_dag",
    description="DAG for creating cdm.ticker_counts_by_date",
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

    # Task to run a DBT command
    dbt_run_ticker_counts_by_date = BashOperator(
        task_id='dbt_run_model_ticker_counts_by_date',
        bash_command=(
            'export ENV={{ var.value.ENV }} && '
            'echo "Airflow ENV: $ENV" && '
            'cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app && '
            'dbt run --models ticker_counts_by_date'
        ),
    )

    # Set task dependencies
    (
        test_connection
        >> dbt_run_ticker_counts_by_date
    )
