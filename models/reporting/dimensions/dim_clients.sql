{{ config(
    materialized='table',
    schema='reporting'
) }}

SELECT 
    0 AS client_id,
    'Unknown Client' AS client_name,
    'Unknown' AS client_type,
    'Standard' AS contract_tier,
    0 AS account_manager_id,
    'Unknown' AS region,
    NULL AS contract_start_date,
    NULL AS contract_end_date,
    FALSE AS sla_credit_clause,
    TRUE AS is_active

UNION ALL

SELECT
    client_id,
    client_name,
    client_type,
    contract_tier,
    account_manager_id,
    region,
    contract_start_date,
    contract_end_date,
    sla_credit_clause,
    is_active
FROM {{ ref('stg_clients') }}