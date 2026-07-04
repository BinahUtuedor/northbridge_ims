# 🔗 NorthBridge IMS — Data Lineage

## Overview
This document describes the end-to-end data flow from source systems to analytics-ready reporting models.

The system follows a modern ELT architecture using:
- Airbyte (ingestion)
- Snowflake (storage)
- dbt (transformation)
- Power BI (visualisation)

---

# 🏗️ END-TO-END PIPELINE

```text
Source Systems (MedDesk CRM, operational exports)
        ↓
Amazon S3 (Raw file storage)
        ↓
Airbyte (Automated ingestion)
        ↓
Snowflake RAW schema
        ↓
dbt STAGING layer
    - standardisation
    - type casting
    - deduplication
    - null handling
        ↓
dbt FACT layer
    - business logic
    - SLA calculations
    - lifecycle metrics
    - escalation tracking
        ↓
dbt DIMENSION layer
    - conformed business entities
    - reusable across models
        ↓
dbt REPORTING MARTS
    - SLA KPIs
    - Agent performance
    - Client performance
    - Ticket summaries
        ↓
Power BI Dashboards

🧠 MODEL DEPENDENCY LINEAGE
FACT TABLE DEPENDENCIES
fct_tickets

Depends on:

stg_tickets
dim_clients
dim_sla
fct_escalations (for escalation flag enrichment)
fct_escalations

Depends on:

stg_escalation_log
stg_tickets
dim_clients
fct_ticket_audit

Depends on:

stg_ticket_audit_log
stg_tickets

📊 REPORTING LAYER DEPENDENCIES
rpt_sla_kpis

Depends on:

fct_tickets
dim_priority
dim_date
rpt_agent_performance

Depends on:

fct_tickets
dim_agents
rpt_client_sla

Depends on:

fct_tickets
dim_clients
rpt_ticket_summary

Depends on:

fct_tickets
dim_priority
dim_ticket_category
dim_date

🔄 DATA FLOW PRINCIPLES
Raw data is never exposed to BI tools
All transformations occur in dbt
Facts store business logic and KPIs
Dimensions provide consistent business definitions
Marts are optimized for analytics consumption

🎯 DESIGN PATTERN

This architecture follows a Kimball-style star schema design:

Fact tables at the center
Conformed dimensions shared across facts
Reporting marts for BI performance optimization

📌 SUMMARY

This lineage ensures full traceability from raw ingestion to final BI dashboards, supporting:

auditability
reproducibility
transparency
scalable analytics

