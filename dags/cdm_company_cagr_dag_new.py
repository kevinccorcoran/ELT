from datetime import timedelta
import pendulum  # For handling dates
import os
from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from typing import Tuple, Dict
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def get_db_connection_string(env: str) -> str:
    """
    Retrieve the database connection string based on the environment.
    """
    env_to_var_map = {
        "dev": "DEV_DB_CONNECTION_STRING",
        "staging": "STAGING_DB_CONNECTION_STRING",
        "heroku_postgres": "DATABASE_URL",
    }

    if env not in env_to_var_map:
        raise ValueError(f"Invalid environment specified: {env}. Please set a valid ENV variable.")

    if env == "heroku_postgres":
        connection_string = os.getenv("DATABASE_URL")  # Retrieve directly from Heroku Config Vars
    else:
        connection_string = Variable.get(env_to_var_map[env], default_var=None)

    if not connection_string:
        raise ValueError(f"Environment variable {env_to_var_map[env]} is not set.")

    return connection_string

def get_dbt_bash_command(env: str, db_connection_string: str) -> Tuple[str, Dict[str, str]]:
    """
    Generate the Bash command and environment variables dynamically for running dbt.
    """
    env_vars = {
        "DATABASE_URL": os.getenv("DATABASE_URL"),  # Use Heroku's DATABASE_URL
        "ENV": env,  # Ensure ENV is explicitly exported
    }

    bash_command = (
        "export PYTHONPATH=$PYTHONPATH:/app/python/src && "
        "export PATH=$PATH:/app/.heroku/python/bin && "
        f"export ENV={env} && "  # Explicitly set ENV
        "cd /app/dbt/src/app && "
        "/app/.heroku/python/bin/dbt debug --profiles-dir /app/.dbt --project-dir /app/dbt/src/app && "
        "/app/.heroku/python/bin/dbt run --profiles-dir /app/.dbt --project-dir /app/dbt/src/app --models company_cagr"
    )

    return bash_command, env_vars

# Retrieve environment-specific variables
env = Variable.get("ENV", default_var="dev")
db_connection_string = get_db_connection_string(env)

# Define default arguments
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="cdm_company_cagr_dag_new",
    description="DAG for creating metrics.cagr_metric",
    default_args=default_args,
    start_date=pendulum.today("UTC").subtract(days=1),
    catchup=False,
) as dag:

    # Generate Bash command and environment variables
    bash_command, env_vars = get_dbt_bash_command(env, db_connection_string)

    # Run dbt model
    dbt_run = BashOperator(
        task_id="dbt_run_model_cagr_metric",
        bash_command=bash_command,
        env=env_vars,
    )

    # Task to trigger downstream DAGs
    trigger_metrics_ticker_movement_analysis_dag = TriggerDagRunOperator(
        task_id="trigger_dag_metrics_ticker_movement_analysis_table",
        trigger_dag_id="metrics_ticker_movement_analysis_dag",
    )

    trigger_metrics_cagr_metrics_dag = TriggerDagRunOperator(
        task_id="trigger_dag_metrics_cagr_metrics_model",
        trigger_dag_id="metrics_cagr_metric_dag",
    )

    trigger_metrics_next_n_cagr_ratios_dag = TriggerDagRunOperator(
        task_id="trigger_dag_metrics_next_n_cagr_ratios_model",
        trigger_dag_id="metric_next_n_cagr_ratios_dag",
    )

    # Define task dependencies
    (
        dbt_run
        >> trigger_metrics_ticker_movement_analysis_dag
        >> trigger_metrics_cagr_metrics_dag
        >> trigger_metrics_next_n_cagr_ratios_dag
    )
