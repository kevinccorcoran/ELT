from pytest_tests.unit_tests.test_cdm_historical_daily_main_clean_nulls import test_ticker_count as test_ticker_count_1
from pytest_tests.unit_tests.test_run_sql_2 import test_ticker_count as test_ticker_count_2

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


