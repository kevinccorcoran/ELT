{{ 
    config(
        materialized='table', 
        unique_key='ticker'
    )

}}

WITH BASE_TABLE AS (
    SELECT
        DATE,
        REGEXP_REPLACE(TICKER, '[^a-zA-Z]', '', 'g') AS TICKER,
        OPEN,
        HIGH,
        LOW,
        CLOSE,
        ADJ_CLOSE,
        VOLUME,
        PROCESSED_AT
    FROM {{ source('raw', 'historical_daily_main') }}
),

MIN_MAX_DATE AS (
    SELECT
        TICKER,
        MIN(DATE)::date AS MIN_DATE,
        MAX(DATE)::date AS MAX_DATE
    FROM BASE_TABLE

    GROUP BY TICKER
)

SELECT
    MMD.MIN_DATE,
    MMD.MAX_DATE,
    MMD.TICKER,
    MMD.MAX_DATE - MMD.MIN_DATE AS AGE,
    ROUND(BT.OPEN::numeric, 2) AS OPEN,
    ROUND(BT2.CLOSE::numeric, 2) AS CLOSE
FROM MIN_MAX_DATE AS MMD
INNER JOIN BASE_TABLE AS BT
    ON
        MMD.TICKER = BT.TICKER
        AND MMD.MIN_DATE = BT.DATE
INNER JOIN BASE_TABLE AS BT2 ON
    MMD.TICKER = BT2.TICKER
    AND MMD.MAX_DATE = BT2.DATE