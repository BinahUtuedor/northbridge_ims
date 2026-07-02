-- ============================================================================
-- Model: dim_agents
-- Layer: REPORTING
--
-- Purpose:
--   Agent dimension used for workforce and SLA reporting.
--
-- Grain:
--   One row per agent.
-- ============================================================================

{{ config(materialized='table') }}

SELECT

    -- Business key
    agent_id,

    -- Agent information
    full_name,
    team_id,
    role,
    specialisms,
    hub,

    -- Capacity metrics
    daily_capacity,

    -- Active flag
    is_active

FROM {{ ref('stg_agents') }}