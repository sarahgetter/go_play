from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2021, 1, 1),
    'retries': 1,
}

def my_task():
    # Your task logic here
    print("Running my task")

dag = DAG('example_dag', default_args=default_args, schedule_interval='@daily')

t1 = PythonOperator(
    task_id='my_task',
    python_callable=my_task,
    dag=dag,
)
