-- ============================================================================
-- FACT: Escalations (FIXED)
-- ============================================================================

{{ config(materialized='table') }}

WITH escalations AS (
    SELECT * FROM {{ ref('stg_escalation_log') }}
),

agents AS (
    SELECT 
        agent_id,
        full_name
    FROM {{ ref('stg_agents') }}
)

SELECT
    e.escalation_id,
    e.ticket_id,

    COALESCE(e.escalated_from, 0) AS from_agent_id,
    COALESCE(e.escalated_to, 0)   AS to_agent_id,

    e.escalation_reason,
    e.escalated_at,

    COALESCE(a1.full_name, 'Unknown Agent') AS from_agent_name,
    COALESCE(a2.full_name, 'Unknown Agent') AS to_agent_name

FROM escalations e

LEFT JOIN agents a1
    ON e.escalated_from = a1.agent_id

LEFT JOIN agents a2
    ON e.escalated_to = a2.agent_id