-- Escalated tickets must appear in escalation fact table

SELECT t.ticket_id
FROM {{ ref('fct_tickets') }} t
LEFT JOIN {{ ref('fct_escalations') }} e
    ON t.ticket_id = e.ticket_id
WHERE t.escalated_flag = TRUE
AND e.ticket_id IS NULL