{{ config(materialized='view') }}

SELECT

    SLAID                               AS sla_id,
    CONTRACTTIER                        AS contract_tier,
    PRIORITYID                          AS priority_id,

    FIRSTRESPONSEHOURS::NUMBER(10,2)    AS first_response_hours,
    RESOLUTIONHOURS::NUMBER(10,2)       AS resolution_hours,
    ESCALATIONTRIGGERHOURS::NUMBER(10,2) AS escalation_trigger_hours,

    TO_DATE(EFFECTIVEFROM)              AS effective_from

FROM {{ source('northbridge_raw','sla_definitions') }}