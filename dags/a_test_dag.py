from airflow import DAG
from airflow.operators.bash_operator import BashOperator  # Import BashOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.utils.dates import days_ago

# Define the default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

with DAG(
    dag_id="a_test_dag",
    description="A DAG for processing pure growth data with Postgres",
    default_args=default_args,
    start_date=days_ago(1),
    schedule_interval=None,
    catchup=False,
    tags=['example', 'postgres'],
) as dag:

    # Task to test the database connection
    test_connection = PostgresOperator(
        task_id='test_connection',
        postgres_conn_id='postgres_default',
        sql="SELECT 1;",
    )

    # Define a BashOperator task to run a DBT command or any bash command
    dbt_run = BashOperator(
    task_id='dbt_run',
    bash_command='cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app/ && dbt run --models historical_daily_main',
    )

    # Set task dependencies
    test_connection >> dbt_run  # This means dbt_run will execute after test_connection has succeeded
