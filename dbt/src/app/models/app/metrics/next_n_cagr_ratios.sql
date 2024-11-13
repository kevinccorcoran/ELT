{% do log("Current ENV: " ~ env_var('ENV'), info=true) %}

{{
    config(
        materialized='table',
        database=env_var('ENV'),
        schema='metrics'
    )
}}

WITH base AS (
  -- Select the base data where n is not zero
  SELECT
    ticker,
    n,
    cagr,
    cagr_group,
    "type"
  FROM
    {{ ref('company_cagr') }}
  WHERE
    n <> 0
),
next_n AS (
  -- Calculate the next value of n using LEAD, with a default value of 54 if no next value exists
  SELECT
    n,
    COALESCE(LEAD(n) OVER (ORDER BY n), 54) AS next_n
  FROM (
    SELECT DISTINCT n FROM {{ ref('company_cagr') }}
  ) AS subquery
),
joined_data AS (
  -- Join base data with the next_n values and get the corresponding next CAGR and next CAGR group
  SELECT
    b.ticker,
    b.n,
    nn.next_n,
    b.cagr,
    b.cagr_group,
    b."type",
    ijn.cagr AS next_cagr,
    ijn.cagr_group AS next_cagr_group
  FROM
    base b
    JOIN next_n nn ON b.n = nn.n
    -- Perform an inner join to fetch the next CAGR values
    INNER JOIN base ijn ON b.ticker = ijn.ticker
      AND nn.next_n = ijn.n
      AND b."type" = ijn."type"
),
grouped_data AS (
  -- Group the data by n, next_n, cagr_group, next_cagr_group, and type, and count occurrences
  SELECT
    n,
    next_n,
    cagr_group,
    next_cagr_group,
    COUNT(*) AS count,
    "type"
  FROM
    joined_data
  GROUP BY
    n, next_n, cagr_group, next_cagr_group, "type"
),
count_sum AS (
  -- Calculate the total count for each n, next_n, cagr_group, and type combination
  SELECT
    n,
    next_n,
    cagr_group,
    SUM(count) AS total_count,
    "type"
  FROM
    grouped_data
  GROUP BY
    n, next_n, cagr_group, "type"
)
-- Select the final results with the calculated ratio of count over total_count
SELECT
  g.n,
  g.next_n,
  g.cagr_group,
  g.next_cagr_group,
  ROUND((g.count::NUMERIC / cs.total_count), 2) AS ratio,
  g."type"
FROM
  grouped_data g
  JOIN count_sum cs ON g.n = cs.n
    AND g.next_n = cs.next_n
    AND g.cagr_group = cs.cagr_group
    AND g."type" = cs."type"
--WHERE
  --g."type" = 'CAGR from Zero'
ORDER BY
  g.n, g.next_n
