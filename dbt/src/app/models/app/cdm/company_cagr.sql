{% do log("Current ENV: " ~ env_var('ENV'), info=true) %}

{{
    config(
        materialized='table',
        database=env_var('ENV'),
        schema='cdm'
    )
}}

WITH history_data AS (
    -- Fetch historical data: ticker, date, and closing price
    SELECT
        ticker,
        date,
        close
    FROM
        {{ source('cdm', 'api_cdm_data_ingestion') }}
),

filtered_fibonacci_dates AS (
    -- Select relevant Fibonacci dates: ticker, date, and row number less than 34
    SELECT
        ticker,
        date,
        row_number
    FROM
        {{ source('cdm', 'date_lookup') }}
    WHERE
        row_number < 34
),

joined_data AS (
    -- Join historical data with filtered Fibonacci dates on ticker and date
    SELECT
        hdf.ticker,
        hdf.close,
        ftd.row_number AS n
    FROM
        history_data hdf
    JOIN
        filtered_fibonacci_dates ftd
    ON
        hdf.ticker = ftd.ticker
        AND hdf.date = ftd.date
),

data_with_previous_close AS (
    -- Add the previous close value for each ticker, based on the order of n
    SELECT
        *,
        LAG(close) OVER (PARTITION BY ticker ORDER BY n) AS previous_close
    FROM
        joined_data
),

interval_based_cagr_data AS (
    -- Calculate the Compound Annual Growth Rate (CAGR) for each ticker using the previous close value
    SELECT
        ticker,
        n,
        CASE
            WHEN n = 0 THEN 0  -- Set CAGR to 0 when n is 0
            WHEN previous_close <= 0 OR close <= 0 THEN NULL  -- Exclude negative or zero values
            ELSE ROUND(CAST(((close / previous_close) ^ (1.0 / 1) - 1) * 100 AS NUMERIC), 2)
        END AS cagr,
        'Interval-Based CAGR' AS type
    FROM
        data_with_previous_close
),

data_with_base_close AS (
    -- Add the base close value for each ticker, based on the smallest row number (n = 0)
    SELECT
        *,
        FIRST_VALUE(close) OVER (PARTITION BY ticker ORDER BY n) AS base_close
    FROM
        joined_data
),

from_0_cagr_data AS (
    -- Calculate the Compound Annual Growth Rate (CAGR) for each ticker from base close
    SELECT
        ticker,
        n,
        CASE
            WHEN n = 0 THEN 0  -- Set CAGR to 0 when n is 0
            WHEN base_close <= 0 OR close <= 0 THEN NULL  -- Exclude negative or zero values
            ELSE ROUND(CAST(((close / base_close) ^ (1.0 / n) - 1) * 100 AS NUMERIC), 2)
        END AS cagr,
        'CAGR from Zero' AS type
    FROM
        data_with_base_close
),

union_all AS (
    -- Combine interval-based CAGR and CAGR from zero
    SELECT * FROM interval_based_cagr_data
    UNION ALL
    SELECT * FROM from_0_cagr_data
),

ranked_cagr_data AS (
    -- Use NTILE to divide CAGR values into 10 groups for ranking
    SELECT
        ticker,
        n,
        cagr,
        NTILE(10) OVER (PARTITION BY n, type ORDER BY cagr DESC) AS cagr_group,
        type
    FROM
        union_all
),

select_distinct AS (
    -- Select distinct results and filter out null CAGRs
    SELECT DISTINCT
        ticker,
        n,
        cagr,
        cagr_group,
        type
    FROM
        ranked_cagr_data
    WHERE
        cagr IS NOT NULL
        AND n <> 0
)

-- Final selection from the distinct, ranked data
SELECT
    *
FROM
    select_distinct
