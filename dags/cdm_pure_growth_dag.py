from airflow import DAG
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
    dag_id="cdm_pure_growth_dag",
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

    # Task to insert data into the pure_growth table
    insert_into_pure_growth = PostgresOperator(
        task_id='insert_into_pure_growth',
        postgres_conn_id='postgres_default',
        sql="""
            INSERT INTO cdm.pure_growth (date, ticker, open, high, low, close, adj_close, volume, processed_at)
            SELECT date, ticker, open, high, low, close, adj_close, volume, processed_at
            FROM raw.historical_daily_main;
        """,
    )

    # Set task dependencies
    test_connection >> insert_into_pure_growth
