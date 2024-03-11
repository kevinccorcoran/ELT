/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with historical_daily_main as (

    select


        date,
        volume::bigint as volume999,
        processed_at::date as processed_at,
        REGEXP_REPLACE(ticker, '[^A-Za-z]', '', 'g') as ticker,
        ROUND(open::numeric, 2) as open,
        ROUND(high::numeric, 2) as high,
        ROUND(low::numeric, 2) as low,
        ROUND(close::numeric, 2) as close,
        ROUND(adj_close::numeric, 2) as adj_close
    --from "raw".historical_daily_main
    FROM {{ source('raw', 'historical_daily_main') }}

)

select *
from historical_daily_main

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
