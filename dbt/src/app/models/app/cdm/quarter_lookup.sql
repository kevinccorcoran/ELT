{% do log("Current ENV: " ~ env_var('ENV'), info=true) %}

{{
    config(
        materialized='table',
        database=env_var('ENV'),
        schema='cdm'
    )
}}


with base_table as (
  select
    "date",
    ticker,
    dividends,
    date_trunc('quarter', "date") as quarter_start
  from
    {{ source('raw', 'api_data_ingestion') }}
  where
    ticker = '^GSPC'
),
ranked_quarters as (
  select
    distinct quarter_start
  from
    base_table
),
numbered_quarters as (
  select
    quarter_start,
    row_number() over (order by quarter_start) - 1 as quarter_number
  from
    ranked_quarters
),
with_quarter_number as (
  select
    b."date",
    b.ticker,
    nq.quarter_number
  from
    base_table b
  join
    numbered_quarters nq
  on
    b.quarter_start = nq.quarter_start
)
select
  ticker,
  quarter_number,
  min("date") as min_date,
  max("date") as max_date,
  to_timestamp(
  percentile_cont(0.5) within group (order by extract(epoch from date)))::date AS median_date
from
  with_quarter_number
group by
  ticker, quarter_number
order by
  quarter_number