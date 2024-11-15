
import sys
sys.path.append('/Users/kevin/Dropbox/applications/ELT')

import pytest 
from pytest_tests.tests.unit.crypto_main_clean.crypto_main_clean_nulls import test_ticker_count
from pytest_tests.send_telegram_message import send_telegram_message



def run_all_tests():
    try:
        # Call the test functions directly
        test_ticker_count()
        print("All tests passed.")
    except AssertionError as e:
        print(f"Test failed: {e}")

if __name__ == "__main__":
    run_all_tests()
