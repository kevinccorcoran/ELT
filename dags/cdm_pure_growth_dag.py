import datetime
import os
import pendulum
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

with DAG(
    dag_id="cdm_pure_growth_dag",
    start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    schedule_interval=None,
    catchup=False,
) as dag:

    # Other tasks...

    insert_into_pure_growth = PostgresOperator(
        task_id='insert_into_pure_growth',
        postgres_conn_id='your_postgres_connection_id',
        sql="""
            INSERT INTO cdm.pure_growth (date, open, high, low, close, adj_close, volume, processed_at)
            SELECT date, open, high, low, close, adj_close, volume, processed_at
            FROM raw.historical_daily_main;
        """,
    )

    # Define task dependencies if any
    # e.g., some_previous_task >> insert_into_pure_growth