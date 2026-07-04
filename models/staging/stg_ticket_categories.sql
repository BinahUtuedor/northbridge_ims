-- ============================================================================
-- STAGING: Ticket Categories
-- Standardised reference data for ticket classification
-- ============================================================================

select
    categoryid              as category_id,
    trim(categoryname)     as category_name,
    defaultpriorityid      as default_priority_id,

    -- FIX: correct column name from RAW = REQUIRESSPECIALIST (double S)
    {{ cast_boolean('requiresspecialist') }} as requires_specialist,

    trim(description)      as description

from {{ source('northbridge_raw', 'ticket_categories') }}