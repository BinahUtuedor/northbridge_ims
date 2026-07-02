{{ config(
    materialized='table'
) }}

-- ============================================================================
-- Model: rpt_client_sla
-- Layer: REPORTING MART
--
-- Purpose
-- -------
-- Client-level SLA and operational performance view.
-- Used by account managers and executives.
--
-- Grain
-- -----
-- One row per Client
-- ============================================================================

WITH f AS (

    SELECT *
    FROM {{ ref('fct_tickets') }}

),

c AS (

    SELECT *
    FROM {{ ref('dim_clients') }}

),

p AS (

    SELECT *
    FROM {{ ref('dim_priority') }}

)

SELECT

    ----------------------------------------------------------------------------
    -- Client Attributes (BI-Friendly)
    ----------------------------------------------------------------------------
    c.client_id,
    c.client_name,
    c.client_type,
    c.contract_tier,
    c.region,
    c.is_active,

    ----------------------------------------------------------------------------
    -- Ticket Volume Metrics
    ----------------------------------------------------------------------------
    COUNT(f.ticket_id) AS total_tickets,
    SUM(f.ticket_count) AS ticket_volume,

    COUNT_IF(f.status = 'Open')        AS open_tickets,
    COUNT_IF(f.status = 'Closed')      AS closed_tickets,
    COUNT_IF(f.status = 'Resolved')    AS resolved_tickets,

    ----------------------------------------------------------------------------
    -- SLA Performance
    ----------------------------------------------------------------------------
    SUM(f.sla_breach_count) AS sla_breaches,

    ROUND(
        100 * SUM(f.sla_breach_count)
        / NULLIF(COUNT(f.ticket_id), 0),
        2
    ) AS sla_breach_percentage,

    ROUND(
        100 * SUM(CASE WHEN f.resolved_within_sla THEN 1 ELSE 0 END)
        / NULLIF(COUNT(f.ticket_id), 0),
        2
    ) AS resolution_sla_compliance_pct,

    ROUND(
        100 * SUM(CASE WHEN f.responded_within_sla THEN 1 ELSE 0 END)
        / NULLIF(COUNT(f.ticket_id), 0),
        2
    ) AS response_sla_compliance_pct,

    ----------------------------------------------------------------------------
    -- Operational Metrics
    ----------------------------------------------------------------------------
    ROUND(AVG(f.first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(f.resolution_minutes), 2)     AS avg_resolution_minutes,
    ROUND(AVG(f.ticket_age_days), 2)        AS avg_ticket_age_days,

    ----------------------------------------------------------------------------
    -- Risk Indicators
    ----------------------------------------------------------------------------
    SUM(CASE WHEN f.escalated_flag THEN 1 ELSE 0 END) AS escalated_tickets,

    ROUND(
        100 * SUM(CASE WHEN f.escalated_flag THEN 1 ELSE 0 END)
        / NULLIF(COUNT(f.ticket_id), 0),
        2
    ) AS escalation_rate_percentage

FROM c

LEFT JOIN f
    ON c.client_id = f.client_id

GROUP BY
    c.client_id,
    c.client_name,
    c.client_type,
    c.contract_tier,
    c.region,
    c.is_active