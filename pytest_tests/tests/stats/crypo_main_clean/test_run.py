
import sys
sys.path.append('/Users/kevin/Dropbox/applications/ELT')

import pytest 
from pytest_tests.tests.stats.crypo_main_clean.stats_test_01 import test_ticker_count as test_ticker_count_1
from pytest_tests.send_telegram_message import send_telegram_message



def run_all_tests():
    try:
        # Call the test functions directly
        test_ticker_count_1()
        print("All tests passed.")
    except AssertionError as e:
        print(f"Test failed: {e}")

if __name__ == "__main__":
    run_all_tests()

    