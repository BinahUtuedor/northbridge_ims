-- ============================================================================
-- FACT: Tickets (Uses stg_escalation_log, not fct_escalations)
-- ============================================================================

{{ config(materialized='table') }}

WITH tickets AS (
    SELECT * FROM {{ ref('stg_tickets') }}
),

clients AS (
    SELECT * FROM {{ ref('dim_clients') }}
),

sla AS (
    SELECT * FROM {{ ref('dim_sla') }}
),

-- FIX: Use stg_escalation_log directly (no circular dependency)
escalations AS (
    SELECT DISTINCT ticket_id
    FROM {{ ref('stg_escalation_log') }}
)

SELECT

    -- IDs
    t.ticket_id,
    t.ticket_reference,
    COALESCE(t.client_id, 0) AS client_id,
    COALESCE(t.assigned_agent_id, 0) AS agent_id,
    COALESCE(t.priority_id, 3) AS priority_id,
    COALESCE(t.category_id, 0) AS category_id,

    -- Dates
    CAST(t.created_at AS DATE) AS created_date_key,
    CAST(t.first_response_at AS DATE) AS first_response_date_key,
    CAST(t.resolved_at AS DATE) AS resolved_date_key,
    CAST(t.sla_due_at AS DATE) AS sla_due_date_key,
    t.created_at,
    t.first_response_at,
    t.resolved_at,
    t.sla_due_at,

    -- Attributes
    t.patient_ref,
    t.channel,
    t.status,
    COALESCE(c.contract_tier, 'Standard') AS contract_tier,

    -- SLA Definitions
    s.first_response_hours,
    s.resolution_hours,
    s.escalation_trigger_hours,

    -- Duration Calculations (NULL safe)
    DATEDIFF('minute', t.created_at, t.first_response_at) AS first_response_minutes,
    DATEDIFF('minute', t.created_at, t.resolved_at) AS resolution_minutes,
    DATEDIFF('hour', t.created_at, t.resolved_at) AS resolution_hours_actual,

    -- SLA Flags
    CASE
        WHEN s.first_response_hours IS NULL THEN FALSE
        WHEN DATEDIFF('minute', t.created_at, t.first_response_at) 
             <= s.first_response_hours * 60 THEN TRUE
        ELSE FALSE
    END AS responded_within_sla,

    CASE
        WHEN s.resolution_hours IS NULL THEN FALSE
        WHEN DATEDIFF('minute', t.created_at, t.resolved_at) 
             <= s.resolution_hours * 60 THEN TRUE
        ELSE FALSE
    END AS resolved_within_sla,

    -- Age
    DATEDIFF('day', t.created_at, COALESCE(t.resolved_at, CURRENT_TIMESTAMP())) AS ticket_age_days,

    -- Breach Metrics
    COALESCE(t.sla_breached, FALSE) AS sla_breached,
    CASE WHEN t.sla_breached THEN 1 ELSE 0 END AS sla_breach_count,

    -- Escalation
    CASE WHEN e.ticket_id IS NOT NULL THEN TRUE ELSE FALSE END AS escalated_flag,

    -- Count
    1 AS ticket_count

FROM tickets t

LEFT JOIN clients c
    ON t.client_id = c.client_id

LEFT JOIN sla s
    ON c.contract_tier = s.contract_tier
   AND t.priority_id = s.priority_id

LEFT JOIN escalations e
    ON t.ticket_id = e.ticket_id
