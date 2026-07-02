-- ============================================================================
-- FACT: Escalations
-- Grain: one row per escalation event
-- ============================================================================

select
    e.escalation_id,
    e.ticket_id,

    -- FIX: use correct staging fields (NOT agent_id)
    e.escalated_from as from_agent_id,
    e.escalated_to   as to_agent_id,

    e.escalation_reason,
    e.escalated_at,

    -- join dimensions safely
    a1.full_name as from_agent_name,
    a2.full_name as to_agent_name

from {{ ref('stg_escalation_log') }} e

left join {{ ref('stg_agents') }} a1
    on e.escalated_from = a1.agent_id

left join {{ ref('stg_agents') }} a2
    on e.escalated_to = a2.agent_id