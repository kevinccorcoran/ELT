
{{ 
    config(
        materialized='table', 
        unique_key='ticker'
    )

}}
-- Initial setup: Select and clean data from the "historical_daily_main" table.
WITH base AS (
    SELECT 
        *
    FROM
        {{ ref('historical_daily_main_clean') }}
),

-- Create a subset for baseline ticker data.
index_base AS (
    SELECT * 
    FROM base 
    WHERE ticker IN ('GSPC')
),

-- Select the earliest date record for each ticker excluding the baseline.
MIN_TICKER_DATE AS (
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
    ) subquery
    WHERE row_number = 1
),

-- Select the latest date record for each ticker excluding the baseline.
MAX_TICKER_DATE AS (
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
            ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY date DESC) AS row_number
        FROM base
        WHERE ticker NOT IN (SELECT DISTINCT ticker FROM index_base)
    ) subquery
    WHERE row_number = 1
)

-- Final selection
SELECT 
    ARRAY[mitd.date, matd.date] AS dates, -- Array of minimum and maximum dates.
    ARRAY[ib.ticker, mitd.ticker] AS tickers, -- Array of index and ticker symbols.
    ARRAY[ib.open, mitd.open] AS opens, -- Array of opening prices for index and minimum date.
    ARRAY[ib2.close, matd.close] AS closes -- Array of closing prices for index and maximum date.
FROM 
    MIN_TICKER_DATE mitd
    JOIN index_base ib ON mitd.date = ib.date
    JOIN MAX_TICKER_DATE matd ON mitd.ticker = matd.ticker
    JOIN index_base ib2 ON matd.date = ib2.date
-- Optional filters and ordering can be added here.
