
{{ 
    config(
        materialized='table', 
        unique_key='ticker'
    )

}}

WITH BASE AS (
    SELECT
        DATE,
        VOLUME,
        PROCESSED_AT,
        TICKER,
        OPEN,
        HIGH,
        LOW,
        CLOSE,
        ADJ_CLOSE,
        EXTRACT(YEAR FROM DATE) AS YEAR,
        EXTRACT(MONTH FROM DATE) AS MONTH
    FROM {{ ref('historical_daily_main_clean') }}
),

-- Create rownum every 3 months
ROWNUM AS (
    SELECT
        TICKER,
        DATE,
        HIGH,
        LOW,
        (ROW_NUMBER() OVER (ORDER BY DATE DESC) - 1) / 60 + 1 AS ROWNUM
    FROM BASE
    WHERE TICKER = 'GSPC'
    ORDER BY DATE DESC
)

SELECT
    TICKER,
    ROWNUM,
    MIN(LOW) AS LOW,
    MAX(HIGH) AS HIGH
FROM ROWNUM
GROUP BY TICKER, ROWNUM
ORDER BY ROWNUM ASC
