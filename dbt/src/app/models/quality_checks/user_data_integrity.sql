{{ config(
    materialized='incremental',
    unique_key='PROCESSED_AT',
    schema='quality_checks'
) }}

with cte as ( 
    SELECT 
        PROCESSED_AT
    FROM {{ ref('historical_daily_main_clean') }}
    WHERE
        (OPEN <= 0 OR OPEN IS NULL)
        OR (HIGH <= 0 OR HIGH IS NULL)
        OR (LOW <= 0 OR LOW IS NULL) 
)

select PROCESSED_AT, 
    count(*), 
    'cdm_historical_daily_main_clean_check_nulls' as test_id,
    '' as severity,
    '' as priority,
    'The test checks how many NULL and <= 0 values for OPEN, HIGH, and LOW exist per "processed_at" timestamp.' as check,
    '/Users/kevin/Dropbox/applications/ELT/pytest_tests/unit_tests/test_cdm_historical_daily_main_clean_nulls.py' as source
from cte
-- Start of integrated WHERE clause
WHERE 1=1
{% if is_incremental() %}
  AND PROCESSED_AT > (SELECT MAX(PROCESSED_AT) FROM {{ this }})
{% endif %}
group by PROCESSED_AT
