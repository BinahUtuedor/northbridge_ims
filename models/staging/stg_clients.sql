-- ============================================================================
-- STAGING: Clients
-- ============================================================================

{{ config(
    materialized='view',
    schema='staging'
) }}

SELECT
    CLIENTID                     AS client_id,
    TRIM(CLIENTNAME)             AS client_name,
    TRIM(CLIENTTYPE)             AS client_type,
    TRIM(CONTRACTTIER)           AS contract_tier,
    ACCOUNTMANAGERID             AS account_manager_id,
    TRIM(REGION)                 AS region,
    TO_DATE(CONTRACTSTARTDATE)   AS contract_start_date,
    TO_DATE(CONTRACTENDDATE)     AS contract_end_date,
    {{ cast_boolean('SLACREDITCLAUSE') }} AS sla_credit_clause,
    {{ cast_boolean('ISACTIVE') }}        AS is_active
FROM {{ source('northbridge_raw', 'clients') }}