-- ============================================================================
-- REPORTING: Agent Performance 
-- ============================================================================

{{ config(materialized='table') }}

WITH f AS (
    SELECT *
    FROM {{ ref('fct_tickets') }}
),

a AS (
    SELECT *
    FROM {{ ref('dim_agents') }}
)

SELECT

    -- Agent attributes
    a.agent_id,
    a.full_name,
    a.team_id,
    a.role,
    a.hub,
    a.specialisms,
    a.daily_capacity,
    a.is_active,

    -- ticket metrics
    COUNT(f.ticket_id) AS tickets_assigned,

    COUNT_IF(f.status = 'Closed')        AS tickets_closed,
    COUNT_IF(f.status = 'Resolved')      AS tickets_resolved,
    COUNT_IF(f.status = 'Open')          AS tickets_open,
    COUNT_IF(f.status = 'In Progress')   AS tickets_in_progress,

    -- SLA metrics
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
    ) AS resolution_sla_compliance_percentage,

    ROUND(
        100 * SUM(CASE WHEN f.responded_within_sla THEN 1 ELSE 0 END)
        / NULLIF(COUNT(f.ticket_id), 0),
        2
    ) AS response_sla_compliance_percentage,

    -- performance metrics
    ROUND(AVG(f.first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(f.resolution_minutes), 2)     AS avg_resolution_minutes,
    ROUND(AVG(f.resolution_hours_actual), 2) AS avg_resolution_hours,

    -- productivity
    ROUND(
        COUNT(f.ticket_id) / NULLIF(a.daily_capacity, 0),
        2
    ) AS productivity_ratio,

    ROUND(AVG(f.ticket_age_days), 2) AS avg_ticket_age_days,

    -- escalations
    SUM(CASE WHEN f.escalated_flag THEN 1 ELSE 0 END) AS escalated_tickets,

    ROUND(
        100 * SUM(CASE WHEN f.escalated_flag THEN 1 ELSE 0 END)
        / NULLIF(COUNT(f.ticket_id), 0),
        2
    ) AS escalation_rate_percentage,

    -- segmentation
    CASE
        WHEN AVG(f.resolution_minutes) <= 120
         AND SUM(f.sla_breach_count) = 0
        THEN 'High Performer'

        WHEN AVG(f.resolution_minutes) <= 240
         AND SUM(f.sla_breach_count) <= 3
        THEN 'Standard Performer'

        ELSE 'Needs Improvement'
    END AS performance_segment,

    CASE
        WHEN a.is_active = TRUE THEN 'Active'
        ELSE 'Inactive'
    END AS agent_status

FROM a   -- FIX: dimension-first join (critical)

LEFT JOIN f
    ON f.agent_id = a.agent_id

GROUP BY
    a.agent_id,
    a.full_name,
    a.team_id,
    a.role,
    a.hub,
    a.specialisms,
    a.daily_capacity,
    a.is_active
