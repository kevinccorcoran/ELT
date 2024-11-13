{% do log("Current ENV: " ~ env_var('ENV'), info=true) %}

{{
    config(
        materialized='table',
        database=env_var('ENV'),
        schema='metrics'
    )
}}


with avg_cagr AS (
    -- Calculate the average CAGR for each group
    SELECT
        n,
        cagr_group,
        ROUND(AVG(cagr), 1) AS avg_cagr,
        type
    FROM
        {{ ref('company_cagr') }}
    GROUP BY
        n,
        cagr_group,
        type)
, min_max AS (
    -- Calculate the min and max CAGR for each group
    SELECT
        n,
        cagr_group,
        ROUND(MIN(cagr), 1) AS min_cagr,
        ROUND(MAX(cagr), 1) AS max_cagr,
        type
    FROM
        {{ ref('company_cagr') }}
    GROUP BY
        n,
        cagr_group,
        type
),
cte AS (
    SELECT
        ac.n,
        ac.cagr_group,
        ac.avg_cagr,
        mm.min_cagr,
        mm.max_cagr,
        ac.type
    FROM
        avg_cagr ac
    JOIN
        min_max mm
    ON
        ac.n = mm.n
        AND ac.cagr_group = mm.cagr_group
        AND ac.type = mm.type
)
SELECT
    *
FROM
    cte
