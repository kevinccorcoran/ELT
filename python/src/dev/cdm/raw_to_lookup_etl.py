import os
import sys
from pyspark.sql import SparkSession
from pyspark.sql.functions import min as spark_min, col, row_number, expr, explode, broadcast
from pyspark.sql.window import Window
from dev.config.fibonacci import cumulative_fibonacci
from dev.config.helpers import save_to_database
from airflow.models import Variable

# Set environment and database connection paths
os.environ["JAVA_HOME"] = "/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home"
sys.path.append('/Users/kevin/Dropbox/applications/ELT/python/src')

# Retrieve environment-specific JDBC connection string
env = Variable.get("ENV", default_var="staging")
if env == "dev":
    db_connection_string = Variable.get("JDBC_DEV_DB_CONNECTION_STRING")
elif env == "staging":
    db_connection_string = Variable.get("JDBC_STAGING_DB_CONNECTION_STRING")
else:
    raise ValueError("Invalid environment specified")

# Database credentials
db_user = Variable.get("DB_USER")
db_password = Variable.get("DB_PASSWORD")
postgres_jar_path = "/Users/kevin/Dropbox/applications/ELT/jars/postgresql-42.7.4.jar"

# Initialize Spark session
spark = SparkSession.builder \
    .appName("StockDataProcessing") \
    .config("spark.jars", postgres_jar_path) \
    .config("spark.driver.memory", "8g") \
    .config("spark.executor.memory", "8g") \
    .config("spark.sql.shuffle.partitions", "200") \
    .getOrCreate()

try:
    # Load data from PostgreSQL
    df = spark.read \
        .format("jdbc") \
        .option("url", db_connection_string) \
        .option("dbtable", "raw.api_raw_data_ingestion") \
        .option("user", db_user) \
        .option("password", db_password) \
        .option("driver", "org.postgresql.Driver") \
        .load()

    # Load existing records to avoid duplicates
    existing_df = spark.read \
        .format("jdbc") \
        .option("url", db_connection_string) \
        .option("dbtable", "cdm.date_lookup") \
        .option("user", db_user) \
        .option("password", db_password) \
        .option("driver", "org.postgresql.Driver") \
        .load() \
        .select("ticker", "date")

    # Step 1: Get minimum date per ticker
    min_dates_df = df.groupBy("ticker").agg(spark_min("date").alias("min_date"))

    # Step 2: Create a date sequence from min_date with a range of years
    years_to_add = 100  # Adjust as needed
    date_sequences = min_dates_df.withColumn(
        "date_sequence",
        expr(f"sequence(min_date, min_date + interval {years_to_add} year, interval 1 year)")
    )

    # Step 3: Explode date_sequence to create rows for each date
    date_df = date_sequences.select("ticker", explode("date_sequence").alias("date"))

    # Step 4: Assign row numbers within each ticker group
    window_spec = Window.partitionBy("ticker").orderBy("date")
    date_df = date_df.withColumn("row_number", row_number().over(window_spec))

    # Step 5: Generate Fibonacci sequence and filter rows
    row_count = date_df.count()
    fib_sequence = cumulative_fibonacci(row_count)
    fib_df = spark.createDataFrame([(num,) for num in fib_sequence], ["row_number"])

    # Filter date_df to keep only rows with row_number in Fibonacci sequence
    result_df = date_df.join(fib_df, "row_number", "inner")

    # Step 6: Remove records that already exist in the target table
    new_records_df = result_df.join(broadcast(existing_df), on=["ticker", "date"], how="left_anti")

    # Step 7: Write new records to PostgreSQL with batch optimization
    new_records_df.write \
        .format("jdbc") \
        .option("url", db_connection_string) \
        .option("dbtable", "cdm.date_lookup") \
        .option("user", db_user) \
        .option("password", db_password) \
        .option("driver", "org.postgresql.Driver") \
        .option("numPartitions", "10") \
        .option("batchsize", "50000") \
        .mode("append") \
        .save()

    print("New records successfully saved to the database.")

except Exception as e:
    print("Unexpected error occurred:", e)

finally:
    spark.stop()