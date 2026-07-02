-- ============================================================================
-- STAGING: Clients
-- ============================================================================

select
    clientid                     as client_id,
    trim(clientname)             as client_name,
    trim(clienttype)             as client_type,
    trim(contracttier)           as contract_tier,
    accountmanagerid             as account_manager_id,
    trim(region)                 as region,

    to_date(contractstartdate)   as contract_start_date,
    to_date(contractenddate)     as contract_end_date,

    {{ cast_boolean('slacreditclause') }} as sla_credit_clause,
    {{ cast_boolean('isactive') }}        as is_active

from {{ source('northbridge_raw', 'clients') }}
