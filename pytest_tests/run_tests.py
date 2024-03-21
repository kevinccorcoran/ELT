# # run_tests.py

# from pytest_tests.unit import test_run_sql, test_run_sql_2

# def run_all_tests():
#     try:
#         test_run_sql()
#         test_run_sql_2()
#         print("All tests passed.")
#     except AssertionError as e:
#         print(f"Test failed: {e}")

# run_tests.py

# It's unclear from your snippet how you're structuring the imports,
# assuming `test_run_sql` and `test_run_sql_2` are modules containing the function `test_ticker_count`.
from pytest_tests.unit.test_run_sql import test_ticker_count as test_ticker_count_1
from pytest_tests.unit.test_run_sql_2 import test_ticker_count as test_ticker_count_2

def run_all_tests():
    try:
        # Call the test functions directly
        test_ticker_count_1()
        test_ticker_count_2()
        print("All tests passed.")
    except AssertionError as e:
        print(f"Test failed: {e}")

if __name__ == "__main__":
    run_all_tests()

