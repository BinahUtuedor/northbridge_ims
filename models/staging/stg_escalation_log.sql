-- ============================================================================
-- STAGING: Escalation Log
-- ============================================================================

{{ config(materialized='view') }}

SELECT
    escalationid                          AS escalation_id,
    ticketid                              AS ticket_id,
    escalatedfrom                         AS escalated_from,
    escalatedto                           AS escalated_to,
    trim(escalationreason)                AS escalation_reason,

    -- Convert timestamp safely (handles various formats)
    CASE
        WHEN TRY_TO_TIMESTAMP_NTZ(ESCALATEDAT) IS NOT NULL 
            THEN TRY_TO_TIMESTAMP_NTZ(ESCALATEDAT)
        -- Try alternative format if needed
        WHEN TRY_TO_TIMESTAMP_NTZ(ESCALATEDAT, 'YYYY-MM-DD HH24:MI:SS') IS NOT NULL
            THEN TRY_TO_TIMESTAMP_NTZ(ESCALATEDAT, 'YYYY-MM-DD HH24:MI:SS')
        -- Try DD/MM/YYYY format (common in sample data)
        WHEN TRY_TO_TIMESTAMP_NTZ(ESCALATEDAT, 'DD/MM/YYYY HH24:MI') IS NOT NULL
            THEN TRY_TO_TIMESTAMP_NTZ(ESCALATEDAT, 'DD/MM/YYYY HH24:MI')
        ELSE NULL
    END AS escalated_at,

    {{ cast_boolean('automatedflag') }} AS automated_flag

FROM {{ source('northbridge_raw', 'escalation_log') }}