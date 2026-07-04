{{ config(materialized='table') }}

WITH f AS (
    SELECT * FROM {{ ref('fct_tickets') }}
),

p AS (
    SELECT * FROM {{ ref('dim_priority') }}
),

c AS (
    SELECT * FROM {{ ref('dim_ticket_category') }}
),

d AS (
    SELECT * FROM {{ ref('dim_date') }}
)

SELECT

    ----------------------------------------------------------------------------
    -- Time Intelligence
    ----------------------------------------------------------------------------
    d.year,
    d.month,
    d.month_name,
    d.week,

    ----------------------------------------------------------------------------
    -- Business Attributes (NO IDS)
    ----------------------------------------------------------------------------
    p.priority_label,
    c.category_name,

    f.channel,
    f.status,

    ----------------------------------------------------------------------------
    -- KPIs
    ----------------------------------------------------------------------------
    COUNT(*) AS total_tickets,
    SUM(f.sla_breach_count) AS sla_breaches,

    ROUND(AVG(f.first_response_minutes),2) AS avg_first_response_minutes,
    ROUND(AVG(f.resolution_minutes),2)     AS avg_resolution_minutes,
    ROUND(AVG(f.resolution_hours_actual),2) AS avg_resolution_hours

FROM f

LEFT JOIN p
    ON f.priority_id = p.priority_id

LEFT JOIN c
    ON f.category_id = c.category_id

LEFT JOIN d
    ON f.created_date_key = d.date_key

GROUP BY
    d.year, d.month, d.month_name, d.week,
    p.priority_label,
    c.category_name,
    f.channel,
    f.status