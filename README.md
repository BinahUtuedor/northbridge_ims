# 🚀 NorthBridge IMS

### End-to-End Data Engineering Pipeline for Customer Service Ticket & SLA Optimisation

![Amazon S3](https://img.shields.io/badge/AWS-S3-orange)
![Airbyte](https://img.shields.io/badge/Airbyte-ELT-purple)
![Snowflake](https://img.shields.io/badge/Snowflake-Data_Warehouse-blue)
![dbt](https://img.shields.io/badge/dbt-Analytics_Engineering-orange)
![SQL](https://img.shields.io/badge/SQL-Transformation-success)
![Power BI](https://img.shields.io/badge/Power_BI-Analytics-yellow)

---

# 📖 Project Overview

NorthBridge IMS is an end-to-end cloud data engineering and analytics engineering project that demonstrates the implementation of a modern ELT architecture for monitoring customer service operations and Service Level Agreement (SLA) performance within a healthcare organisation.

The project ingests operational datasets from Amazon S3 into Snowflake using Airbyte, transforms raw data into clean, analytics-ready models using dbt, and delivers a dimensional reporting layer optimised for Power BI.

---

# 🎯 Business Objectives

The platform enables business users to:

- Monitor customer service operations
- Measure SLA compliance
- Track response and resolution performance
- Analyse agent productivity
- Monitor ticket escalations
- Evaluate client service performance
- Deliver trusted datasets for business intelligence

---

# 🏗️ Solution Architecture

```text
Google Drive Excel Workbook
            │
            ▼
      Amazon S3 Data Lake
            │
            ▼
        Airbyte ELT
            │
            ▼
   Snowflake RAW Schema
            │
            ▼
 dbt STAGING (Cleaning)
            │
            ▼
dbt REPORTING (Star Schema)
            │
            ▼
        Power BI
```

---

# ⚙️ Technology Stack

| Layer | Technology |
|--------|------------|
| Cloud Storage | Amazon S3 |
| Data Integration | Airbyte |
| Data Warehouse | Snowflake |
| Transformation | dbt Cloud |
| Language | SQL |
| Version Control | Git & GitHub |
| Reporting | Power BI |

---

# 📂 Dataset Summary

| Dataset | Rows |
|----------|-----:|
| Tickets | 3,500 |
| Ticket Audit Log | 17,751 |
| Escalation Log | 464 |
| Clients | 80 |
| Agents | 120 |
| SLA Definitions | 12 |
| Ticket Categories | 5 |
| Priority Levels | 4 |

**Ticket Date Range:** January 2023 – March 2025

---

# 🏗️ Data Warehouse Architecture

```text
RAW
│
├── AGENTS
├── CLIENTS
├── TICKETS
├── TICKET_AUDIT_LOG
├── ESCALATION_LOG
├── SLA_DEFINITIONS
├── PRIORITY_LEVELS
└── TICKET_CATEGORIES
        │
        ▼
STAGING
│
├── STG_AGENTS
├── STG_CLIENTS
├── STG_TICKETS
├── STG_TICKET_AUDIT_LOG
├── STG_ESCALATION_LOG
├── STG_PRIORITY_LEVELS
├── STG_SLA_DEFINITIONS
└── STG_TICKET_CATEGORIES
        │
        ▼
REPORTING
```

---

# 🧹 Staging Layer

The dbt staging layer applies light transformations while preserving source granularity.

### Transformations

- Standardised column names to `snake_case`
- Removed Airbyte metadata columns
- Casted columns to appropriate data types
- Standardised timestamps
- Converted Boolean fields
- Trimmed text values
- Standardised ticket status values
- Resolved null values
- Deduplicated tickets using `ROW_NUMBER()`
- Applied dbt data quality tests

The staging layer performs no joins or KPI calculations, ensuring clean and reusable models for downstream analytics.

---

# 📊 Reporting Layer

The reporting layer implements a Kimball-style dimensional model consisting of dimensions, fact tables, and reporting marts.

## Dimensions

- dim_agents
- dim_clients
- dim_priority
- dim_ticket_category
- dim_sla
- dim_date

## Facts

- fct_tickets
- fct_ticket_audit
- fct_escalations

## Reporting Marts

- rpt_sla_kpis
- rpt_agent_performance
- rpt_client_sla
- rpt_ticket_summary

---

# ⭐ Star Schema

```text
               dim_clients
                    │
                    │
dim_agents ─────────┤
                    │
dim_priority ───────┤
                    │
dim_ticket_category─┤
                    │
dim_sla ────────────┤
                    │
               fct_tickets
              /            \
             /              \
fct_ticket_audit     fct_escalations
```

---

# 📈 Business Metrics

The warehouse calculates reusable business metrics including:

- Ticket Volume
- SLA Breach Rate
- SLA Compliance
- Response Time
- Resolution Time
- Resolution SLA Compliance
- Response SLA Compliance
- Ticket Age
- Escalation Rate
- Agent Productivity
- Client SLA Performance
- Ticket Status Distribution

---

# ✅ Data Quality

The project includes both built-in dbt tests and custom SQL validation tests.

### dbt Tests

- Unique keys
- Not null constraints
- Referential integrity
- Relationship validation

### Custom SQL Tests

- SLA validation
- Escalation consistency
- Negative duration detection
- Ticket data freshness

---

# 📂 Project Structure

```text
northbridge-ims/

├── models/
│   ├── sources/
│   ├── staging/
│   └── reporting/
│       ├── dimensions/
│       ├── facts/
│       └── marts/
│
├── macros/
├── tests/
├── seeds/
├── dbt_project.yml
└── README.md
```

---

# 🚀 Running the Project

```bash
dbt debug
dbt deps
dbt seed
dbt run
dbt test
dbt docs generate
dbt docs serve
```

---

# 📚 Data Lineage

```text
Amazon S3
     │
     ▼
Airbyte
     │
     ▼
Snowflake RAW
     │
     ▼
dbt STAGING
     │
     ▼
Dimensions + Facts
     │
     ▼
Reporting Marts
     │
     ▼
Power BI
```

---

# 📊 Key Deliverables

- End-to-end ELT pipeline
- Amazon S3 data lake
- Automated Airbyte ingestion
- Snowflake cloud data warehouse
- dbt analytics engineering project
- Fully modelled staging layer
- Star schema dimensional model
- Analytics reporting marts
- Data quality framework
- Auto-generated dbt documentation
- Power BI-ready reporting models

---

# 🏆 Skills Demonstrated

- Data Engineering
- Analytics Engineering
- Cloud Data Warehousing
- ELT Pipeline Development
- Snowflake SQL
- dbt
- Dimensional Modelling
- Star Schema Design
- Data Quality Testing
- Data Lineage
- Business Intelligence
- Power BI
- Git & GitHub

---

# 👤 Author

**Binah Utuedor**

**Data Engineer | Analytics Engineer | Business Intelligence Developer**

This project demonstrates the design and implementation of a production-style cloud data engineering solution using Amazon S3, Airbyte, Snowflake, dbt, SQL, and Power BI. It showcases modern ELT architecture, layered data modelling, dimensional design, analytics engineering, and business intelligence reporting following industry best practices.