-- Ensure no invalid time calculations

SELECT *
FROM {{ ref('fct_tickets') }}
WHERE resolution_minutes < 0
   OR first_response_minutes < 0