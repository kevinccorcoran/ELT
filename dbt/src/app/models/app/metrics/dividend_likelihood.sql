{% do log("Current ENV: " ~ env_var('DB_DATABASE'), info=true) %}

{{
  config(
    materialized='table',
    database=env_var('DB_DATABASE'),
    schema='metrics'
  )
}}

with base_table as (
  select
    cast("date" as date) as date,
    ticker,
    cast(dividends as numeric(12, 8)) as dividends
  from {{ source('cdm', 'api_data_ingestion') }}
),
first_dividend_date as (
  select
    ticker,
    min(date) as first_div_date
  from base_table
  where dividends is not null and dividends <> 0
  group by ticker
),
filtered_base as (
  select
    b.*
  from base_table b
  join first_dividend_date f
    on b.ticker = f.ticker and b.date >= f.first_div_date
),
join_quarter_number as (
  select
    b.date,
    b.ticker,
    b.dividends,
    cast(q.quarter_number as integer) as quarter_number,
    q.median_date
  from filtered_base b
  join cdm.quarter_lookup q
    on b.date between q.min_date and q.max_date
),
quarter_dividend as (
  select
    ticker,
    quarter_number,
    max(case when dividends is null or dividends = 0 then 0 else dividends end) as max_dividend,
    median_date
  from join_quarter_number
  group by ticker, quarter_number, median_date
),
quarter_date as (
  select
    ticker,
    date,
    quarter_number
  from join_quarter_number
  where dividends is not null and dividends <> 0
),
join_div_to_date as (
  select
    di.ticker,
    di.quarter_number,
    di.max_dividend as dividend,
    coalesce(da.date, di.median_date) as date
  from quarter_dividend di
  left join quarter_date da
    on di.ticker = da.ticker and di.quarter_number = da.quarter_number
),
row_num as (
  select
    *,
    row_number() over (partition by ticker order by quarter_number) - 1 as row_num
  from join_div_to_date
),
cumulative_dividend_count as (
  select
    ticker,
    quarter_number,
    dividend,
    date,
    row_num,
    row_num + 1 as cumulative_total,
    sum(case when dividend > 0 then 1 else 0 end)
      over (partition by ticker order by row_num rows between unbounded preceding and current row)
      as cumulative_dividend_count
  from row_num
)
select
  concat(ticker, '_', date::text) as ticker_date_id,
  ticker,
  dividend,
  date,
  round(cumulative_dividend_count / 5.0) * 5 as cumulative_dividend_count_rounded,
  floor((cumulative_dividend_count::numeric / cumulative_total) * 10) * 10 as cumulative_dividend_rate_pct
from cumulative_dividend_count
