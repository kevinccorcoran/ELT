{{ 
config(
    materialized='table',
    unique_key='ticker'
)
}}

-- Initial setup: Select and clean data from the "historical_daily_main" table.
WITH base AS (
    SELECT *
    FROM
        {{ ref('historical_daily_main_clean') }}
    ORDER BY open
),

-- Create a subset for baseline ticker data.
index_base AS (
    SELECT *
    FROM base
    WHERE ticker IN ('GSPC')
),

-- Select the earliest date record for each ticker excluding the baseline.
min_ticker_date AS (
    SELECT *
    FROM (
        SELECT
            date,
            ticker,
            open,
            high,
            low,
            volume,
            ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY date) AS row_number
        FROM base
        WHERE ticker NOT IN (SELECT DISTINCT ticker FROM index_base)
    ) AS subquery
    WHERE row_number = 1
),

-- Select the latest date record for each ticker excluding the baseline.
max_ticker_date AS (
    SELECT *
    FROM (
        SELECT
            date,
            ticker,
            open,
            close,
            high,
            low,
            volume,
            ROW_NUMBER()
                OVER (PARTITION BY ticker ORDER BY date DESC)
            AS row_number
        FROM base
        WHERE ticker NOT IN (SELECT DISTINCT ticker FROM index_base)
    ) AS subquery
    WHERE row_number = 1
),

-- Calculate days_diff and growth
days_diff AS (
    SELECT
        -- Array of minimum and maximum dates.
        mitd.ticker,
        -- Array of index and ticker symbols.
        ARRAY[mitd.date, matd.date] AS dates,
        -- Array of opening prices for index and minimum date.
        ARRAY[ib.ticker, mitd.ticker] AS tickers,
        -- Array of closing prices for index and maximum date.
        ARRAY[ib.open, mitd.open] AS opens,
        ARRAY[ib2.close, matd.close] AS closes,
        matd.date - mitd.date AS days_diff,
        ROUND(((ib2.close - ib.open) / ib.open * 100), 2) AS index_growth,
        ROUND(((matd.close - mitd.open) / mitd.open * 100), 2) AS ticker_growth
    FROM
        min_ticker_date AS mitd
    INNER JOIN index_base AS ib ON mitd.date = ib.date
    INNER JOIN max_ticker_date AS matd ON mitd.ticker = matd.ticker
    INNER JOIN index_base AS ib2 ON matd.date = ib2.date

)

-- Final selection	
SELECT
    ticker,
    days_diff,
    CAST(
        ((ticker_growth - index_growth) / index_growth * 100) AS integer
    ) AS delta
FROM days_diff
ORDER BY delta DESC
