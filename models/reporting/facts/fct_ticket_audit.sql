{{ config(
    materialized='table'
) }}

-- ============================================================================
-- Model: fct_ticket_audit
--
-- Purpose
-- -------
-- Stores every ticket lifecycle event.
--
-- Grain
-- -----
-- One row per audit event.
--
-- Business Use Cases
-- ------------------
-- • Workflow Analysis
-- • Ticket Lifecycle
-- • Status Changes
-- • Operational Monitoring
-- ============================================================================

WITH audit AS (

    SELECT *
    FROM {{ ref('stg_ticket_audit_log') }}

),

tickets AS (

    SELECT *
    FROM {{ ref('stg_tickets') }}

)

SELECT

    --------------------------------------------------------------------------
    -- Primary Key
    --------------------------------------------------------------------------

    a.log_id,

    --------------------------------------------------------------------------
    -- Foreign Keys
    --------------------------------------------------------------------------

    a.ticket_id,
    t.client_id,
    t.assigned_agent_id AS agent_id,

    --------------------------------------------------------------------------
    -- Audit Details
    --------------------------------------------------------------------------

    a.action_type,
    a.action_by_id,
    a.action_at,

    a.previous_value,
    a.new_value,

    a.notes,

    --------------------------------------------------------------------------
    -- Date Dimension Key
    --------------------------------------------------------------------------

    CAST(a.action_at AS DATE) AS action_date,

    --------------------------------------------------------------------------
    -- Fact Measure
    --------------------------------------------------------------------------

    1 AS audit_event_count

FROM audit a

LEFT JOIN tickets t

ON a.ticket_id = t.ticket_id