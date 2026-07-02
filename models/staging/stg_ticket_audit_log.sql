{{ config(materialized='view') }}

SELECT

    LOGID                           AS log_id,
    TICKETID                        AS ticket_id,
    ACTIONBYID                      AS action_by_id,

    INITCAP(TRIM(ACTIONTYPE))       AS action_type,

    TO_TIMESTAMP_NTZ(ACTIONAT)      AS action_at,

    TRIM(PREVIOUSVALUE)             AS previous_value,
    TRIM(NEWVALUE)                  AS new_value,
    TRIM(NOTES)                     AS notes

FROM {{ source('northbridge_raw','ticket_audit_log') }}