-- ============================================================================
-- STAGING: Tickets 
-- Auto-handles missing dimension records with COALESCE
-- ============================================================================

{{ config(materialized='view') }}

WITH ranked_tickets AS (

    SELECT

        TICKETID,
        TICKETREFERENCE,
        
        -- Handle NULL foreign keys with COALESCE
        COALESCE(CLIENTID, 0) AS CLIENTID,
        
        PATIENTREF,
        
        -- Handle NULL category with COALESCE
        COALESCE(CATEGORYID, 0) AS CATEGORYID,

        -- Default to Standard Priority (3) for NULLs
        COALESCE(PRIORITYID, 3) AS PRIORITYID,

        -- Default to Unassigned (0) for NULLs
        COALESCE(CAST(ASSIGNEDAGENTID AS INTEGER), 0) AS ASSIGNEDAGENTID,

        -- Standardise status with all possible variations
        CASE
            WHEN STATUS IS NULL OR TRIM(STATUS) = '' THEN 'Open'
            WHEN UPPER(TRIM(STATUS)) IN ('OPEN', 'O', 'NEW') THEN 'Open'
            WHEN UPPER(TRIM(STATUS)) IN ('IN PROGRESS', 'INPROGRESS', 'PROGRESS', 'IP', 'PENDING') THEN 'In Progress'
            WHEN UPPER(TRIM(STATUS)) IN ('RESOLVED', 'RESOLVE', 'R', 'DONE') THEN 'Resolved'
            WHEN UPPER(TRIM(STATUS)) IN ('CLOSED', 'CLOSE', 'C') THEN 'Closed'
            ELSE INITCAP(TRIM(STATUS))
        END AS STATUS,

        -- Standardise timestamps
        TO_TIMESTAMP_NTZ(CREATEDAT) AS CREATEDAT,
        TO_TIMESTAMP_NTZ(FIRSTRESPONSEAT) AS FIRSTRESPONSEAT,
        TO_TIMESTAMP_NTZ(RESOLVEDAT) AS RESOLVEDAT,

        -- Handle NULL SLADueAt: add 72 hours (Standard SLA for P3 tickets)
        COALESCE(
            TO_TIMESTAMP_NTZ(SLADUEAT),
            DATEADD(HOUR, 72, TO_TIMESTAMP_NTZ(CREATEDAT))
        ) AS SLADUEAT,

        -- Convert to boolean
        CASE
            WHEN SLABREACHED IS NULL THEN FALSE
            WHEN UPPER(CAST(SLABREACHED AS STRING)) IN ('TRUE', '1', 'T', 'YES', 'Y') THEN TRUE
            ELSE FALSE
        END AS SLABREACHED,

        -- Clean text fields
        TRIM(CHANNEL) AS CHANNEL,
        TRIM(DESCRIPTION) AS DESCRIPTION,
        TRIM(RESOLUTIONNOTES) AS RESOLUTIONNOTES,

        -- Deduplicate (keep latest)
        ROW_NUMBER() OVER (
            PARTITION BY TICKETID
            ORDER BY TO_TIMESTAMP_NTZ(CREATEDAT) DESC
        ) AS rn

    FROM {{ source('northbridge_raw','tickets') }}

)

SELECT
    TICKETID              AS ticket_id,
    TICKETREFERENCE       AS ticket_reference,
    CLIENTID              AS client_id,
    PATIENTREF            AS patient_ref,
    CATEGORYID            AS category_id,
    PRIORITYID            AS priority_id,
    STATUS                AS status,
    ASSIGNEDAGENTID       AS assigned_agent_id,
    CREATEDAT             AS created_at,
    FIRSTRESPONSEAT       AS first_response_at,
    RESOLVEDAT            AS resolved_at,
    SLADUEAT              AS sla_due_at,
    SLABREACHED           AS sla_breached,
    CHANNEL               AS channel,
    DESCRIPTION           AS description,
    RESOLUTIONNOTES       AS resolution_notes

FROM ranked_tickets
WHERE rn = 1