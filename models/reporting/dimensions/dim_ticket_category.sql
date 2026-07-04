-- ============================================================================
-- Model: dim_ticket_category
-- Layer: REPORTING
--
-- Purpose:
--   Ticket category dimension for reporting and SLA analysis.
--
-- Grain:
--   One row per ticket category.
-- ============================================================================

{{ config(materialized='table') }}

SELECT

    -- Business key
    category_id,

    -- Category attributes
    category_name,
    default_priority_id,
    requires_specialist,
    description

FROM {{ ref('stg_ticket_categories') }}
