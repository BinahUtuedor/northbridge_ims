-- Tickets marked as breached but actually within SLA thresholds

SELECT *
FROM {{ ref('fct_tickets') }}

WHERE sla_breached = TRUE
AND resolved_within_sla = TRUE