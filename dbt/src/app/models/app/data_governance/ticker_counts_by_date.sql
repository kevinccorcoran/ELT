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
lookup_since_ipo as (
    SELECT
        current_date AS "date",          
        COUNT(DISTINCT ticker) AS "cdm_lookup_since_ipo" 
    FROM
        {{ source('cdm', 'lookup_since_ipo') }}
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
    "cdm_lookup_since_ipo",
    "cdm_company_cagr" 
from
    api_data_ingestion ardi
left join
    api_data_ingestion acdi
    on ardi.date::date = acdi.date::date
left join 
    lookup_since_ipo dl
    on ardi.date = dl.date
left join 
    company_cagr cc
    on ardi.date = cc.date


    {% if is_incremental() %}
    and ardi.date > (SELECT MAX(date) FROM {{ this }})
    {% endif %}