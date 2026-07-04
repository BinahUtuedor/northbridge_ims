{{ config(
    materialized='table'
) }}

WITH calendar AS (

    SELECT
        DATEADD(
            day,
            ROW_NUMBER() OVER (ORDER BY seq4()) - 1,
            '2023-01-01'
        ) AS calendar_date
    FROM TABLE(GENERATOR(ROWCOUNT => 4000))

)

SELECT

    ----------------------------------------------------------------------------
    -- Primary Key
    ----------------------------------------------------------------------------
    calendar_date AS date_key,

    ----------------------------------------------------------------------------
    -- Standard Calendar Attributes
    ----------------------------------------------------------------------------
    YEAR(calendar_date)      AS year,
    QUARTER(calendar_date)   AS quarter,
    MONTH(calendar_date)     AS month,
    MONTHNAME(calendar_date) AS month_name,
    WEEK(calendar_date)      AS week,
    DAY(calendar_date)       AS day,
    DAYNAME(calendar_date)   AS day_name,

    ----------------------------------------------------------------------------
    -- BI Friendly Fields
    ----------------------------------------------------------------------------
    CONCAT(YEAR(calendar_date), '-', LPAD(MONTH(calendar_date),2,'0')) AS year_month,

    ----------------------------------------------------------------------------
    -- Week Intelligence
    ----------------------------------------------------------------------------
    DATE_TRUNC('WEEK', calendar_date) AS week_start_date,
    DATEADD('day', 6, DATE_TRUNC('WEEK', calendar_date)) AS week_end_date,

    ----------------------------------------------------------------------------
    -- Fiscal Year (April start – common UK standard)
    ----------------------------------------------------------------------------
    CASE
        WHEN MONTH(calendar_date) >= 4
        THEN YEAR(calendar_date)
        ELSE YEAR(calendar_date) - 1
    END AS fiscal_year,

    CASE
        WHEN MONTH(calendar_date) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(calendar_date) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(calendar_date) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS fiscal_quarter,

    ----------------------------------------------------------------------------
    -- Weekend Flag
    ----------------------------------------------------------------------------
    CASE
        WHEN DAYOFWEEK(calendar_date) IN (1,7)
        THEN TRUE ELSE FALSE
    END AS is_weekend

FROM calendar