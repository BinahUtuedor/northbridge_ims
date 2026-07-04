{{ config(materialized='view') }}

WITH ranked_tickets AS (

    SELECT

        TICKETID,  
        TICKETREFERENCE,
        CLIENTID,
        PATIENTREF,
        CATEGORYID,

        COALESCE(PRIORITYID, 3) AS PRIORITYID,

        CASE
            WHEN STATUS IS NULL THEN 'Open'
            WHEN UPPER(TRIM(STATUS)) = 'OPEN' THEN 'Open'
            WHEN UPPER(TRIM(STATUS)) = 'IN PROGRESS' THEN 'In Progress'
            WHEN UPPER(TRIM(STATUS)) = 'RESOLVED' THEN 'Resolved'
            WHEN UPPER(TRIM(STATUS)) = 'CLOSED' THEN 'Closed'
            ELSE INITCAP(TRIM(STATUS))
        END AS STATUS,

        ASSIGNEDAGENTID,

        TO_TIMESTAMP_NTZ(CREATEDAT) AS CREATEDAT,
        TO_TIMESTAMP_NTZ(FIRSTRESPONSEAT) AS FIRSTRESPONSEAT,
        TO_TIMESTAMP_NTZ(RESOLVEDAT) AS RESOLVEDAT,

        COALESCE(
            TO_TIMESTAMP_NTZ(SLADUEAT),
            DATEADD(HOUR, 72, TO_TIMESTAMP_NTZ(CREATEDAT))
        ) AS SLADUEAT,

        SLABREACHED::BOOLEAN AS SLABREACHED,

        TRIM(CHANNEL) AS CHANNEL,
        TRIM(DESCRIPTION) AS DESCRIPTION,
        TRIM(RESOLUTIONNOTES) AS RESOLUTIONNOTES,

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