-- Ensure tickets are not stale (basic freshness check)

SELECT *
FROM {{ ref('stg_tickets') }}
WHERE created_at < DATEADD('year', -5, CURRENT_DATE())