/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with historical_daily_main as (

    SELECT
        date,
        open ,
        high ,
        low ,
        close ,
        adj_close ,
        volume ,
        processed_at 
    FROM "raw".HISTORICAL_DAILY_MAIN

)

select *
from historical_daily_main

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null