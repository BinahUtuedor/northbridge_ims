{{ config(materialized='view') }}

SELECT

    PRIORITYID                  AS priority_id,
    TRIM(PRIORITYLABEL)         AS priority_label,
    TRIM(DESCRIPTION)           AS description

FROM {{ source('northbridge_raw','priority_levels') }}