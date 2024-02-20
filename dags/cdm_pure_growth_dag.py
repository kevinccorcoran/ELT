from datetime import datetime
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

# Define the default_args dictionary
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

# Define the DAG
dag = DAG(
    'update_downstream_table',
    default_args=default_args,
    description='A DAG to run an SQL insert statement on a downstream table',
    schedule_interval=None,  # Set to None for manual triggering
    start_date=datetime(2024, 1, 1),
    catchup=False,
)

# Define the SQL query to be executed
sql_query = """
INSERT INTO downstream_table (column1, column2)
SELECT column1, column2 FROM upstream_table
WHERE condition = 'True';
"""

# Define the task
update_downstream_table_task = PostgresOperator(
    task_id='update_downstream_table',
    postgres_conn_id='your_postgres_connection_id',
    sql=sql_query,
    dag=dag,
)
