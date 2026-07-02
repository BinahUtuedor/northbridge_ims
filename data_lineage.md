# 📚 Data Lineage

## NorthBridge IMS

### End-to-End Data Lineage Documentation

---

# Overview

This document describes the end-to-end data lineage for the **NorthBridge IMS Customer Service Ticket & SLA Optimisation System**.

The solution follows a modern ELT architecture where raw operational data is ingested into Snowflake, transformed using dbt, and exposed through dimensional models and reporting marts for analytics and business intelligence.

---

# High-Level Data Flow

```text
Google Drive Excel Workbook
            │
            ▼
      CSV Exports
            │
            ▼
      Amazon S3 Data Lake
            │
            ▼
      Airbyte ELT Pipeline
            │
            ▼
   Snowflake RAW Schema
            │
            ▼
     dbt STAGING Layer
            │
            ▼
  dbt REPORTING Layer
            │
            ▼
      Power BI Dashboards
```

---

# Source Layer

The original dataset was supplied as a multi-sheet Excel workbook.

Each worksheet was exported as a CSV file and uploaded into Amazon S3.

## Source Datasets

| Dataset | Purpose |
|----------|---------|
| Agents | Customer service staff information |
| Clients | Customer contract information |
| Tickets | Core customer service tickets |
| Ticket Audit Log | Ticket lifecycle events |
| Escalation Log | Ticket escalations |
| SLA Definitions | SLA rules |
| Ticket Categories | Ticket classifications |
| Priority Levels | Ticket priorities |

---

# Amazon S3

The CSV files are organised into separate folders.

```text
northbridge-ims-data-lake/

raw/

├── agents/
├── clients/
├── escalation_log/
├── priority_levels/
├── sla_definitions/
├── ticket_audit_log/
├── ticket_categories/
└── tickets/
```

Purpose

- Durable cloud storage
- Landing zone
- Source for Airbyte
- Version-controlled raw files

---

# Airbyte ELT

Airbyte extracts data from Amazon S3 and loads it directly into Snowflake.

## Destination

```text
Database:
NORTHBRIDGE_IMS

Schema:
RAW
```

Airbyte automatically creates one table for each dataset while preserving source fidelity.

---

# RAW Layer

The RAW schema stores an unmodified copy of the source data.

## RAW Tables

| Table |
|--------|
| AGENTS |
| CLIENTS |
| TICKETS |
| TICKET_AUDIT_LOG |
| ESCALATION_LOG |
| SLA_DEFINITIONS |
| PRIORITY_LEVELS |
| TICKET_CATEGORIES |

The RAW layer also stores Airbyte metadata including:

- _AIRBYTE_RAW_ID
- _AIRBYTE_EXTRACTED_AT
- _AIRBYTE_META
- _AIRBYTE_GENERATION_ID
- _AB_SOURCE_FILE_URL
- _AB_SOURCE_FILE_LAST_MODIFIED

No business transformations occur within this layer.

---

# STAGING Layer

The STAGING layer performs light transformations and standardisation.

## Staging Models

| Model | Source |
|---------|---------|
| stg_agents | RAW.AGENTS |
| stg_clients | RAW.CLIENTS |
| stg_tickets | RAW.TICKETS |
| stg_ticket_audit_log | RAW.TICKET_AUDIT_LOG |
| stg_escalation_log | RAW.ESCALATION_LOG |
| stg_priority_levels | RAW.PRIORITY_LEVELS |
| stg_sla_definitions | RAW.SLA_DEFINITIONS |
| stg_ticket_categories | RAW.TICKET_CATEGORIES |

---

# Staging Transformations

The staging layer performs:

- Remove Airbyte metadata columns
- Convert column names to snake_case
- Data type casting
- Timestamp standardisation
- Boolean conversion
- Text trimming
- Status standardisation
- Null handling
- Ticket deduplication
- Basic data quality validation

No joins or KPI calculations occur in this layer.

---

# Reporting Layer

The reporting layer implements a Kimball dimensional model.

---

# Dimension Lineage

## dim_agents

```text
RAW.AGENTS
      │
      ▼
stg_agents
      │
      ▼
dim_agents
```

---

## dim_clients

```text
RAW.CLIENTS
      │
      ▼
stg_clients
      │
      ▼
dim_clients
```

---

## dim_priority

```text
RAW.PRIORITY_LEVELS
          │
          ▼
stg_priority_levels
          │
          ▼
dim_priority
```

---

## dim_ticket_category

```text
RAW.TICKET_CATEGORIES
           │
           ▼
stg_ticket_categories
           │
           ▼
dim_ticket_category
```

---

## dim_sla

```text
RAW.SLA_DEFINITIONS
          │
          ▼
stg_sla_definitions
          │
          ▼
dim_sla
```

---

## dim_date

```text
Generated Calendar
        │
        ▼
dim_date
```

The calendar dimension is generated entirely within dbt and is independent of source data.

---

# Fact Lineage

## fct_tickets

```text
RAW.TICKETS
      │
      ▼
stg_tickets
      │
      ├──────────────┐
      │              │
      ▼              ▼
dim_clients      dim_sla
      │              │
      └──────┬───────┘
             │
             ▼
     fct_tickets
```

Additional lookups

- dim_priority
- dim_ticket_category
- dim_agents
- fct_escalations

---

## fct_ticket_audit

```text
RAW.TICKET_AUDIT_LOG
            │
            ▼
stg_ticket_audit_log
            │
            ▼
     fct_ticket_audit
```

---

## fct_escalations

```text
RAW.ESCALATION_LOG
          │
          ▼
stg_escalation_log
          │
          ▼
    fct_escalations
```

---

# Reporting Mart Lineage

## SLA KPI Mart

```text
dim_priority
        │
        ▼
fct_tickets
        │
        ▼
dim_date
        │
        ▼
rpt_sla_kpis
```

---

## Agent Performance Mart

```text
dim_agents
      │
      ▼
fct_tickets
      │
      ▼
rpt_agent_performance
```

---

## Client SLA Mart

```text
dim_clients
      │
      ▼
fct_tickets
      │
      ▼
rpt_client_sla
```

---

## Ticket Summary Mart

```text
dim_priority
dim_ticket_category
dim_date
        │
        ▼
fct_tickets
        │
        ▼
rpt_ticket_summary
```

---

# Complete Lineage Diagram

```text
                               Google Drive
                                     │
                                     ▼
                             Excel Workbook
                                     │
                                     ▼
                              CSV Exports
                                     │
                                     ▼
                               Amazon S3
                                     │
                                     ▼
                                Airbyte
                                     │
                                     ▼
                          Snowflake RAW Schema
                                     │
      ┌───────────────┬──────────────┼──────────────┐
      ▼               ▼              ▼              ▼
   AGENTS         CLIENTS        TICKETS      AUDIT LOG
      │               │              │              │
      ▼               ▼              ▼              ▼
stg_agents     stg_clients     stg_tickets   stg_ticket_audit_log
      │               │              │              │
      ▼               ▼              ▼              ▼
dim_agents     dim_clients     fct_tickets   fct_ticket_audit
                      │              │
                      │              ▼
                      │      fct_escalations
                      │              │
                      └──────┬───────┘
                             ▼
                     Reporting Marts
                             │
         ┌──────────┬─────────┬──────────┬──────────┐
         ▼          ▼         ▼          ▼
  SLA KPIs   Agent Performance Client SLA Ticket Summary
                             │
                             ▼
                          Power BI
```

---

# Data Quality Controls

The data lineage incorporates quality controls throughout the pipeline.

## Airbyte

- Source validation
- Schema validation
- Metadata capture

## dbt Staging

- Data type casting
- Null handling
- Deduplication
- Status standardisation

## dbt Tests

- Unique keys
- Not null constraints
- Relationship tests

## Custom SQL Tests

- SLA validation
- Escalation consistency
- Negative duration detection
- Data freshness

---

# Lineage Summary

| Layer | Purpose |
|--------|---------|
| Source | Operational data collection |
| Amazon S3 | Cloud storage and landing zone |
| Airbyte | Automated ELT ingestion |
| RAW | Immutable source copy |
| STAGING | Data cleaning and standardisation |
| DIMENSIONS | Business lookup entities |
| FACTS | Business events and KPIs |
| REPORTING MARTS | Analytics-ready datasets |
| Power BI | Business intelligence and dashboards |

---

# Key Design Principles

- Modern ELT architecture
- Layered data warehouse design
- Kimball star schema
- Reusable staging models
- Conformed dimensions
- Analytics-ready fact tables
- Automated data quality testing
- End-to-end lineage and traceability
- Power BI-optimised reporting models