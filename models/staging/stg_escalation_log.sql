-- ============================================================================
-- STAGING: Escalation Log
-- Fixes timestamp + column naming issues
-- ============================================================================

select
    escalationid                          as escalation_id,
    ticketid                              as ticket_id,
    escalatedfrom                         as escalated_from,
    escalatedto                           as escalated_to,
    trim(escalationreason)                as escalation_reason,

    -- FIX: convert string timestamp safely
    try_to_timestamp_ntz(escalatedat, 'DD/MM/YYYY HH24:MI') as escalated_at,

    {{ cast_boolean('automatedflag') }} as automated_flag

from {{ source('northbridge_raw', 'escalation_log') }}