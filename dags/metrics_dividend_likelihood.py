from datetime import timedelta
from typing import Tuple, Dict
import logging
import pendulum

from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator

# ─────────────────────────────────────────────────────────────────────────────
# Configure logging
# ─────────────────────────────────────────────────────────────────────────────
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")


# ─────────────────────────────────────────────────────────────────────────────
# Helper function to generate Bash command and env vars
# ─────────────────────────────────────────────────────────────────────────────
def get_dbt_bash_command(env: str) -> Tuple[str, Dict[str, str]]:
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
            'echo "DB_USER: $DB_USER" && '
            'echo "DB_HOST: $DB_HOST" && '
            'echo "DB_PORT: $DB_PORT" && '
            'echo "DB_DATABASE: $DB_DATABASE" && '
            'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
            'export PATH=$PATH:/app/.heroku/python/bin && '
            'export DATABASE_URL=$DATABASE_URL && '
            f'export DB_DATABASE={Variable.get("DB_DATABASE", default_var="da909ge4nntude")} && '
            'cd /app/dbt/src/app && '
            '/app/.heroku/python/bin/dbt debug --profiles-dir /app/.dbt --project-dir /app/dbt/src/app && '
            '/app/.heroku/python/bin/dbt run --profiles-dir /app/.dbt --project-dir /app/dbt/src/app --models dividend_likelihood'
        )

    else:  # Local execution
        env_vars = {
            "ENV": Variable.get("ENV"),
            "DB_HOST": Variable.get("DB_HOST"),
            "DB_PORT": Variable.get("DB_PORT"),
            "DB_USER": Variable.get("DB_USER"),
            "DB_PASSWORD": Variable.get("DB_PASSWORD"),
            "DB_DATABASE": Variable.get("DB_DATABASE"),
        }

        bash_command = (
            'echo "Airflow ENV: $ENV" && '
            'echo "DB_USER: $DB_USER" && '
            'echo "DB_HOST: $DB_HOST" && '
            'echo "DB_PORT: $DB_PORT" && '
            'echo "DB_DATABASE: $DB_DATABASE" && '
            'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
            '/Users/kevin/.pyenv/shims/dbt run --models dividend_likelihood || true'
        )

    return bash_command, env_vars


# ─────────────────────────────────────────────────────────────────────────────
# DAG setup
# ─────────────────────────────────────────────────────────────────────────────
env = Variable.get("ENV", default_var="dev")

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="metrics_dividend_likelihood",
    description="DAG for creating metrics.dividend_likelihood",
    default_args=default_args,
    start_date=pendulum.today("UTC").subtract(days=1),
    catchup=False,
    schedule_interval=None,
    tags=["metrics", "dbt"],
) as dag:

    bash_command, env_vars = get_dbt_bash_command(env)

    dbt_run = BashOperator(
        task_id="dbt_run_model_dividend_likelihood",
        bash_command=bash_command,
        env=env_vars,
    )

    dbt_run
