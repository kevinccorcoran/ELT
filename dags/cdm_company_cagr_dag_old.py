# Standard library imports
from datetime import timedelta

# Related third-party imports
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
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
    dag_id="cdm_company_cagr_dag_old",
    description="DAG for creating metrics.cagr_metric",
    default_args=default_args,
    start_date=pendulum.today('UTC').subtract(days=1),
    catchup=False,
) as dag:

    # Task to test the database connection
    test_connection = SQLExecuteQueryOperator(
        task_id='test_connection',
        conn_id='postgres_default',
        sql="SELECT 1;",
    )

    dbt_run_company_cagr = BashOperator(
        task_id='dbt_run_model_cagr_metric',
        bash_command=(
            'export ENV={{ var.value.ENV }} && '
            'echo "Airflow ENV: $ENV" && '
            'cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app && '
            'dbt run --models company_cagr'
        ),
    )

    # Task to trigger metrics_next_n_cagr_ratios_dag
    trigger_cdm_ticker_count_by_date_dag = TriggerDagRunOperator(
        task_id='trigger_cdm_ticker_count_by_date_model',
        trigger_dag_id="cdm_ticker_count_by_date_dag",
    )

    # Task to trigger metrics_ticker_movement_analysis_dag
    trigger_metrics_ticker_movement_analysis_dag = TriggerDagRunOperator(
        task_id='trigger_dag_metrics_ticker_movement_analysis_table',
        trigger_dag_id="metrics_ticker_movement_analysis_dag",
    )

    # Task to trigger metrics_cagr_metrics_dag
    trigger_metrics_cagr_metrics_dag = TriggerDagRunOperator(
        task_id='trigger_dag_metrics_cagr_metrics_model',
        trigger_dag_id="metrics_cagr_metric_dag",
    )

    # Task to trigger metrics_next_n_cagr_ratios_dag
    trigger_metrics_next_n_cagr_ratios_dag = TriggerDagRunOperator(
        task_id='trigger_dag_metrics_next_n_cagr_ratios_model',
        trigger_dag_id="metric_next_n_cagr_ratios_dag",
    )

    # Set task dependencies
    (
        test_connection 
        >> dbt_run_company_cagr
        >> trigger_cdm_ticker_count_by_date_dag
        >> trigger_metrics_ticker_movement_analysis_dag 
        >> trigger_metrics_cagr_metrics_dag 
        >> trigger_metrics_next_n_cagr_ratios_dag
    )
