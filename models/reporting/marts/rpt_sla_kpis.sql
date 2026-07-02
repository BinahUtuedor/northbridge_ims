{{ config(materialized='table') }}

WITH f AS (
    SELECT * FROM {{ ref('fct_tickets') }}
),

p AS (
    SELECT * FROM {{ ref('dim_priority') }}
),

d AS (
    SELECT * FROM {{ ref('dim_date') }}
)

SELECT

    ----------------------------------------------------------------------------
    -- Date Intelligence (from dim_date)
    ----------------------------------------------------------------------------
    d.year,
    d.quarter,
    d.month,
    d.month_name,
    d.week,

    ----------------------------------------------------------------------------
    -- Business Attributes (NO IDS)
    ----------------------------------------------------------------------------
    p.priority_label,
    f.contract_tier,

    ----------------------------------------------------------------------------
    -- KPIs
    ----------------------------------------------------------------------------
    COUNT(*) AS total_tickets,

    COUNT_IF(f.status = 'Closed')      AS closed_tickets,
    COUNT_IF(f.status = 'Resolved')    AS resolved_tickets,
    COUNT_IF(f.status = 'Open')        AS open_tickets,
    COUNT_IF(f.status = 'In Progress') AS in_progress_tickets,

    SUM(f.sla_breach_count) AS sla_breaches,

    ROUND(
        100 * SUM(f.sla_breach_count) / NULLIF(COUNT(*),0),
        2
    ) AS sla_breach_percentage,

    ROUND(AVG(f.first_response_minutes),2) AS avg_first_response_minutes,
    ROUND(AVG(f.resolution_minutes),2)     AS avg_resolution_minutes

FROM f

LEFT JOIN p
    ON f.priority_id = p.priority_id

LEFT JOIN d
    ON f.created_date_key = d.date_key

GROUP BY
    d.year, d.quarter, d.month, d.month_name, d.week,
    p.priority_label,
    f.contract_tier