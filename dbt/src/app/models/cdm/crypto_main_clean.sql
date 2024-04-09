{{ 
config(
    materialized='table'
) 
}}

WITH crypto_main AS (
    SELECT
        volume::bigint AS volume,
        processed_at::date AS processed_at,
        DATE(date) AS date,
        REGEXP_REPLACE(ticker, '[^A-Za-z]', '', 'g') AS ticker,
        -- CASE
        --     WHEN open <> 0 THEN ROUND(open::numeric, 2)
		-- 	WHEN open = 0 THEN ROUND((high::numeric + low::numeric) / 2, 2)
        -- END AS open,
        open,
        ROUND(high::numeric, 2) AS high,
        ROUND(low::numeric, 2) AS low,
        ROUND(close::numeric, 2) AS close,
        ROUND(adj_close::numeric, 2) AS adj_close
    FROM {{ source('raw', 'crypto_main') }}
)

SELECT * FROM crypto_main
