{{ config(
    materialized='incremental',
    unique_key='date'
) }}

with 
api_raw_data_ingestion as (
    select
        date,
        count(distinct ticker) as "raw.api_raw_data_ingestion"
    from
        {{ source('raw', 'api_raw_data_ingestion') }}
    group by
        date
    order by
        date desc
), 
date_lookup as (
    SELECT
        current_date AS "date",          
        COUNT(DISTINCT ticker) AS "cdm.date_lookup" 
    FROM
        {{ source('cdm', 'date_lookup') }}
), 
company_cagr as (
    SELECT
        current_date AS "date",          
        COUNT(DISTINCT ticker) AS "cdm.company_cagr" 
    FROM
        {{ ref('company_cagr') }}
)
select
    ardi.date,
    "raw.api_raw_data_ingestion",
    "cdm.date_lookup",
    "cdm.company_cagr" 
from
    api_raw_data_ingestion ardi
left join 
    date_lookup dl
    on ardi.date = dl.date
left join 
    company_cagr cc
    on ardi.date = cc.date

where 
    ardi.date > (SELECT MAX(date) FROM "data_governance"."ticker_counts_by_date")
    
    {% if is_incremental() %}
    and ardi.date > (SELECT MAX(date) FROM {{ this }})
    {% endif %}