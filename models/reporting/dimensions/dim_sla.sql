{{ config(
    materialized='table'
) }}

-- ============================================================================
-- Model: dim_sla
--
-- Purpose
-- -------
-- SLA lookup dimension.
--
-- Each combination of Contract Tier and Priority has
-- a defined SLA.
--
-- Grain
-- -----
-- One row per SLA Definition.
--
-- Used by
-- -------
-- • Fact Tickets
-- • SLA KPI Reporting
-- ============================================================================

SELECT

    sla_id,

    contract_tier,

    priority_id,

    first_response_hours,

    resolution_hours,

    escalation_trigger_hours,

    effective_from

FROM {{ ref('stg_sla_definitions') }}