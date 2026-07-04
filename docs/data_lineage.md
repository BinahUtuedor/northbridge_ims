<<<<<<< Updated upstream
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

=======
# NorthBridge IMS – Data Lineage

**Project:** Customer Service Ticket & SLA Optimisation System
**Database:** `NORTHBRIDGE_IMS`
**Warehouse:** Snowflake
**Transformation Tool:** dbt Cloud
**Ingestion:** Python → Amazon S3 → Airbyte
**Reporting:** Power BI

---

# 1. End-to-End Data Flow

```text
              SOURCE DATA
                  │
                  ▼
     Google Sheets / CSV Exports
                  │
                  ▼
        Python upload_to_s3.py
                  │
                  ▼
            Amazon S3 Bucket
                  │
                  ▼
             Airbyte Sync
                  │
                  ▼
     Snowflake RAW Schema
                  │
                  ▼
      dbt STAGING Schema
                  │
                  ▼
    dbt REPORTING Schema
                  │
                  ▼
             Power BI
```

---

# 2. Pipeline Overview

| Layer          | Technology          | Purpose                               |
| -------------- | ------------------- | ------------------------------------- |
| Source         | Google Sheets / CSV | Operational customer service datasets |
| Landing        | Python + Amazon S3  | Raw file storage                      |
| Ingestion      | Airbyte             | Loads source files into Snowflake RAW |
| Raw            | Snowflake RAW       | Immutable copy of source data         |
| Transformation | dbt Cloud           | Cleans, standardises and models data  |
| Reporting      | Snowflake REPORTING | Star schema for analytics             |
| Visualisation  | Power BI            | Dashboards and KPI reporting          |

---

# 3. Source Tables

Eight operational datasets are ingested.

| Source File           | Snowflake RAW Table   |
| --------------------- | --------------------- |
| agents.csv            | RAW.AGENTS            |
| clients.csv           | RAW.CLIENTS           |
| tickets.csv           | RAW.TICKETS           |
| ticket_audit_log.csv  | RAW.TICKET_AUDIT_LOG  |
| escalation_log.csv    | RAW.ESCALATION_LOG    |
| sla_definitions.csv   | RAW.SLA_DEFINITIONS   |
| priority_levels.csv   | RAW.PRIORITY_LEVELS   |
| ticket_categories.csv | RAW.TICKET_CATEGORIES |

The Python ingestion process removes UTF-8 BOM characters, preserves all source records, uploads versioned files to Amazon S3, and Airbyte synchronises them into the Snowflake RAW schema without business transformations.

---

# 4. RAW Layer

Purpose:

* Immutable landing zone
* One-to-one representation of source files
* Managed by Airbyte
* No business logic applied

All Airbyte metadata columns are retained.

Examples include:

* `_AIRBYTE_RAW_ID`
* `_AIRBYTE_EXTRACTED_AT`
* `_AIRBYTE_META`
* `_AB_SOURCE_FILE_URL`
* `_AB_SOURCE_FILE_LAST_MODIFIED`

---

# 5. STAGING Layer

Schema:

```
STAGING
```

Purpose:

* Clean raw data
* Standardise formats
* Apply light transformations
* Prepare trusted datasets for dimensional modelling

---

## STG_AGENTS

Source:

```
RAW.AGENTS
```

Transformations:

* Trim whitespace
* Standardise text
* Convert `ISACTIVE` to Boolean
* Rename columns to snake_case

Output:

```
STAGING.STG_AGENTS
```

---

## STG_CLIENTS

Source:

```
RAW.CLIENTS
```

Transformations:

* Convert contract dates
* Clean text fields
* Boolean conversion
* Standardise contract tier

Output:

```
STAGING.STG_CLIENTS
```

---

## STG_PRIORITY_LEVELS

Source:

```
RAW.PRIORITY_LEVELS
```

Transformations:

* Trim labels
* Rename columns

Output:

```
STAGING.STG_PRIORITY_LEVELS
```

---

## STG_TICKET_CATEGORIES

Source:

```
RAW.TICKET_CATEGORIES
```

Transformations:

* Boolean conversion
* Trim descriptions
* Rename fields

Output:

```
STAGING.STG_TICKET_CATEGORIES
```

---

## STG_SLA_DEFINITIONS

Source:

```
RAW.SLA_DEFINITIONS
```

Transformations:

* Convert numeric SLA hours
* Convert effective date
* Standardise contract tier

Output:

```
STAGING.STG_SLA_DEFINITIONS
```

---

## STG_ESCALATION_LOG

Source:

```
RAW.ESCALATION_LOG
```

Transformations:

* Safe timestamp parsing
* Boolean conversion
* Trim reason text

Output:

```
STAGING.STG_ESCALATION_LOG
```

---

## STG_TICKET_AUDIT_LOG

Source:

```
RAW.TICKET_AUDIT_LOG
```

Transformations:

* Standardise action types
* Parse timestamps
* Trim notes
* Clean previous/new values

Output:

```
STAGING.STG_TICKET_AUDIT_LOG
```

---

## STG_TICKETS

Source:

```
RAW.TICKETS
```

Major Transformations:

### Standardise Status Values

Examples:

* OPEN → Open
* NEW → Open
* INPROGRESS → In Progress
* RESOLVE → Resolved
* CLOSE → Closed

---

### Resolve Critical NULL Values

| Column          | Rule                 |
| --------------- | -------------------- |
| ClientID        | Default 0            |
| CategoryID      | Default 0            |
| PriorityID      | Default P3           |
| AssignedAgentID | Default 0            |
| Status          | Default Open         |
| SLADueAt        | CreatedAt + 72 hours |

---

### Timestamp Standardisation

Converted to:

* CreatedAt
* FirstResponseAt
* ResolvedAt
* SLADueAt

using Snowflake timestamp types.

---

### Boolean Standardisation

`SLABREACHED`

Converted to TRUE/FALSE.

---

### Deduplication

Duplicates removed using

```
ROW_NUMBER()
```

keeping the most recent ticket.

---

# 6. Data Quality Rules

The staging layer enforces:

* Standardised timestamps
* Standardised status values
* Standardised priority IDs
* Null handling
* Boolean conversion
* Deduplication
* Trimmed text
* Referential integrity testing

---

# 7. Reporting Layer

Schema

```
REPORTING
```

Purpose

Business-ready dimensional model for:

* Power BI
* Analysts
* SLA reporting
* Executive dashboards

---

# 8. Dimension Tables

## DIM_AGENTS

Source

```
STG_AGENTS
```

Grain

One row per agent.

Used by

* FCT_TICKETS
* Agent Performance

---

## DIM_CLIENTS

Source

```
STG_CLIENTS
```

Grain

One row per client.

Includes Unknown Client (ID = 0).

---

## DIM_PRIORITY

Source

```
STG_PRIORITY_LEVELS
```

Grain

One row per priority.

---

## DIM_TICKET_CATEGORY

Source

```
STG_TICKET_CATEGORIES
```

Grain

One row per ticket category.

---

## DIM_SLA

Source

```
STG_SLA_DEFINITIONS
```

Grain

One row per Contract Tier × Priority combination.

---

## DIM_DATE

Generated by dbt.

Contains:

* Year
* Quarter
* Month
* Week
* Fiscal Year
* Fiscal Quarter
* Weekend flag

---

# 9. Fact Tables

## FCT_TICKETS

Sources

* STG_TICKETS
* DIM_CLIENTS
* DIM_SLA
* STG_ESCALATION_LOG

Metrics include:

* Ticket age
* Response time
* Resolution time
* SLA compliance
* SLA breaches
* Escalation flag
* Resolution hours
* Ticket count

Grain

One row per ticket.

---

## FCT_TICKET_AUDIT

Sources

* STG_TICKET_AUDIT_LOG
* STG_TICKETS

Grain

One row per audit event.

---

## FCT_ESCALATIONS

Sources

* STG_ESCALATION_LOG
* STG_AGENTS

Grain

One row per escalation.

---

# 10. Reporting Marts

## RPT_SLA_KPIS

Purpose

Executive SLA dashboard.

Measures

* Total tickets
* Open tickets
* Closed tickets
* SLA breaches
* SLA breach %
* Average response time
* Average resolution time

---

## RPT_AGENT_PERFORMANCE

Purpose

Operational workforce reporting.

Measures

* Tickets assigned
* Productivity ratio
* SLA compliance
* Average resolution time
* Escalation rate
* Performance segment

---

## RPT_CLIENT_SLA

Purpose

Client account management.

Measures

* Ticket volume
* SLA compliance
* Escalation rate
* Average ticket age
* Resolution metrics

---

## RPT_TICKET_SUMMARY

Purpose

General reporting.

Aggregated by

* Date
* Priority
* Category
* Channel
* Status

---

# 11. Dimensional Model

```text
                    DIM_DATE
                        │
                        │
DIM_CLIENTS ────────────┐
                        │
DIM_AGENTS ─────────────┤
                        │
DIM_PRIORITY ───────────┤
                        │
DIM_TICKET_CATEGORY ────┤
                        │
DIM_SLA ────────────────┤
                        │
                        ▼
                  FCT_TICKETS
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
 FCT_TICKET_AUDIT       FCT_ESCALATIONS
                     │
                     ▼
      Reporting Marts
        ├── RPT_SLA_KPIS
        ├── RPT_AGENT_PERFORMANCE
        ├── RPT_CLIENT_SLA
        └── RPT_TICKET_SUMMARY
```

---

# 12. Data Quality & Testing

The project includes:

## Generic dbt Tests

* Unique
* Not Null
* Relationships
* Accepted Values

Applied across staging, dimensions and fact tables.

---

## Custom Data Tests

### SLA Validation

Ensures no ticket marked as breached was actually resolved within SLA.

---

### Escalation Consistency

Ensures every escalated ticket exists in the escalation fact table.

---

### No Negative Durations

Validates that response and resolution durations are never negative.

---

### Data Quality Audit

Checks for:

* Orphaned clients
* Orphaned agents
* Orphaned categories
* Invalid statuses
* Missing priorities

---

# 13. Schema Routing

The project uses a custom `generate_schema_name` macro to ensure dbt writes directly to the intended schemas without prefixing them with the target schema.

| dbt Folder | Snowflake Schema |
| ---------- | ---------------- |
| staging    | STAGING          |
| reporting  | REPORTING        |

This provides consistent object names across development and production environments.

---

# 14. Business Value

The reporting layer enables stakeholders to analyse:

* SLA compliance by contract tier
* Ticket resolution performance
* Agent productivity
* Client service quality
* Escalation trends
* Priority distribution
* Operational workload
* Historical ticket trends
* Customer service KPIs

The resulting star schema is optimised for Power BI, supports efficient analytical queries, and demonstrates modern ELT practices using Amazon S3, Airbyte, Snowflake, dbt Cloud, and dimensional modelling.
>>>>>>> Stashed changes
