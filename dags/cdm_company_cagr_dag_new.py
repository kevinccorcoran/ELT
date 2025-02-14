from datetime import timedelta
import pendulum  # For handling dates
from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from typing import Tuple, Dict
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_db_connection_string(env: str) -> str:
    env_to_var_map = {
        "dev": "DEV_DB_CONNECTION_STRING",
        "staging": "STAGING_DB_CONNECTION_STRING",
        "heroku_postgres": "DATABASE_URL",
    }

    if env not in env_to_var_map:
        raise ValueError(f"Invalid environment specified: {env}. Please set a valid ENV variable.")

    connection_string = Variable.get(env_to_var_map[env], default_var=None)
    if not connection_string:
        raise ValueError(f"Environment variable {env_to_var_map[env]} is not set.")

    return connection_string

from typing import Tuple, Dict

def get_dbt_bash_command(env: str, db_connection_string: str) -> Tuple[str, Dict[str, str]]:
    """
    Generate the Bash command and environment variables dynamically for running dbt.
    """
    if env == "heroku_postgres":
        env_vars = {
            "ENV": Variable.get("ENV"),
            "DB_HOST": Variable.get("DB_HOST"),
            "DB_PORT": Variable.get("DB_PORT"),
            "DB_USER": Variable.get("DB_USER"),
            "DB_PASSWORD": Variable.get("DB_PASSWORD")
        }

        bash_command = (
            'echo "Airflow ENV: $ENV" && '
            "export PYTHONPATH=$PYTHONPATH:/app/python/src && "
            "export PATH=$PATH:/app/.heroku/python/bin && "
            "export DATABASE_URL=$DATABASE_URL && "  # Ensure DATABASE_URL is explicitly exported
            "cd /app/dbt/src/app && "
            "/app/.heroku/python/bin/dbt debug --profiles-dir /app/.dbt --project-dir /app/dbt/src/app && "
            "/app/.heroku/python/bin/dbt run --profiles-dir /app/.dbt --project-dir /app/dbt/src/app --models company_cagr"
        )

    else:
        bash_command = (
            'echo "Airflow ENV: $ENV" && '
            'echo "ENV: $ENV" && '
            'echo "DB_PORT: $DB_PORT" && '
            'echo "DB_NAME: $DB_NAME" && '
            'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
            '/Users/kevin/.pyenv/shims/dbt run --models company_cagr || true'
        )
        # Set in local Airflow
        env_vars = {
            "ENV": Variable.get("ENV"),
            "DB_HOST": Variable.get("DB_HOST"),
            "DB_PORT": Variable.get("DB_PORT"),
            "DB_USER": Variable.get("DB_USER"),
            "DB_PASSWORD": Variable.get("DB_PASSWORD")
        }

    return bash_command, env_vars


# def get_dbt_bash_command(env: str, db_connection_string: str) -> Tuple[str, Dict[str, str]]:
#     """
#     Generate the Bash command and environment variables dynamically for running dbt.
#     """
#     if env == "heroku_postgres":
#         env_vars = {
#             "ENV": Variable.get("ENV", default_var="heroku_postgres"),  # Ensure ENV is set
#             # "DB_HOST": Variable.get("DB_HOST"),
#             # "DB_PORT": Variable.get("DB_PORT"),
#             # "DB_USER": Variable.get("DB_USER"),
#             # "DB_PASSWORD": Variable.get("DB_PASSWORD"),
#             # "DB_DATABASE": Variable.get("DB_DATABASE"),  # Ensure correct database name
#         }

#         bash_command = (
#             'echo "Airflow ENV: $ENV" && '
#             "export PYTHONPATH=$PYTHONPATH:/app/python/src && "
#             "export PATH=$PATH:/app/.heroku/python/bin && "
#             #f"export ENV={env_vars['ENV']} && "  # Ensure ENV is explicitly exported
#             # f"export DB_HOST={env_vars['DB_HOST']} && "
#             # f"export DB_PORT={env_vars['DB_PORT']} && "
#             # f"export DB_USER={env_vars['DB_USER']} && "
#             # f"export DB_PASSWORD={env_vars['DB_PASSWORD']} && "
#             # f"export DB_DATABASE={env_vars['DB_DATABASE']} && "  # Explicitly set DB_DATABASE
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

# Retrieve environment variables
env = Variable.get("ENV", default_var="dev")
db_connection_string = get_db_connection_string(env)

# Define default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id="cdm_company_cagr_dag_new",
    description="DAG for creating metrics.cagr_metric",
    default_args=default_args,
    start_date=pendulum.today('UTC').subtract(days=1),
    catchup=False,
) as dag:

    # Generate Bash command and environment variables
    bash_command, env_vars = get_dbt_bash_command(env, db_connection_string)

    # Run dbt model
    dbt_run = BashOperator(
        task_id='dbt_run_model_cagr_metric',
        bash_command=bash_command,
        env=env_vars,
    )

    # Task to trigger downstream DAGs
    trigger_metrics_ticker_movement_analysis_dag = TriggerDagRunOperator(
        task_id='trigger_dag_metrics_ticker_movement_analysis_table',
        trigger_dag_id="metrics_ticker_movement_analysis_dag",
    )

    trigger_metrics_cagr_metrics_dag = TriggerDagRunOperator(
        task_id='trigger_dag_metrics_cagr_metrics_model',
        trigger_dag_id="metrics_cagr_metric_dag",
    )

    trigger_metrics_next_n_cagr_ratios_dag = TriggerDagRunOperator(
        task_id='trigger_dag_metrics_next_n_cagr_ratios_model',
        trigger_dag_id="metric_next_n_cagr_ratios_dag",
    )

    # Define task dependencies
    (
        dbt_run
        >> trigger_metrics_ticker_movement_analysis_dag
        >> trigger_metrics_cagr_metrics_dag
        >> trigger_metrics_next_n_cagr_ratios_dag
    )

# # Standard library imports
# from datetime import timedelta
# import pendulum  # For handling dates

# # Airflow-specific imports
# from airflow import DAG
# from airflow.models import Variable
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator
# from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

# from typing import Tuple, Dict

# # Configure logging
# import logging
# logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


# def get_db_connection_string(env: str) -> str:
#     """
#     Retrieve the database connection string based on the environment.
#     """
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


# # def get_dbt_bash_command(env: str) -> str:
# #     """
# #     Generate the Bash command dynamically for running the dbt model.
# #     """
# #     return (
# #         'export ENV={{ var.value.ENV }} && '
# #         'echo "Airflow ENV: $ENV" && '
# #         'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
# #         '/Users/kevin/.pyenv/shims/dbt run --models company_cagr'
# #     )
# # def get_dbt_bash_command(env: str) -> str:
# #     return (
# #         'export ENV={{ var.value.ENV }} && '
# #         'echo "Airflow ENV: $ENV" && '
# #         'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
# #         # Run dbt and force exit 0 even if dbt returns 1
# #         '( /Users/kevin/.pyenv/shims/dbt run --models company_cagr ; exit 0 ) '
# #         '> /tmp/dbt_cagr_output.log 2>&1'
# #     )

# def get_dbt_bash_command(env: str, db_connection_string: str) -> Tuple[str, Dict[str, str]]:
#     """
#     Generate the Bash command and environment variables dynamically for running dbt.
#     """
#     if env == "heroku_postgres":
#         bash_command = (
#             f'export PYTHONPATH=$PYTHONPATH:/app/python/src && '
#             f'cd /app/dbt && '  # Adjusted path for Heroku
#             f'(dbt run --models company_cagr ; exit 0) '
#             f'> /tmp/dbt_cagr_output.log 2>&1'
#         )
#     else:
#         bash_command = (
#             'export ENV={{ var.value.ENV }} && '
#             'echo "Airflow ENV: $ENV" && '
#             'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
#             '( /Users/kevin/.pyenv/shims/dbt run --models company_cagr ; exit 0 ) '
#             '> /tmp/dbt_cagr_output.log 2>&1'
#         )
    
#     env_vars = {
#         'DATABASE_URL': db_connection_string,
#         'ENV': env,
#     }

#     return bash_command, env_vars


# # Retrieve environment-specific variables
# env = Variable.get("ENV", default_var="dev")  # Default to "dev" if ENV is not set
# db_connection_string = get_db_connection_string(env)

# # Define the default arguments for the DAG
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

#     # # Task to test the database connection
#     # test_connection = SQLExecuteQueryOperator(
#     #     task_id='test_connection',
#     #     conn_id='postgres_default',
#     #     sql="SELECT 1;",
#     # )

#     # # Task to run dbt for company_cagr
#     # dbt_run = BashOperator(
#     #     task_id='dbt_run_model_cagr_metric',
#     #     bash_command=get_dbt_bash_command(env),
#     #     env={'DATABASE_URL': db_connection_string, 'ENV': env},
#     # )

#     dbt_run = BashOperator(
#     task_id='dbt_run_model_cagr_metric',
#     bash_command=get_dbt_bash_command(env) + " > /dev/null 2>&1",
#     env={'DATABASE_URL': db_connection_string, 'ENV': env},
# )


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


# # Standard library imports
# from datetime import timedelta

# # Related third-party imports
# from airflow import DAG
# from airflow.operators.bash import BashOperator
# from airflow.operators.trigger_dagrun import TriggerDagRunOperator
# from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
# from airflow.sensors.external_task import ExternalTaskSensor
# import pendulum  # For handling dates

# # Define the default arguments for the DAG
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

#     # Task to test the database connection
#     test_connection = SQLExecuteQueryOperator(
#         task_id='test_connection',
#         conn_id='postgres_default',
#         sql="SELECT 1;",
#     )

#     dbt_run = BashOperator(
#         task_id='dbt_run_model_cagr_metric',
#         bash_command=(
#             'export ENV={{ var.value.ENV }} && '
#             'echo "Airflow ENV: $ENV" && '
#             'cd /Users/kevin/repos/ELT_private/dbt/src/app && '
#             'dbt run --models company_cagr'
#         ),
#     )

#     # Task to trigger metrics_ticker_movement_analysis_dag
#     trigger_metrics_ticker_movement_analysis_dag = TriggerDagRunOperator(
#         task_id='trigger_dag_metrics_ticker_movement_analysis_table',
#         trigger_dag_id="metrics_ticker_movement_analysis_dag",
#     )

#     # Task to trigger metrics_cagr_metrics_dag
#     trigger_metrics_cagr_metrics_dag = TriggerDagRunOperator(
#         task_id='trigger_dag_metrics_cagr_metrics_model',
#         trigger_dag_id="metrics_cagr_metric_dag",
#     )

#     # Task to trigger metrics_next_n_cagr_ratios_dag
#     trigger_metrics_next_n_cagr_ratios_dag = TriggerDagRunOperator(
#         task_id='trigger_dag_metrics_next_n_cagr_ratios_model',
#         trigger_dag_id="metric_next_n_cagr_ratios_dag",
#     )

#     # Set task dependencies
#     (
#         test_connection 
#         >> dbt_run 
#         >> trigger_metrics_ticker_movement_analysis_dag 
#         >> trigger_metrics_cagr_metrics_dag 
#         >> trigger_metrics_next_n_cagr_ratios_dag
#     )