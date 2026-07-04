-- ============================================================================
-- SEED: Unknown Records for Dimension Tables
-- ============================================================================

-- Add Unknown Client (ID = 0)
INSERT INTO {{ ref('dim_clients') }} (
    client_id, client_name, client_type, contract_tier, 
    account_manager_id, region, contract_start_date, contract_end_date,
    sla_credit_clause, is_active
)
SELECT 
    0, 'Unknown Client', 'Unknown', 'Standard', 
    0, 'Unknown', NULL, NULL,
    FALSE, TRUE
WHERE NOT EXISTS (SELECT 1 FROM {{ ref('dim_clients') }} WHERE client_id = 0);

-- Add Unassigned Agent (ID = 0)
INSERT INTO {{ ref('dim_agents') }} (
    agent_id, full_name, team_id, role, 
    specialisms, hub, daily_capacity, is_active
)
SELECT 
    0, 'Unassigned', 0, 'Unassigned', 
    'None', 'Unknown', 0, TRUE
WHERE NOT EXISTS (SELECT 1 FROM {{ ref('dim_agents') }} WHERE agent_id = 0);

-- Add Unknown Priority (ID = 0)
INSERT INTO {{ ref('dim_priority') }} (
    priority_id, priority_label, description
)
SELECT 
    0, 'Unknown', 'Unknown priority level'
WHERE NOT EXISTS (SELECT 1 FROM {{ ref('dim_priority') }} WHERE priority_id = 0);

-- Add Unknown Category (ID = 0)
INSERT INTO {{ ref('dim_ticket_category') }} (
    category_id, category_name, default_priority_id, 
    requires_specialist, description
)
SELECT 
    0, 'Unknown Category', 3, 
    FALSE, 'Unknown ticket category'
WHERE NOT EXISTS (SELECT 1 FROM {{ ref('dim_ticket_category') }} WHERE category_id = 0);

-- Add Default SLA (ID = 0)
INSERT INTO {{ ref('dim_sla') }} (
    sla_id, contract_tier, priority_id, 
    first_response_hours, resolution_hours, escalation_trigger_hours, effective_from
)
SELECT 
    0, 'Standard', 3, 
    8, 72, 60, '2023-01-01'
WHERE NOT EXISTS (SELECT 1 FROM {{ ref('dim_sla') }} WHERE sla_id = 0);