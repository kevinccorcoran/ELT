{{ 
    config(
        materialized='table'
        )

}}

with crypto_main as (

    select
        *
    from "raw".crypto_main

)

select *
from crypto_main