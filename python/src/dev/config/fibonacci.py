from itertools import accumulate

def fibonacci(n):
    """
    Generate a list of the first `n` Fibonacci numbers.

    :param n: The number of Fibonacci numbers to generate.
    :return: A list containing the first `n` Fibonacci numbers.
    """
    a, b = 0, 1
    sequence = []
    for _ in range(n):
        sequence.append(a)
        a, b = b, a + b
    return sequence

def cumulative_fibonacci(n):
    """
    Generate the cumulative sum of the first `n` Fibonacci numbers.
    
    :param n: The number of Fibonacci numbers to generate and accumulate.
    :return: A list containing the cumulative Fibonacci series.
    """
    fib_sequence = fibonacci(n)
    cumulative_fib_sequence = list(accumulate(fib_sequence))
    return cumulative_fib_sequence

if __name__ == "__main__":
    n = 10
    cumulative_fib_sequence = cumulative_fibonacci(n)
    print(f"The cumulative Fibonacci series is: {cumulative_fib_sequence}")
