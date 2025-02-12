"""
Example Airflow DAG that runs a dbt model (company_cagr) using separate
Heroku config vars in the 'heroku_postgres' environment, and single DSN
for dev/staging. Triggers additional downstream DAGs after completion.
"""

from datetime import timedelta
import pendulum
import logging

from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from typing import Tuple, Dict

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


def get_db_connection_string(env: str) -> str:
    """
    Return a full connection string for dev/staging only.
    For 'heroku_postgres', we return None because we use separate
    environment variables (DB_HOST, DB_PORT, etc.) directly.
    """
    env_to_var_map = {
        "dev": "DEV_DB_CONNECTION_STRING",
        "staging": "STAGING_DB_CONNECTION_STRING",
    }

    # dev/staging => pull single DSN from a variable
    if env in env_to_var_map:
        connection_string = Variable.get(env_to_var_map[env], default_var=None)
        if not connection_string:
            raise ValueError(f"Environment variable {env_to_var_map[env]} is not set.")
        return connection_string

    # heroku_postgres => None (we won't use a single DSN)
    elif env == "heroku_postgres":
        return None

    else:
        raise ValueError(f"Invalid environment specified: {env}")


def get_dbt_bash_command(env: str, db_connection_string: str) -> Tuple[str, Dict[str, str]]:
    """
    Generate the Bash command and environment variables dynamically for running dbt.
    :param env: The environment name (e.g., 'dev', 'staging', 'heroku_postgres').
    :param db_connection_string: Single DSN if available (dev/staging) or None (heroku).
    :return: (bash_command, env_vars) tuple
    """

    if env == "heroku_postgres":
        # In Heroku environment, we do NOT rely on a single DSN.
        # We pass separate DB config vars for dbt to use in profiles.yml.
        env_vars = {
            "ENV": Variable.get("ENV", default_var="heroku_postgres"),  # fallback
            "DB_HOST": Variable.get("DB_HOST"),
            "DB_PORT": Variable.get("DB_PORT"),
            "DB_USER": Variable.get("DB_USER"),
            "DB_PASSWORD": Variable.get("DB_PASSWORD"),
            "DB_DATABASE": Variable.get("DB_DATABASE"),
        }

        # Example of a Heroku-based command:
        # Adjust paths as needed for your Heroku file structure (/.heroku/python/bin, etc.)
        bash_command = (
            "export PYTHONPATH=$PYTHONPATH:/app/python/src && "
            "export PATH=$PATH:/app/.heroku/python/bin && "
            f"export ENV={env_vars['ENV']} && "
            f"export DB_HOST={env_vars['DB_HOST']} && "
            f"export DB_PORT={env_vars['DB_PORT']} && "
            f"export DB_USER={env_vars['DB_USER']} && "
            f"export DB_PASSWORD={env_vars['DB_PASSWORD']} && "
            f"export DB_DATABASE={env_vars['DB_DATABASE']} && "
            "cd /app/dbt/src/app && "
            "/app/.heroku/python/bin/dbt debug --profiles-dir /app/.dbt --project-dir /app/dbt/src/app && "
            "/app/.heroku/python/bin/dbt run --profiles-dir /app/.dbt --project-dir /app/dbt/src/app --models company_cagr"
        )

    else:
        # Local dev or staging environment: might rely on a single DSN or local path
        env_vars = {
            "ENV": env,
            # Possibly you might pass these, or you can skip them if your local profiles.yml is static
            # If you want separate local vars as well, you can do so.
            # "DB_HOST": Variable.get("DB_HOST"),
            # "DB_PORT": Variable.get("DB_PORT"),
            # ...
        }

        # If your dev/staging environment uses the DSN, you can supply it as well:
        if db_connection_string:
            env_vars["DB_CONNECTION_STRING"] = db_connection_string

        # Example local command (adjust path to your local dbt project):
        bash_command = (
            'echo "Local Airflow ENV: $ENV" && '
            'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
            '/Users/kevin/.pyenv/shims/dbt run --models company_cagr || true'
        )

    return bash_command, env_vars


# ---------------------------------------------------------------------
# Retrieve environment from Airflow Variable
env = Variable.get("ENV", default_var="dev")  # default to "dev" if not set
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

# Create DAG
with DAG(
    dag_id="cdm_company_cagr_dag",
    description="DAG for creating metrics.cagr_metric via dbt",
    default_args=default_args,
    start_date=pendulum.today("UTC").subtract(days=1),
    catchup=False,
) as dag:

    # Generate the Bash command + environment
    bash_command, env_vars = get_dbt_bash_command(env, db_connection_string)

    # Task: Run dbt model
    dbt_run = BashOperator(
        task_id="dbt_run_model_cagr_metric",
        bash_command=bash_command,
        env=env_vars,
    )

    # Task: Trigger other DAG(s) after completion
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

    # Define the task sequence
    (
        dbt_run
        >> trigger_metrics_ticker_movement_analysis_dag
        >> trigger_metrics_cagr_metrics_dag
        >> trigger_metrics_next_n_cagr_ratios_dag
    )

# from datetime import timedelta
# import pendulum  # For handling dates
# from airflow import DAG
# from airflow.models import Variable
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator
# from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
# from typing import Tuple, Dict
# import logging

# # Configure logging
# logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# def get_db_connection_string(env: str) -> str:
#     env_to_var_map = {
#         "dev": "DEV_DB_CONNECTION_STRING",
#         "staging": "STAGING_DB_CONNECTION_STRING",
#         "heroku_postgres": "DATABASE_URL",
#     }

#     if env not in env_to_var_map:
#         raise ValueError(f"Invalid environment specified: {env}. Please set a valid ENV variable.")

#     connection_string = Variable.get(env_to_var_map[env], default_var=None)
#     if not connection_string:
#         raise ValueError(f"Environment variable {env_to_var_map[env]} is not set.")

#     return connection_string

# from typing import Tuple, Dict

# def get_dbt_bash_command(env: str, db_connection_string: str) -> Tuple[str, Dict[str, str]]:
#     """
#     Generate the Bash command and environment variables dynamically for running dbt.
#     """
#     if env == "heroku_postgres":
#         env_vars = {
#             "ENV": Variable.get("ENV", default_var="heroku_postgres"),  # Ensure ENV is set
#             "DB_HOST": Variable.get("DB_HOST"),
#             "DB_PORT": Variable.get("DB_PORT"),
#             "DB_USER": Variable.get("DB_USER"),
#             "DB_PASSWORD": Variable.get("DB_PASSWORD"),
#             "DB_DATABASE": Variable.get("DB_DATABASE"),  # Ensure correct database name
#         }

#         bash_command = (
#             "export PYTHONPATH=$PYTHONPATH:/app/python/src && "
#             "export PATH=$PATH:/app/.heroku/python/bin && "
#             f"export ENV={env_vars['ENV']} && "  # Ensure ENV is explicitly exported
#             f"export DB_HOST={env_vars['DB_HOST']} && "
#             f"export DB_PORT={env_vars['DB_PORT']} && "
#             f"export DB_USER={env_vars['DB_USER']} && "
#             f"export DB_PASSWORD={env_vars['DB_PASSWORD']} && "
#             f"export DB_DATABASE={env_vars['DB_DATABASE']} && "  # Explicitly set DB_DATABASE
#             "cd /app/dbt/src/app && "
#             "/app/.heroku/python/bin/dbt debug --profiles-dir /app/.dbt --project-dir /app/dbt/src/app && "
#             "/app/.heroku/python/bin/dbt run --profiles-dir /app/.dbt --project-dir /app/dbt/src/app --models company_cagr"
#         )

#     else:
#         bash_command = (
#             'echo "Airflow ENV: $ENV" && '
#             'echo "ENV: $ENV" && '
#             'echo "DB_PORT: $DB_PORT" && '
#             'echo "DB_NAME: $DB_NAME" && '
#             'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
#             '/Users/kevin/.pyenv/shims/dbt run --models company_cagr || true'
#         )
#         # Set in local Airflow
#         env_vars = {
#             "ENV": Variable.get("ENV"),
#             "DB_HOST": Variable.get("DB_HOST"),
#             "DB_PORT": Variable.get("DB_PORT"),
#             "DB_USER": Variable.get("DB_USER"),
#             "DB_PASSWORD": Variable.get("DB_PASSWORD")
#         }

#     return bash_command, env_vars

# # def get_dbt_bash_command(env: str, db_connection_string: str) -> Tuple[str, Dict[str, str]]:
# #     """
# #     Generate the Bash command and environment variables dynamically for running dbt.
# #     """
# #     if env == "heroku_postgres":
# #         bash_command = (
# #             f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
# #             f'cd /app/dbt && '  # Adjusted path for Heroku
# #             f'(dbt run --models company_cagr ; exit 0) '
# #             f'> /tmp/dbt_cagr_output.log 2>&1'
# #         )
# #         env_vars = {
# #             "DATABASE_URL": db_connection_string,  # Heroku provides this dynamically
# #         }
# #     else:
# #         bash_command = (
# #             'export ENV={{ var.value.ENV }} && '
# #             'export DB_HOST={{ var.value.DB_HOST }} && '
# #             'export DB_PORT={{ var.value.DB_PORT }} && '
# #             'export DB_USER={{ var.value.DB_USER }} && '
# #             'export DB_PASSWORD={{ var.value.DB_PASSWORD }} && '
# #             'echo "Airflow ENV: $ENV" && '
# #             'echo "DB_PORT: $DB_PORT" && '
# #             'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
# #             '( /Users/kevin/.pyenv/shims/dbt run --models company_cagr || true) '
# #         )

# #     env_vars = {
# #         'DATABASE_URL': db_connection_string,
# #         'ENV': env,
# #     }

# #     return bash_command, env_vars

# # Retrieve environment variables
# env = Variable.get("ENV", default_var="dev")
# db_connection_string = get_db_connection_string(env)

# # Define default arguments
# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'email_on_failure': False,
#     'email_on_retry': False,
#     'retries': 1,
#     'retry_delay': timedelta(minutes=5),
# }

# with DAG(
#     dag_id="cdm_company_cagr_dag",
#     description="DAG for creating metrics.cagr_metric",
#     default_args=default_args,
#     start_date=pendulum.today('UTC').subtract(days=1),
#     catchup=False,
# ) as dag:

#     # Generate Bash command and environment variables
#     bash_command, env_vars = get_dbt_bash_command(env, db_connection_string)

#     # Run dbt model
#     dbt_run = BashOperator(
#         task_id='dbt_run_model_cagr_metric',
#         bash_command=bash_command,
#         env=env_vars,
#     )

#     # Task to trigger downstream DAGs
#     trigger_metrics_ticker_movement_analysis_dag = TriggerDagRunOperator(
#         task_id='trigger_dag_metrics_ticker_movement_analysis_table',
#         trigger_dag_id="metrics_ticker_movement_analysis_dag",
#     )

#     trigger_metrics_cagr_metrics_dag = TriggerDagRunOperator(
#         task_id='trigger_dag_metrics_cagr_metrics_model',
#         trigger_dag_id="metrics_cagr_metric_dag",
#     )

#     trigger_metrics_next_n_cagr_ratios_dag = TriggerDagRunOperator(
#         task_id='trigger_dag_metrics_next_n_cagr_ratios_model',
#         trigger_dag_id="metric_next_n_cagr_ratios_dag",
#     )

#     # Define task dependencies
#     (
#         dbt_run
#         >> trigger_metrics_ticker_movement_analysis_dag
#         >> trigger_metrics_cagr_metrics_dag
#         >> trigger_metrics_next_n_cagr_ratios_dag
#     )