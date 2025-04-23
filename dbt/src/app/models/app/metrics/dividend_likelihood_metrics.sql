{% do log("Current ENV: " ~ env_var('DB_DATABASE'), info=true) %}

{{
  config(
    materialized='table',
    database=env_var('DB_DATABASE'),
    schema='metrics'
  )
}}

with metrics_dividend_likelihood as (
select
	group_number,
	cumulative_dividend_rate_pct,
	COUNT(*) as count
from
     {{ ref('dividend_likelihood') }}
group by
	group_number,
	cumulative_dividend_rate_pct
),
ranked_counts as (
select
	group_number,
	cumulative_dividend_rate_pct::int,
	count,
	row_number() over (partition by group_number
order by
	cumulative_dividend_rate_pct) as row_number,
	'cumulative dividend rate pct' as metric
from
	metrics_dividend_likelihood
)
select
	group_number,
	cumulative_dividend_rate_pct,
	count,
	row_number,
	metric
from
	ranked_counts
order by
	group_number,
	cumulative_dividend_rate_pct


