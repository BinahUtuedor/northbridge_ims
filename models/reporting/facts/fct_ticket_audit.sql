-- ============================================================================
-- FACT: Ticket Audit (FIXED)
-- ============================================================================

{{ config(materialized='table') }}

WITH audit AS (
    SELECT * FROM {{ ref('stg_ticket_audit_log') }}
),

tickets AS (
    SELECT 
        ticket_id,
        client_id,
        assigned_agent_id
    FROM {{ ref('stg_tickets') }}
)

SELECT

    a.log_id,
    a.ticket_id,
    
    COALESCE(t.client_id, 0) AS client_id,
    COALESCE(t.assigned_agent_id, 0) AS agent_id,

    a.action_type,
    a.action_by_id,
    a.action_at,
    a.previous_value,
    a.new_value,
    a.notes,
    CAST(a.action_at AS DATE) AS action_date,
    1 AS audit_event_count

FROM audit a

LEFT JOIN tickets t
    ON a.ticket_id = t.ticket_id
    