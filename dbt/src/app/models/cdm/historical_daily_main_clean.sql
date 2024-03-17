/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

WITH historical_daily_main AS (
    SELECT
        volume::bigint AS volume,
        processed_at::date AS processed_at,
        DATE(date) AS date,
        REGEXP_REPLACE(ticker, '[^A-Za-z]', '', 'g') AS ticker,
        CASE
            WHEN open <> 0 THEN ROUND(open::numeric, 2)
			WHEN open = 0 THEN ROUND((high::numeric + low::numeric) / 2, 2)
        END AS open,
        ROUND(high::numeric, 2) AS high,
        ROUND(low::numeric, 2) AS low,
        ROUND(close::numeric, 2) AS close,
        ROUND(adj_close::numeric, 2) AS adj_close
    FROM {{ source('raw', 'historical_daily_main') }}
)

SELECT * FROM historical_daily_main

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
