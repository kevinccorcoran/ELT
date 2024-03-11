
{{ 
    config(
        materialized='table', 
        unique_key='ticker'
    )

}}
-- Initial setup: Select and clean data from the "historical_daily_main" table.
WITH base AS (
    SELECT 
        DATE(DATE) AS date,
        REGEXP_REPLACE(TICKER, '[^a-zA-Z]', '', 'g') AS ticker, -- Remove non-alphabetic characters from ticker.
        ROUND(CAST(OPEN AS NUMERIC), 2) AS open, -- Round OPEN to 2 decimal places.
        ROUND(CAST(HIGH AS NUMERIC), 2) AS high, -- Round HIGH to 2 decimal places.
        ROUND(CAST(LOW AS NUMERIC), 2) AS low, -- Round LOW to 2 decimal places.
        ROUND(CAST(CLOSE AS NUMERIC), 2) AS close, -- Round CLOSE to 2 decimal places.
        ROUND(CAST(ADJ_CLOSE AS NUMERIC), 2) AS adj_close, -- Round ADJ_CLOSE to 2 decimal places.
        VOLUME
    FROM 
        {{ source('raw', 'historical_daily_main') }}
        
--     WHERE 
--         TICKER IN ('MSFT', '^GSPC') -- Filter for specific tickers.
),

-- Create a subset for baseline ticker data.
index_base AS (
    SELECT * 
    FROM base 
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
