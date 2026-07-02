{{ config(
    materialized='table'
) }}

-- ============================================================================
-- Model: dim_priority
--
-- Purpose
-- -------
-- Lookup table containing ticket priority information.
--
-- Examples
-- --------
-- P1 Critical
-- P2 High
-- P3 Standard
-- P4 Low
--
-- Grain
-- -----
-- One row per Priority.
-- ============================================================================

SELECT

    priority_id,
    priority_label,
    description

FROM {{ ref('stg_priority_levels') }}