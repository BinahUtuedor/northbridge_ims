-- ============================================================================
-- STAGING: Agents
-- ============================================================================

{{ config(
    materialized='view',
    schema='staging'
) }}

SELECT
    AGENTID              AS agent_id,
    TRIM(FULLNAME)       AS full_name,
    TEAMID               AS team_id,
    TRIM(ROLE)           AS role,
    TRIM(SPECIALISMS)    AS specialisms,
    TRIM(HUB)            AS hub,
    DAILYCAPACITY        AS daily_capacity,
    {{ cast_boolean('ISACTIVE') }} AS is_active
FROM {{ source('northbridge_raw', 'agents') }}