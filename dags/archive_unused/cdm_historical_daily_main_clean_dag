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
    dag_id="cdm_historical_daily_main_clean_dag",
    description="A DAG assigns data types to columns, modeling the raw table.",
    default_args=default_args,
    # Replaced start_date with pendulum and schedule_interval with schedule
    start_date=pendulum.today('UTC').subtract(days=1),
    #schedule=None,  # Updated parameter name
    catchup=False,
    tags=['cdm', 'cdm_historical_daily_main_clean'],
) as dag:

    # Task to test the database connection, updated to use SQLExecuteQueryOperator
    test_connection = SQLExecuteQueryOperator(
        task_id='test_connection',
        conn_id='postgres_default',
        sql="SELECT 1;",
    )

    # Task to run a DBT command or any bash command
    dbt_run_models_historical_daily_main_clean = BashOperator(
        task_id='dbt_run_models_cdm_historical_daily_main_clean',
        bash_command='cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app/ && dbt run --models historical_daily_main_clean',
    ) 

    pytest_run_unit = BashOperator(
        task_id='pytest_run_cdm_historical_daily_main_clean_unit',
        bash_command="""
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init --path)"
        eval "$(pyenv virtualenv-init -)"
        pyenv shell 3.11.6
        /Users/kevin/.pyenv/shims/pytest /Users/kevin/Dropbox/applications/ELT/pytest_tests/tests/unit/cdm_historical_daily_main_clean/test_run.py || true
        """,
        dag=dag,
    )

# Task to run a DBT command or any bash command
    dbt_run_udi_model = BashOperator(
        task_id='dbt_run_models_quality_check_user_data_integrity',
        bash_command='cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app/ && dbt run --models user_data_integrity',
    )
    
    # Task to trigger cdm_pure_growth_dag
    trigger_cdm_pure_growth_dag = TriggerDagRunOperator(
        task_id='trigger_cdm_pure_growth_dag',
        trigger_dag_id="cdm_pure_growth_dag", # The ID of the DAG to trigger
        dag=dag, 
)
   
    # Set task dependencies
    test_connection >> dbt_run_models_historical_daily_main_clean >> pytest_run_unit >> dbt_run_udi_model >> trigger_cdm_pure_growth_dag
