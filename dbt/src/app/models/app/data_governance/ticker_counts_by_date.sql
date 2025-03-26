{{ config(
    materialized='incremental',
    unique_key='date'
) }}

with 
api_data_ingestion as (
    select
        date,
        count(distinct ticker) as "raw_api_data_ingestion"
    from
        {{ source('raw', 'api_data_ingestion') }}
    group by
        date
    order by
        date desc
), 
api_data_ingestion as (
    select
        date,
        count(distinct ticker) as "cdm_api_data_ingestion"
    from
        {{ source('cdm', 'api_data_ingestion') }}
    group by
        date
    order by
        date desc
), 
date_lookup as (
    SELECT
        current_date AS "date",          
        COUNT(DISTINCT ticker) AS "cdm_date_lookup" 
    FROM
        {{ source('cdm', 'date_lookup') }}
), 
company_cagr as (
    SELECT
        current_date AS "date",          
        COUNT(DISTINCT ticker) AS "cdm_company_cagr" 
    FROM
        {{ ref('company_cagr') }}
)
select
    ardi.date,
    "raw_api_data_ingestion",
    "cdm_api_data_ingestion",
    "cdm_date_lookup",
    "cdm_company_cagr" 
from
    api_data_ingestion ardi
left join
    api_data_ingestion acdi
    on ardi.date::date = acdi.date::date
left join 
    date_lookup dl
    on ardi.date = dl.date
left join 
    company_cagr cc
    on ardi.date = cc.date


    {% if is_incremental() %}
    and ardi.date > (SELECT MAX(date) FROM {{ this }})
    {% endif %}