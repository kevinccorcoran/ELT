
def test_failing_example():
    assert 1 + 1 == 2  # This test will fail
   

# # test_example.py
# def test_addition():
#     assert 1 + 1 == 2


#import psycopg2
# import pytest

# # Database connection parameters
# db_params = {
#     "dbname": "DEV",
#     "user": "postgres",
#     "password": "9356",
#     "host": "localhost",
#     "port": "5433"
# }

# # A simple function to execute SQL and return the results
# def execute_sql(query, params=db_params):
#     conn = psycopg2.connect(**params)
#     cur = conn.cursor()
#     cur.execute(query)
#     result = None
#     try:
#         result = cur.fetchall()
#     except psycopg2.ProgrammingError:  # In case the query does not return results
#         pass
#     conn.commit()
#     cur.close()
#     conn.close()
#     return result

# # Example test case
# def test_sample_sql_query():
#     query = "SELECT COUNT(*) FROM cdm_pure_growth;"
#     expected_count = 10  # Assuming you expect 10 rows in 'your_table'
#     result = execute_sql(query)
#     assert result[0][0] == expected_count, f"Expected {expected_count}, got {result[0][0]}"

# # You can define more test functions here
