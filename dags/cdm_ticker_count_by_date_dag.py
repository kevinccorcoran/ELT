from datetime import timedelta
import pendulum  # For handling dates
from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from typing import Tuple, Dict
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def get_dbt_bash_command(env: str) -> Tuple[str, Dict[str, str]]:
    """
    Generate the Bash command and environment variables dynamically for running dbt.
    """
    if env == "heroku_postgres":
        env_vars = {
            "ENV": Variable.get("DB_DATABASE"),
            "DB_HOST": Variable.get("DB_HOST"),
            "DB_PORT": Variable.get("DB_PORT"),
            "DB_USER": Variable.get("DB_USER"),
            "DB_PASSWORD": Variable.get("DB_PASSWORD"),
            "DB_DATABASE": Variable.get("DB_DATABASE", default_var="default_database_name"),
        }

        bash_command = (
            'echo "Airflow ENV: $ENV" && '
            'echo "DB_HOST: $DB_HOST" && '
            'echo "DB_PORT: $DB_PORT" && '
            'echo "DB_USER: $DB_USER" && '
            'echo "DB_DATABASE: $DB_DATABASE" && '
            "export PYTHONPATH=$PYTHONPATH:/app/python/src && "
            "export PATH=$PATH:/app/.heroku/python/bin && "
            "export DATABASE_URL=$DATABASE_URL && "
            f'export DB_DATABASE={Variable.get("DB_DATABASE", default_var="da909ge4nntude")} && '
            "cd /app/dbt/src/app && "
            "/app/.heroku/python/bin/dbt debug --profiles-dir /app/.dbt --project-dir /app/dbt/src/app && "
            "/app/.heroku/python/bin/dbt run --profiles-dir /app/.dbt --project-dir /app/dbt/src/app --models ticker_counts_by_date"
        )

    else:  # Local execution
        env_vars = {
            "ENV": Variable.get("ENV"),
            "DB_HOST": Variable.get("DB_HOST"),
            "DB_PORT": Variable.get("DB_PORT"),
            "DB_USER": Variable.get("DB_USER"),
            "DB_PASSWORD": Variable.get("DB_PASSWORD"),
        }

        bash_command = (
            'echo "Airflow ENV: $ENV" && '
            'echo "ENV: $ENV" && '
            'echo "DB_PORT: $DB_PORT" && '
            'echo "DB_NAME: $DB_DATABASE" && '
            'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
            '/Users/kevin/.pyenv/shims/dbt run --models ticker_counts_by_date || true'
        )

    return bash_command, env_vars


# Retrieve environment variables
env = Variable.get("ENV", default_var="dev")

# Define default arguments for the DAG
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="cdm_ticker_count_by_date_dag",
    description="DAG for creating metrics.ticker_counts_by_date",
    default_args=default_args,
    start_date=pendulum.today("UTC").subtract(days=1),
    catchup=False,
) as dag:

    # Generate Bash command and environment variables
    bash_command, env_vars = get_dbt_bash_command(env)

    # Run dbt model
    dbt_run = BashOperator(
        task_id="dbt_run_model_ticker_counts_by_date",
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
