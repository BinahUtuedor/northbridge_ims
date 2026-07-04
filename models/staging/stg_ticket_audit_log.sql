-- ============================================================================
-- STAGING: Ticket Audit Log
-- ============================================================================

{{ config(materialized='view') }}

SELECT

    LOGID                           AS log_id,
    TICKETID                        AS ticket_id,
    ACTIONBYID                      AS action_by_id,

    -- Standardise action type (capitalise first letter)
    INITCAP(TRIM(ACTIONTYPE))       AS action_type,

    -- Convert timestamp safely (handles various formats)
    CASE
        WHEN TRY_TO_TIMESTAMP_NTZ(ACTIONAT) IS NOT NULL 
            THEN TRY_TO_TIMESTAMP_NTZ(ACTIONAT)
        -- Try alternative format if needed
        WHEN TRY_TO_TIMESTAMP_NTZ(ACTIONAT, 'DD/MM/YYYY HH24:MI') IS NOT NULL
            THEN TRY_TO_TIMESTAMP_NTZ(ACTIONAT, 'DD/MM/YYYY HH24:MI')
        -- Try another format
        WHEN TRY_TO_TIMESTAMP_NTZ(ACTIONAT, 'YYYY-MM-DD HH24:MI:SS') IS NOT NULL
            THEN TRY_TO_TIMESTAMP_NTZ(ACTIONAT, 'YYYY-MM-DD HH24:MI:SS')
        ELSE NULL
    END AS action_at,

    -- Clean text fields
    TRIM(PREVIOUSVALUE)             AS previous_value,
    TRIM(NEWVALUE)                  AS new_value,
    TRIM(NOTES)                     AS notes

FROM {{ source('northbridge_raw','ticket_audit_log') }}