{% do log("Current ENV: " ~ env_var('DB_DATABASE'), info=true) %}

{{
  config(
    materialized='table',
    database=env_var('DB_DATABASE'),
    schema='metrics'
  )
}}

-- Base table: raw dividend data cleaned and typed
with base_table as (
  select
    cast("date" as date) as date,
    ticker,
    cast(dividends as numeric(18, 8)) as dividends
  from {{ source('cdm', 'api_data_ingestion') }}
),
-- Find the first dividend date per ticker
first_dividend_date as (
  select
    ticker,
    min(date) as first_div_date
  from base_table
  where dividends is not null and dividends <> 0
  group by ticker
),
-- Filter base table to start from each ticker's first dividend
filtered_base as (
  select b.*
  from base_table b
  join first_dividend_date f
    on b.ticker = f.ticker
   and b.date >= f.first_div_date
),
-- Join with quarter lookup to assign quarter numbers and median dates
join_quarter_number as (
  select
    b.date,
    b.ticker,
    b.dividends,
    cast(q.quarter_number as integer) as quarter_number,
    q.median_date
  from filtered_base b
  join {{ ref('lookup_quarter_gspc') }} q
    on b.date between q.min_date and q.max_date
),
-- For each ticker + quarter, get the max dividend value
quarter_dividend as (
  select
    ticker,
    quarter_number,
    max(case when dividends is null or dividends = 0 then 0 else dividends end) as max_dividend,
    median_date
  from join_quarter_number
  group by ticker, quarter_number, median_date
),
-- Get dates of non-zero dividend events per quarter
quarter_date as (
  select
    ticker,
    date,
    quarter_number
  from join_quarter_number
  where dividends is not null and dividends <> 0
),
-- Combine dividend value with event date or median fallback
join_div_to_date as (
  select
    di.ticker,
    di.quarter_number,
    di.max_dividend as dividend,
    coalesce(da.date, di.median_date) as date
  from quarter_dividend di
  left join quarter_date da
    on di.ticker = da.ticker
   and di.quarter_number = da.quarter_number
),
-- Assign row numbers per ticker
row_num as (
  select *,
         row_number() over (partition by ticker order by quarter_number) - 1 as row_num
  from join_div_to_date
),
-- Add cumulative dividend count
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
),
-- Calculate dividend likelihood metrics
dividend_likelihood as (
  select
    concat(ticker, '_', date::text) as ticker_date_id,
    ticker,
    dividend,
    date,
    cumulative_dividend_count  cumulative_dividend_count,
   --FLOOR((cumulative_dividend_count::numeric / cumulative_total) * 100 / 5) * 5 AS cumulative_dividend_rate_pct
   --ROUND((cumulative_dividend_count::numeric / cumulative_total) * 100, -1) as cumulative_dividend_rate_pct
   ROUND((cumulative_dividend_count::numeric / cumulative_total) * 100 / 5) * 5 as cumulative_dividend_rate_pct
  from cumulative_dividend_count
),
-- Pull full pricing data for enrichment (used again later)
cdm_api_data_ingestion as (
  select
    date,
    ticker,
    open,
    high,
    low,
    close,
    volume,
    dividends,
    stock_splits,
    processed_at,
    adj_close,
    capital_gains,
    date_type,
    ticker_date_id
  from cdm.api_data_ingestion
),
-- Join dividend likelihood with adjusted close price
joined_dividend_and_price as (
  select
    d.ticker_date_id,
    d.ticker,
    d.date,
    d.cumulative_dividend_count,
    d.cumulative_dividend_rate_pct,
    c.adj_close
  from dividend_likelihood d
  join {{ source('cdm', 'api_data_ingestion') }} c
    on d.ticker_date_id = c.ticker_date_id
),
-- Add group number per ticker by date
group_number as (
  select
    jdp.ticker_date_id,
    jdp.ticker,
    jdp.date,
    row_number() over (partition by jdp.ticker order by jdp.date) - 1 as group_number,
    jdp.cumulative_dividend_count,
    jdp.cumulative_dividend_rate_pct,
    jdp.adj_close
  from joined_dividend_and_price jdp
),
-- Get min/max dates and date range per ticker
min_max_dates as (
  select
    ticker,
    min(cast(date as date)) as min_date,
    max(cast(date as date)) as max_date--,
    --(max(cast(date as date)) - min(cast(date as date))) as date_diff_days
  from cdm.api_data_ingestion
  group by ticker
  order by ticker
),
-- Add group info and min/max dates
group_number_count as (
  select
    g.ticker,
    g.ticker_date_id,
    g.date,
    g.group_number,
    g.cumulative_dividend_count,
    g.cumulative_dividend_rate_pct,
    gn.min_date,
    gn.max_date,
    gn.max_date - g.date as date_diff_days
    --gn.date_diff_days
  from group_number g
  join min_max_dates gn
    on g.ticker = gn.ticker
),
-- Get daily adjusted close values
adj_close as (
  select
    ticker_date_id,
    adj_close as date_adj_close
  from {{ source('cdm', 'api_data_ingestion') }}
  where adj_close <> 0 and adj_close >= 0
  order by ticker_date_id
),
-- Join back adjusted close
join_adj_close as (
  select
    g.*,
    a.date_adj_close
  from group_number_count g
  join adj_close a
    on g.ticker_date_id = a.ticker_date_id
),
-- Get most recent adjusted close per ticker
max_date_adj_close as (
  select distinct on (ticker)
    ticker,
    date,
    adj_close as cur_adj_close
  from {{ source('cdm', 'api_data_ingestion') }}
  order by ticker, date desc
),
-- Final selection of all joined metrics
final_selection as (
  select
    j.ticker,
    j.ticker_date_id,
    j."date",
    j.min_date,
    j.max_date,
    j.group_number,
    j.date_diff_days,
    j.cumulative_dividend_count,
    j.cumulative_dividend_rate_pct,
      ROUND(
        (100.0 * ( m.cur_adj_close -  j.date_adj_close) / nullif( j.date_adj_close, 0))::numeric,
        2
    ) as price_pct_change
      From join_adj_close j
        join max_date_adj_close m
      on j.ticker = m.ticker
    )
select * from final_selection


