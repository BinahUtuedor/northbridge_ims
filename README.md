# 🚀 NorthBridge IMS

## End-to-End Cloud ELT Pipeline for Customer Service Ticket & SLA Optimisation

![Python](https://img.shields.io/badge/Python-3.11-blue)
![Amazon S3](https://img.shields.io/badge/AWS-S3-orange)
![Airbyte](https://img.shields.io/badge/Airbyte-ELT-purple)
![Snowflake](https://img.shields.io/badge/Snowflake-Data_Warehouse-29B5E8)
![dbt Cloud](https://img.shields.io/badge/dbt-Analytics_Engineering-FF694B)
![SQL](https://img.shields.io/badge/SQL-Transformation-success)
![Power BI](https://img.shields.io/badge/Power_BI-Business_Intelligence-yellow)
![GitHub](https://img.shields.io/badge/Git-Version_Control-black)
![License](https://img.shields.io/badge/License-MIT-green)

---

# 📖 Executive Summary

NorthBridge IMS is a production-style cloud data engineering project that demonstrates the design, implementation, and documentation of a modern **ELT (Extract, Load, Transform)** data platform for analysing customer service operations within a healthcare organisation.

The project simulates a real-world enterprise environment where operational customer service data is ingested from source files into a cloud data warehouse before being transformed into trusted analytical datasets for business intelligence.

The solution follows modern analytics engineering principles by separating ingestion, storage, transformation, modelling, testing, and reporting into clearly defined layers.

The completed platform includes:

* Automated data ingestion using Python
* Cloud storage using Amazon S3
* ELT orchestration with Airbyte Cloud
* Snowflake cloud data warehouse
* Layered dbt transformations
* Kimball dimensional modelling
* Automated data quality testing
* Comprehensive project documentation
* Power BI-ready reporting models

The project demonstrates industry-standard practices in cloud data engineering, analytics engineering, dimensional modelling, and business intelligence.

---

# 🎯 Business Problem

Healthcare organisations receive thousands of customer support requests every month across multiple service channels.

Without a centralised analytics platform, it becomes difficult to answer critical operational questions such as:

* Are contractual SLA targets being met?
* Which clients experience the highest number of SLA breaches?
* Which support agents are handling the largest workloads?
* How long do tickets remain unresolved?
* Which ticket categories generate the greatest operational burden?
* How frequently are tickets escalated?
* Which contract tiers receive the best service levels?

Operational source systems are typically designed for transactional processing rather than analytical reporting.

As a result, management often lacks reliable, consistent, and timely operational insights.

---

# 💡 Solution

NorthBridge IMS addresses these challenges by implementing a modern ELT architecture that separates operational processing from analytical reporting.

The platform:

* Centralises customer service data
* Preserves immutable raw source data
* Cleans and standardises operational datasets
* Applies consistent business rules
* Builds a dimensional warehouse using Kimball methodology
* Produces reusable reporting marts
* Enables interactive dashboards in Power BI

The resulting warehouse provides a trusted, scalable foundation for operational reporting and decision support.

---

# 🏗️ Solution Architecture

```text
                    Operational Data
                  (Google Sheets / CSV)
                           │
                           ▼
                 Python Ingestion Script
                  (upload_to_s3.py)
                           │
                           ▼
                    Amazon S3 Data Lake
                           │
                           ▼
                      Airbyte Cloud
                           │
                           ▼
               Snowflake RAW Schema
             (Immutable Landing Layer)
                           │
                           ▼
               dbt STAGING Schema
        (Cleaning & Standardisation Layer)
                           │
                           ▼
             dbt REPORTING Schema
      (Dimensions, Facts & Reporting Marts)
                           │
                           ▼
                  Power BI Dashboards
```

---

# 🏛️ Data Warehouse Architecture

The warehouse follows a layered Medallion-style architecture that separates ingestion from transformation and reporting.

```text
                 RAW
                  │
                  ▼
              STAGING
                  │
                  ▼
             REPORTING
                  │
                  ▼
             Business Users
```

Each layer has a single, well-defined responsibility.

| Layer     | Purpose                                   |
| --------- | ----------------------------------------- |
| RAW       | Immutable landing zone for Airbyte data   |
| STAGING   | Cleaning, validation and standardisation  |
| REPORTING | Dimensional warehouse and reporting marts |

This architecture improves maintainability, traceability, testing, and scalability.

---

# ⚙️ Technology Stack

| Layer           | Technology          | Purpose                           |
| --------------- | ------------------- | --------------------------------- |
| Programming     | Python              | Data ingestion and file upload    |
| Cloud Storage   | Amazon S3           | Data lake for source files        |
| ELT Integration | Airbyte Cloud       | Automated data ingestion          |
| Data Warehouse  | Snowflake           | Cloud data warehouse              |
| Transformation  | dbt Cloud           | SQL transformations and modelling |
| Query Language  | SQL                 | Data transformation               |
| Version Control | Git & GitHub        | Source control                    |
| Reporting       | Power BI            | Dashboards and analytics          |
| Documentation   | Markdown & dbt Docs | Technical documentation           |

---

# 🏥 Business Domain

The project models customer service operations for a healthcare technology organisation supporting hospitals and healthcare providers.

The warehouse analyses:

* Customer support tickets
* SLA compliance
* Ticket escalations
* Agent performance
* Client service quality
* Operational workload
* Ticket lifecycle
* Response and resolution times

---

# 📂 Source Datasets

Eight operational datasets form the basis of the warehouse.

| Dataset           | Description               | Approx. Rows |
| ----------------- | ------------------------- | -----------: |
| Tickets           | Customer support requests |        3,500 |
| Ticket Audit Log  | Ticket history            |       17,751 |
| Escalation Log    | Ticket escalations        |          464 |
| Agents            | Customer service staff    |          120 |
| Clients           | Healthcare organisations  |           80 |
| SLA Definitions   | Contract SLA rules        |           12 |
| Ticket Categories | Service categories        |            5 |
| Priority Levels   | Ticket priorities         |            4 |

**Ticket Date Range**

January 2023 – March 2025

---

# 🌟 Key Features

## Data Engineering

* Automated Python ingestion
* Cloud-native data lake
* Automated ELT with Airbyte
* Snowflake cloud warehouse
* Layered warehouse architecture
* Modern ELT implementation

---

## Analytics Engineering

* dbt Cloud project
* Modular SQL models
* Layered transformations
* Source freshness tracking
* Automated documentation
* Data lineage
* Data quality testing

---

## Data Modelling

* Kimball dimensional modelling
* Star schema
* Slowly changing business dimensions
* Fact tables
* Reporting marts
* Business KPI calculations

---

## Business Intelligence

* Executive reporting
* Operational dashboards
* SLA monitoring
* Agent productivity analysis
* Client performance reporting
* Power BI-ready semantic layer

---

# 📁 Repository Structure

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
│
├── tests/
│
├── docs/
│   ├── DATA_LINEAGE.md
│   ├── DATA_DICTIONARY.md
│   └── images/
│
├── seeds/
│
├── snapshots/
│
├── analyses/
│
├── upload_to_s3.py
├── packages.yml
├── dbt_project.yml
├── profiles.yml.example
├── .env.example
└── README.md
```

---

# 📌 Project Highlights

This project demonstrates the complete lifecycle of a modern cloud data platform, including:

* Source system ingestion
* Cloud storage
* Automated ELT
* Cloud data warehousing
* Layered transformations
* Data standardisation
* Dimensional modelling
* Data quality assurance
* Documentation
* Business intelligence

Unlike many portfolio projects that focus only on SQL transformations, NorthBridge IMS implements the entire analytics engineering workflow—from ingestion through reporting—using production-style architecture and best practices.

---

# 📈 Business Value

The warehouse enables business users to answer questions such as:

* Which clients experience the highest SLA breach rates?
* Which ticket priorities consume the most support effort?
* How productive are individual support agents?
* Which categories generate the highest ticket volumes?
* Which contract tiers receive the fastest service?
* How frequently are tickets escalated?
* What is the average response and resolution time by client?
* Which operational trends are emerging over time?

The resulting analytical models provide a trusted foundation for operational reporting, service improvement initiatives, and executive decision-making.

---

# ⚙️ Implementation Details

This section describes the implementation of the NorthBridge IMS data platform from data ingestion through to the analytical reporting layer.

The solution follows the ELT (Extract, Load, Transform) paradigm, where data is first loaded into the warehouse in its raw form before business transformations are applied using dbt.

---

# 📥 Data Ingestion

## Overview

Data ingestion is performed using a custom Python script (`upload_to_s3.py`).

The ingestion process is intentionally lightweight and follows ELT best practices by avoiding business transformations during ingestion. This ensures that the RAW layer remains an accurate representation of the operational source systems.

---

## Responsibilities

The ingestion script performs the following tasks:

* Loads configuration values from environment variables
* Reads operational CSV datasets using pandas
* Removes UTF-8 Byte Order Mark (BOM) characters where present
* Removes trailing empty rows while preserving all business records
* Validates file availability before upload
* Uploads datasets into the Amazon S3 data lake
* Organises datasets into logical folders
* Logs upload activity for traceability

No data cleansing, standardisation, or business logic is applied at this stage.

---

## Source Datasets

The following datasets are ingested:

```text id="j0wn66"
agents.csv
clients.csv
tickets.csv
ticket_audit_log.csv
escalation_log.csv
sla_definitions.csv
priority_levels.csv
ticket_categories.csv
```

---

## Amazon S3 Data Lake

Amazon S3 acts as the landing zone for all operational datasets.

Benefits include:

* Durable cloud storage
* Separation of storage from compute
* Versioned datasets
* Centralised ingestion point
* Easy integration with Airbyte

The S3 bucket serves as the authoritative source for all warehouse refreshes.

---

# 🔄 Airbyte ELT

Airbyte Cloud is responsible for loading source files from Amazon S3 into Snowflake.

## Connection Configuration

| Setting            | Value                    |
| ------------------ | ------------------------ |
| Source             | Amazon S3                |
| Destination        | Snowflake                |
| Sync Mode          | Full Refresh - Overwrite |
| Destination Schema | RAW                      |
| Loading Method     | ELT                      |

Each source dataset is configured as an independent stream, allowing individual datasets to be refreshed without affecting unrelated tables.

---

## Why ELT?

The project adopts ELT instead of ETL because:

* Raw data is preserved before transformation.
* Transformations execute within Snowflake, leveraging warehouse compute.
* Business rules remain version-controlled in dbt.
* Historical source data can be reprocessed if transformation logic changes.

---

# ❄️ Snowflake Data Warehouse

Snowflake serves as the analytical data warehouse and is organised into three logical layers.

```text id="ibvkio"
DATABASE
│
├── RAW
├── STAGING
└── REPORTING
```

Each schema has a single responsibility.

---

## RAW Schema

Purpose:

* Immutable landing zone
* Exact copy of source data
* Managed by Airbyte
* No business transformations

Typical characteristics:

* Original source column names
* Airbyte metadata retained
* Reloadable at any time
* Supports reproducible transformations

---

## STAGING Schema

Purpose:

* Clean operational datasets
* Standardise formats
* Apply business-friendly naming conventions
* Validate source quality
* Prepare data for dimensional modelling

The staging layer contains one model for each operational table.

```text id="djnk80"
STAGING

├── STG_AGENTS
├── STG_CLIENTS
├── STG_TICKETS
├── STG_TICKET_AUDIT_LOG
├── STG_ESCALATION_LOG
├── STG_PRIORITY_LEVELS
├── STG_SLA_DEFINITIONS
└── STG_TICKET_CATEGORIES
```

---

## REPORTING Schema

Purpose:

* Dimensional warehouse
* Business-ready datasets
* Power BI semantic layer
* KPI calculations
* Executive reporting

The reporting layer contains:

* Dimension tables
* Fact tables
* Reporting marts

---

# 🏗️ dbt Project

dbt Cloud is responsible for all warehouse transformations.

The project is organised into modular SQL models following analytics engineering best practices.

## dbt Responsibilities

* Source definitions
* Data transformations
* Data quality testing
* Documentation generation
* Data lineage
* Schema routing
* Business metric calculations

---

## Model Organisation

```text id="k9txek"
models/

├── sources/
│
├── staging/
│
└── reporting/
    ├── dimensions/
    ├── facts/
    └── marts/
```

This structure promotes modularity, maintainability, and ease of testing.

---

# 🧹 STAGING Layer Implementation

The staging layer performs light transformations while preserving the original business grain.

## Key Transformations

### Standardised Naming

All columns are converted to consistent `snake_case` naming.

Example:

```text id="f25dbk"
TicketID
↓

ticket_id
```

---

### Data Type Standardisation

Columns are explicitly cast to their correct Snowflake data types.

Examples include:

* DATE
* TIMESTAMP_NTZ
* NUMBER
* BOOLEAN
* VARCHAR

This prevents inconsistent typing between environments.

---

### Timestamp Parsing

Operational timestamp fields are converted into Snowflake timestamp types.

Examples:

* created_at
* first_response_at
* resolved_at
* sla_due_at

---

### Boolean Standardisation

Boolean fields are normalised into TRUE/FALSE values regardless of their original representation.

---

### Text Standardisation

The staging models:

* Trim whitespace
* Remove unnecessary padding
* Standardise status values
* Normalise text formatting

---

### NULL Handling

Critical business fields receive safe default values where appropriate.

Examples include:

* Unknown client IDs
* Default priorities
* Default statuses
* Missing SLA due dates

This prevents orphaned records during dimensional modelling.

---

### Deduplication

Duplicate tickets are removed using a window function.

```sql
ROW_NUMBER()
OVER (
PARTITION BY ticket_id
ORDER BY created_at DESC
)
```

Only the most recent version of each ticket is retained.

---

### Business Rule Separation

The staging layer intentionally avoids:

* KPI calculations
* Aggregations
* Star schema joins
* Business reporting logic

These responsibilities are delegated to the reporting layer.

---

# ⭐ Reporting Layer Implementation

The reporting schema implements a Kimball-style dimensional warehouse.

Its primary objective is to provide reusable analytical datasets rather than transactional records.

---

## Dimension Tables

Dimensions describe business entities.

```text id="06qv0h"
DIM_AGENTS

DIM_CLIENTS

DIM_PRIORITY

DIM_TICKET_CATEGORY

DIM_SLA

DIM_DATE
```

Dimensions contain descriptive attributes and are designed for slicing and filtering analytical measures.

---

## Fact Tables

Fact tables store measurable business events.

```text id="dkhfjlwm"
FCT_TICKETS

FCT_TICKET_AUDIT

FCT_ESCALATIONS
```

Facts include:

* Ticket lifecycle
* Response durations
* Resolution durations
* SLA compliance
* Escalation activity

Each fact table has a clearly defined grain.

---

## Reporting Marts

Reporting marts aggregate business metrics for dashboard consumption.

```text id="2i8gq0"
RPT_SLA_KPIS

RPT_AGENT_PERFORMANCE

RPT_CLIENT_SLA

RPT_TICKET_SUMMARY
```

These marts minimise dashboard complexity and improve reporting performance.

---

# ⭐ Dimensional Model

The warehouse follows Kimball dimensional modelling principles.

```text id="4k5nws"
                     DIM_DATE
                         │
                         │
DIM_CLIENTS ─────────────┐
                         │
DIM_AGENTS ──────────────┤
                         │
DIM_PRIORITY ────────────┤
                         │
DIM_TICKET_CATEGORY ─────┤
                         │
DIM_SLA ─────────────────┤
                         │
                         ▼
                   FCT_TICKETS
                   /         \
                  /           \
     FCT_TICKET_AUDIT   FCT_ESCALATIONS
```

The model supports efficient analytical queries while minimising redundancy.

---

# 📊 Business Metrics

Business metrics are calculated within the reporting layer to ensure consistency across reports.

Examples include:

* Ticket Count
* Open Ticket Count
* Closed Ticket Count
* SLA Breach Count
* SLA Breach Percentage
* Average First Response Time
* Average Resolution Time
* Resolution SLA Compliance
* Response SLA Compliance
* Escalation Rate
* Agent Productivity
* Client SLA Performance
* Average Ticket Age

Because these calculations are centralised in dbt, every downstream report uses the same business logic.

---

# 🧩 Schema Routing

The project uses a custom `generate_schema_name.sql` macro to ensure models are materialised into the correct Snowflake schemas.

| Model Folder | Destination Schema |
| ------------ | ------------------ |
| staging      | STAGING            |
| reporting    | REPORTING          |

This approach avoids environment-specific schema prefixes and ensures a clean, predictable warehouse structure across development and production.

---

# 🚀 Getting Started

This section describes how to deploy, configure, and execute the NorthBridge IMS data pipeline from end to end.

The project assumes that the required cloud resources (Amazon S3, Airbyte Cloud, Snowflake, and dbt Cloud) have already been provisioned.

---

# 📋 Prerequisites

Before running the project, ensure you have access to the following services and tools.

## Software

* Python 3.11 or later
* Git
* dbt Cloud (or dbt Core)
* Power BI Desktop (optional)

---

## Cloud Services

* Amazon S3 Bucket
* Snowflake Account
* Airbyte Cloud Workspace

---

## Required Knowledge

A basic understanding of the following technologies is recommended:

* Python
* SQL
* Snowflake
* dbt
* Git
* ELT pipelines
* Dimensional modelling

---

# 📥 Clone the Repository

Clone the project from GitHub.

```bash id="tkpmig"
git clone https://github.com/<your-github-username>/northbridge-ims.git

cd northbridge-ims
```

---

# ⚙️ Environment Configuration

The ingestion script reads configuration values from a `.env` file.

Create a local `.env` file using the provided example.

```text id="l8r6wy"
cp .env.example .env
```

Populate the file with your own credentials.

```text id="rvx4oq"
AWS_ACCESS_KEY_ID=

AWS_SECRET_ACCESS_KEY=

AWS_DEFAULT_REGION=

S3_BUCKET_NAME=

SNOWFLAKE_ACCOUNT=

SNOWFLAKE_USER=

SNOWFLAKE_PASSWORD=

SNOWFLAKE_DATABASE=

SNOWFLAKE_SCHEMA=

SNOWFLAKE_WAREHOUSE=
```

> **Important:** Never commit `.env` files or credentials to version control. Ensure `.env` is included in your `.gitignore`.

---

# 📤 Step 1 — Upload Source Data

Operational datasets are uploaded to Amazon S3 using the custom ingestion script.

Run:

```bash id="ktc8ya"
python upload_to_s3.py
```

The script will:

* Load all source CSV files
* Remove UTF-8 BOM characters
* Remove trailing blank rows
* Preserve all business records
* Upload each dataset to Amazon S3
* Display upload progress in the terminal

No business transformations are performed during ingestion.

---

# 🔄 Step 2 — Run Airbyte Synchronisation

After the files are available in Amazon S3, execute the Airbyte connection.

The Airbyte sync performs the following:

* Detects updated files
* Loads each dataset into the Snowflake RAW schema
* Recreates RAW tables using the configured sync mode
* Preserves Airbyte metadata columns

After completion, the RAW schema should contain the latest operational data.

---

# 🧹 Step 3 — Execute dbt Models

dbt performs all warehouse transformations.

Install project dependencies.

```bash id="abgdfy"
dbt deps
```

---

Validate the project configuration.

```bash id="n8rj0j"
dbt debug
```

---

Compile SQL models.

```bash id="m1vvk4"
dbt compile
```

Compilation verifies that:

* Sources exist
* Model references resolve correctly
* SQL syntax is valid
* Macros compile successfully

---

Run all transformations.

```bash id="3b2pr6"
dbt run
```

The execution sequence is:

```text id="p7tevs"
Sources
    │
    ▼
Staging Models
    │
    ▼
Dimensions
    │
    ▼
Fact Tables
    │
    ▼
Reporting Marts
```

---

# ✅ Step 4 — Execute Data Quality Tests

Run all configured dbt tests.

```bash id="3v2mlt"
dbt test
```

The project validates:

## Generic Tests

* Unique keys
* Not Null constraints
* Accepted values
* Relationships

---

## Custom Business Tests

Additional SQL tests validate business rules, including:

* SLA compliance logic
* Escalation consistency
* Referential integrity
* Negative duration detection
* Ticket data quality

A successful run indicates that the warehouse satisfies both technical and business validation rules.

---

# 📚 Step 5 — Generate Documentation

Generate the dbt documentation site.

```bash id="my9lmn"
dbt docs generate
```

Launch the documentation locally.

```bash id="b6oj7u"
dbt docs serve
```

The generated documentation includes:

* Model descriptions
* Column definitions
* Source documentation
* Lineage graph
* Dependencies
* Tests
* Metadata

This provides an interactive view of the warehouse structure and transformation lineage.

---

# 📊 Expected Warehouse Structure

After a successful execution, the Snowflake database should contain the following schemas and models.

```text id="a3sqj1"
RAW
│
├── AGENTS
├── CLIENTS
├── ESCALATION_LOG
├── PRIORITY_LEVELS
├── SLA_DEFINITIONS
├── TICKET_AUDIT_LOG
├── TICKET_CATEGORIES
└── TICKETS

STAGING
│
├── STG_AGENTS
├── STG_CLIENTS
├── STG_ESCALATION_LOG
├── STG_PRIORITY_LEVELS
├── STG_SLA_DEFINITIONS
├── STG_TICKET_AUDIT_LOG
├── STG_TICKET_CATEGORIES
└── STG_TICKETS

REPORTING
│
├── DIM_AGENTS
├── DIM_CLIENTS
├── DIM_DATE
├── DIM_PRIORITY
├── DIM_SLA
├── DIM_TICKET_CATEGORY
├── FCT_ESCALATIONS
├── FCT_TICKET_AUDIT
├── FCT_TICKETS
├── RPT_AGENT_PERFORMANCE
├── RPT_CLIENT_SLA
├── RPT_SLA_KPIS
└── RPT_TICKET_SUMMARY
```

---

# 📈 Power BI Integration

The REPORTING schema is designed to serve as the semantic layer for Power BI.

Rather than connecting directly to operational or staging tables, Power BI should use the reporting models.

Recommended reporting tables include:

* `RPT_SLA_KPIS`
* `RPT_AGENT_PERFORMANCE`
* `RPT_CLIENT_SLA`
* `RPT_TICKET_SUMMARY`

This approach:

* Simplifies dashboard development
* Ensures consistent KPI calculations
* Improves report performance
* Reduces duplicated business logic

---

# 🔍 Validation Checklist

After completing the pipeline, verify that:

* Source datasets have been uploaded to Amazon S3.
* Airbyte has successfully loaded all datasets into the RAW schema.
* `dbt run` completes without model failures.
* `dbt test` passes all generic and custom tests.
* The REPORTING schema contains all dimensions, facts, and marts.
* `dbt docs generate` produces documentation successfully.
* Power BI can connect to the REPORTING schema and refresh datasets.

Completing these checks confirms that the pipeline has executed successfully end to end.

---

# 📚 Additional Documentation

Comprehensive project documentation is available in the `docs/` directory.

| Document                  | Purpose                                                          |
| ------------------------- | ---------------------------------------------------------------- |
| `docs/DATA_LINEAGE.md`    | End-to-end data flow from ingestion to reporting                 |
| `docs/DATA_DICTIONARY.md` | Business definitions for staging and reporting models            |
| `dbt Docs`                | Interactive lineage graph, model documentation, and dependencies |

These documents complement the README and provide deeper technical detail for developers, analysts, and reviewers.

---

## Verify Successful Build

After execution you should have:

```
RAW
    8 tables

STAGING
    8 models

REPORTING
    6 dimensions
    3 facts
    4 marts
```

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

# 🔮 Future Enhancements

Potential improvements include:

- Incremental dbt models
- CI/CD with GitHub Actions
- Automated Airbyte sync scheduling
- Data observability with Elementary
- Great Expectations integration
- Snowflake Tasks and Streams
- Infrastructure as Code using Terraform
- Containerisation with Docker
- Orchestration with Apache Airflow
  
# 📖 Lessons Learned

This project reinforced several production data engineering concepts:

- Separation of ingestion and transformation responsibilities
- Importance of immutable RAW data
- Layered warehouse architecture
- Kimball dimensional modelling
- dbt testing and documentation
- Schema management using macros
- End-to-end ELT pipeline design
  

# 👤 Author

**Binah Utuedor**

**Data Engineer | Analytics Engineer | Business Intelligence Developer**

This project demonstrates the design and implementation of a production-style cloud data engineering solution using Amazon S3, Airbyte, Snowflake, dbt, SQL, and Power BI. It showcases modern ELT architecture, layered data modelling, dimensional design, analytics engineering, and business intelligence reporting following industry best practices.