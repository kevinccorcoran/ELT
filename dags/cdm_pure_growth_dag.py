from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.utils.dates import days_ago

with DAG(
    dag_id="cdm_pure_growth_dag",
    start_date=days_ago(1),
    schedule_interval=None,
    catchup=False,
) as dag:

    # Test connection task
    test_connection = PostgresOperator(
        task_id='test_connection',
        postgres_conn_id='postgres_default',
        sql="SELECT  1",
    )

    # Other tasks...

    insert_into_pure_growth = PostgresOperator(
        task_id='insert_into_pure_growth',
        postgres_conn_id='postgres_default',
        sql="""
            INSERT INTO cdm.pure_growth (date, open, high, low, close, adj_close, volume, processed_at)
            SELECT date, open, high, low, close, adj_close, volume, processed_at
            FROM raw.historical_daily_main;
        """,
    )

    # Define task dependencies if any
    test_connection >> insert_into_pure_growth
