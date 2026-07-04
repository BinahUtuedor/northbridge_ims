-- ============================================================================
-- STAGING: Ticket Categories
-- ============================================================================

{{ config(
    materialized='view',
    schema='staging'
) }}

SELECT
    CATEGORYID              AS category_id,
    TRIM(CATEGORYNAME)      AS category_name,
    DEFAULTPRIORITYID       AS default_priority_id,
    {{ cast_boolean('REQUIRESSPECIALIST') }} AS requires_specialist,
    TRIM(DESCRIPTION)       AS description
FROM {{ source('northbridge_raw', 'ticket_categories') }}