-- ============================================================================
-- Model: dim_clients
-- Layer: REPORTING
--
-- Purpose:
--   Client dimension containing contract and SLA information.
--
-- Grain:
--   One row per client.
-- ============================================================================

{{ config(materialized='table') }}

SELECT

    -- Business key
    client_id,

    -- Client information
    client_name,
    client_type,
    contract_tier,
    account_manager_id,
    region,

    -- Contract dates
    contract_start_date,
    contract_end_date,

    -- SLA information
    sla_credit_clause,

    -- Client status
    is_active

FROM {{ ref('stg_clients') }}