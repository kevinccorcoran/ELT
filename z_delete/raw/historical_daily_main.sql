{{ config(materialized='table') }}

with historical_daily_main as (

    select
        *
    from "raw".historical_daily_main

)

select *
from historical_daily_main