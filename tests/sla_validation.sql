-- ============================================================================
-- TEST: SLA Breach Logic Validation
-- Fails if any ticket marked breached but actually resolved within SLA
-- ============================================================================

SELECT *
FROM {{ ref('fct_tickets') }}
WHERE sla_breached = TRUE
AND resolved_within_sla = TRUE