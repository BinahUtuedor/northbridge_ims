-- ============================================================================
-- STAGING: Agents
-- Cleaned workforce dataset from RAW
-- ============================================================================

select
    agentid              as agent_id,
    trim(fullname)       as full_name,
    teamid               as team_id,
    trim(role)           as role,
    trim(specialisms)    as specialisms,
    trim(hub)            as hub,
    cast(dailycapacity as number) as daily_capacity,

    {{ cast_boolean('isactive') }} as is_active

from {{ source('northbridge_raw', 'agents') }}