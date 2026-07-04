<<<<<<< Updated upstream
# 📘 NorthBridge IMS — Data Dictionary

## Overview
This document defines the business meaning of all core datasets used in the NorthBridge IMS Customer Service Ticket & SLA Optimisation system.

The system is built using a layered dbt architecture:
- Staging (cleaned source data)
- Fact tables (business events)
- Dimension tables (conformed entities)
- Reporting marts (BI-ready aggregations)

---

# 🧾 FACT TABLES

## fct_tickets
Core fact table representing one record per customer support ticket.

| Column | Description |
|--------|------------|
| ticket_id | Unique identifier for each ticket |
| ticket_reference | Human-readable ticket reference (e.g. NB-2024-00001) |
| client_id | Links ticket to client dimension |
| agent_id | Assigned support agent |
| priority_id | Ticket priority level (P1–P4) |
| category_id | Ticket category classification |
| created_at | Timestamp when ticket was created |
| first_response_at | Timestamp of first agent response |
| resolved_at | Timestamp when ticket was resolved |
| sla_due_at | SLA deadline timestamp |
| created_date_key | Date key for time-based analysis |
| first_response_date_key | Date of first response |
| resolved_date_key | Date of resolution |
| sla_due_date_key | SLA deadline date |
| resolution_minutes | Time taken to resolve ticket (minutes) |
| first_response_minutes | Time to first response (minutes) |
| ticket_age_days | Age of ticket in days |
| sla_breached | Indicates SLA breach (true/false) |
| responded_within_sla | First response met SLA target |
| resolved_within_sla | Resolution met SLA target |
| escalated_flag | Indicates if ticket was escalated |
| ticket_count | Constant measure (=1) |

---

## fct_escalations
Represents each escalation event in the ticket lifecycle.

| Column | Description |
|--------|------------|
| escalation_id | Unique escalation event ID |
| ticket_id | Related ticket |
| client_id | Client associated with ticket |
| agent_id | Agent assigned to ticket |
| escalation_reason | Reason for escalation |
| escalated_at | Timestamp of escalation |
| automated_flag | Whether escalation was system-triggered |
| escalation_count | Constant measure (=1) |
| hours_to_escalation | Time from ticket creation to escalation |

---

## fct_ticket_audit
Captures lifecycle changes for each ticket.

| Column | Description |
|--------|------------|
| log_id | Unique audit log entry |
| ticket_id | Related ticket |
| action_type | Type of action (Created, Assigned, Resolved, etc.) |
| action_by_id | User performing action |
| action_at | Timestamp of action |
| previous_value | Previous state |
| new_value | New state |
| audit_event_count | Constant measure (=1) |

---

# 📊 DIMENSION TABLES

## dim_agents
Agent workforce dimension.

| Column | Description |
|--------|------------|
| agent_id | Unique agent identifier |
| full_name | Agent name |
| team_id | Team assignment |
| role | Agent role |
| hub | Location hub |
| specialisms | Areas of expertise |
| daily_capacity | Expected tickets per day |
| is_active | Active status |
| seniority_band | Derived seniority level |
| capacity_band | Derived workload capacity level |

---

## dim_clients
Client / customer dimension.

| Column | Description |
|--------|------------|
| client_id | Unique client identifier |
| client_name | Name of healthcare client |
| client_type | Type of organisation |
| contract_tier | Service tier (Standard/Premium/Enterprise) |
| region | Geographic region |
| account_manager_id | Assigned account manager |
| contract_start_date | Contract start date |
| contract_end_date | Contract end date |
| sla_credit_clause | SLA penalty clause flag |
| is_active | Active status |
| contract_duration_days | Length of contract |
| contract_expired | Contract expiry flag |
| contract_expiring_soon | Near-expiry flag |

---

## dim_priority
Ticket priority reference table.

| Column | Description |
|--------|------------|
| priority_id | Priority key |
| priority_label | Priority name (P1 Critical → P4 Low) |
| description | Priority definition |

---

## dim_ticket_category
Ticket classification dimension.

| Column | Description |
|--------|------------|
| category_id | Category key |
| category_name | Name of ticket category |
| default_priority_id | Default priority |
| requires_specialist | Specialist handling required |
| description | Category description |

---

## dim_sla
SLA rules by contract tier and priority.

| Column | Description |
|--------|------------|
| sla_id | SLA rule identifier |
| contract_tier | Client tier |
| priority_id | Ticket priority |
| first_response_hours | SLA response target |
| resolution_hours | SLA resolution target |
| escalation_trigger_hours | Escalation threshold |
| effective_from | Effective start date |

---

## dim_date
Calendar dimension for reporting.

| Column | Description |
|--------|------------|
| date_key | Calendar date |
| year | Calendar year |
| quarter | Calendar quarter |
| month | Month number |
| month_name | Month name |
| week | Week number |
| day | Day of month |
| day_name | Day of week |
| year_month | YYYY-MM format |
| week_start_date | Start of week |
| week_end_date | End of week |
| fiscal_year | Fiscal year |
| fiscal_quarter | Fiscal quarter |
| is_weekend | Weekend flag |

---

# 📌 Summary
This data dictionary provides a business-friendly view of the NorthBridge IMS analytics platform and ensures consistent interpretation across analytics, BI, and operational teams.
=======
# NorthBridge IMS – Data Dictionary

**Project:** Customer Service Ticket & SLA Optimisation System
**Database:** `NORTHBRIDGE_IMS`
**Warehouse:** Snowflake
**Transformation Tool:** dbt Cloud

---

# Overview

The data dictionary documents all business-facing tables produced by the dbt transformation layer.

The project follows a modern Medallion architecture:

```text
RAW
   │
   ▼
STAGING
   │
   ▼
REPORTING
```

The **RAW** layer is managed by Airbyte and is intentionally excluded from this document because it mirrors the source system.

This document describes:

* STAGING models
* Dimension tables
* Fact tables
* Reporting marts

---

# STAGING LAYER

---

# STG_AGENTS

**Purpose**

Cleaned master list of customer service agents.

**Primary Key**

`agent_id`

| Column         | Type    | Description                      |
| -------------- | ------- | -------------------------------- |
| agent_id       | Integer | Unique identifier for each agent |
| full_name      | String  | Agent full name                  |
| team_id        | Integer | Customer service team identifier |
| role           | String  | Job role                         |
| specialisms    | String  | Ticket categories handled        |
| hub            | String  | Office location                  |
| daily_capacity | Integer | Expected tickets per day         |
| is_active      | Boolean | Active employment flag           |

---

# STG_CLIENTS

**Purpose**

Master client information.

**Primary Key**

`client_id`

| Column              | Type    | Description                     |
| ------------------- | ------- | ------------------------------- |
| client_id           | Integer | Client identifier               |
| client_name         | String  | Organisation name               |
| client_type         | String  | Hospital or clinic type         |
| contract_tier       | String  | Standard, Premium or Enterprise |
| account_manager_id  | Integer | Responsible account manager     |
| region              | String  | Geographic region               |
| contract_start_date | Date    | Contract start                  |
| contract_end_date   | Date    | Contract end                    |
| sla_credit_clause   | Boolean | SLA penalty clause              |
| is_active           | Boolean | Client currently active         |

---

# STG_PRIORITY_LEVELS

**Purpose**

Lookup table for ticket priorities.

**Primary Key**

`priority_id`

| Column         | Type    | Description          |
| -------------- | ------- | -------------------- |
| priority_id    | Integer | Priority identifier  |
| priority_label | String  | P1–P4 label          |
| description    | String  | Business description |

---

# STG_TICKET_CATEGORIES

**Purpose**

Lookup table for ticket categories.

**Primary Key**

`category_id`

| Column              | Type    | Description          |
| ------------------- | ------- | -------------------- |
| category_id         | Integer | Category identifier  |
| category_name       | String  | Ticket category      |
| default_priority_id | Integer | Default priority     |
| requires_specialist | Boolean | Specialist required  |
| description         | String  | Category description |

---

# STG_SLA_DEFINITIONS

**Purpose**

Defines contractual SLA targets.

**Primary Key**

`sla_id`

| Column                   | Type    | Description           |
| ------------------------ | ------- | --------------------- |
| sla_id                   | Integer | SLA identifier        |
| contract_tier            | String  | Contract tier         |
| priority_id              | Integer | Priority              |
| first_response_hours     | Decimal | Target first response |
| resolution_hours         | Decimal | Target resolution     |
| escalation_trigger_hours | Decimal | Escalation threshold  |
| effective_from           | Date    | Effective date        |

---

# STG_ESCALATION_LOG

**Purpose**

Records ticket escalations.

**Primary Key**

`escalation_id`

| Column            | Type      | Description           |
| ----------------- | --------- | --------------------- |
| escalation_id     | Integer   | Escalation identifier |
| ticket_id         | Integer   | Related ticket        |
| escalated_from    | Integer   | Source agent          |
| escalated_to      | Integer   | Destination agent     |
| escalation_reason | String    | Reason                |
| escalated_at      | Timestamp | Escalation time       |
| automated_flag    | Boolean   | Automatic escalation  |

---

# STG_TICKET_AUDIT_LOG

**Purpose**

Historical audit trail.

**Primary Key**

`log_id`

| Column         | Type      | Description             |
| -------------- | --------- | ----------------------- |
| log_id         | Integer   | Audit record            |
| ticket_id      | Integer   | Ticket identifier       |
| action_by_id   | Integer   | Agent performing action |
| action_type    | String    | Audit action            |
| action_at      | Timestamp | Action time             |
| previous_value | String    | Previous value          |
| new_value      | String    | New value               |
| notes          | String    | Additional notes        |

---

# STG_TICKETS

**Purpose**

Cleaned operational ticket dataset.

**Primary Key**

`ticket_id`

| Column            | Type      | Description            |
| ----------------- | --------- | ---------------------- |
| ticket_id         | Integer   | Ticket identifier      |
| ticket_reference  | String    | Business ticket number |
| client_id         | Integer   | Client                 |
| patient_ref       | String    | Patient reference      |
| category_id       | Integer   | Ticket category        |
| priority_id       | Integer   | Ticket priority        |
| status            | String    | Standardised status    |
| assigned_agent_id | Integer   | Assigned agent         |
| created_at        | Timestamp | Ticket creation        |
| first_response_at | Timestamp | First response         |
| resolved_at       | Timestamp | Resolution time        |
| sla_due_at        | Timestamp | SLA due time           |
| sla_breached      | Boolean   | SLA breached           |
| channel           | String    | Communication channel  |
| description       | String    | Ticket description     |
| resolution_notes  | String    | Resolution summary     |

---

# REPORTING LAYER

---

# DIM_AGENTS

**Grain**

One row per agent.

| Column         | Description    |
| -------------- | -------------- |
| agent_id       | Agent key      |
| full_name      | Name           |
| team_id        | Team           |
| role           | Role           |
| specialisms    | Skills         |
| hub            | Office         |
| daily_capacity | Daily workload |
| is_active      | Active status  |

---

# DIM_CLIENTS

**Grain**

One row per client.

| Column              | Description       |
| ------------------- | ----------------- |
| client_id           | Client key        |
| client_name         | Client            |
| client_type         | Organisation type |
| contract_tier       | SLA tier          |
| account_manager_id  | Manager           |
| region              | Region            |
| contract_start_date | Start             |
| contract_end_date   | End               |
| sla_credit_clause   | SLA credits       |
| is_active           | Active flag       |

---

# DIM_PRIORITY

| Column         | Description          |
| -------------- | -------------------- |
| priority_id    | Priority key         |
| priority_label | P1–P4                |
| description    | Priority description |

---

# DIM_TICKET_CATEGORY

| Column              | Description         |
| ------------------- | ------------------- |
| category_id         | Category key        |
| category_name       | Category            |
| default_priority_id | Default priority    |
| requires_specialist | Specialist required |
| description         | Description         |

---

# DIM_SLA

| Column                   | Description        |
| ------------------------ | ------------------ |
| sla_id                   | SLA key            |
| contract_tier            | Contract           |
| priority_id              | Priority           |
| first_response_hours     | Response target    |
| resolution_hours         | Resolution target  |
| escalation_trigger_hours | Escalation trigger |
| effective_from           | Effective date     |

---

# DIM_DATE

Generated calendar dimension.

| Column          | Description    |
| --------------- | -------------- |
| date_key        | Calendar date  |
| year            | Year           |
| quarter         | Quarter        |
| month           | Month          |
| month_name      | Month name     |
| week            | ISO week       |
| day             | Day            |
| day_name        | Day name       |
| year_month      | YYYY-MM        |
| week_start_date | Week start     |
| week_end_date   | Week end       |
| fiscal_year     | UK fiscal year |
| fiscal_quarter  | Fiscal quarter |
| is_weekend      | Weekend flag   |

---

# FACT TABLES

---

# FCT_TICKETS

**Grain**

One row per ticket.

| Column                   | Description          |
| ------------------------ | -------------------- |
| ticket_id                | Ticket               |
| ticket_reference         | Business reference   |
| client_id                | Client               |
| agent_id                 | Assigned agent       |
| priority_id              | Priority             |
| category_id              | Category             |
| created_date_key         | Date dimension       |
| first_response_date_key  | Date dimension       |
| resolved_date_key        | Date dimension       |
| sla_due_date_key         | Date dimension       |
| created_at               | Creation timestamp   |
| first_response_at        | Response timestamp   |
| resolved_at              | Resolution timestamp |
| sla_due_at               | SLA deadline         |
| patient_ref              | Patient              |
| channel                  | Source channel       |
| status                   | Current status       |
| contract_tier            | Client tier          |
| first_response_hours     | SLA target           |
| resolution_hours         | SLA target           |
| escalation_trigger_hours | SLA trigger          |
| first_response_minutes   | Response duration    |
| resolution_minutes       | Resolution duration  |
| resolution_hours_actual  | Resolution hours     |
| responded_within_sla     | SLA compliance       |
| resolved_within_sla      | SLA compliance       |
| ticket_age_days          | Ticket age           |
| sla_breached             | SLA flag             |
| sla_breach_count         | Breach counter       |
| escalated_flag           | Escalation indicator |
| ticket_count             | Always 1             |

---

# FCT_TICKET_AUDIT

**Grain**

One row per audit event.

| Column            | Description    |
| ----------------- | -------------- |
| log_id            | Audit key      |
| ticket_id         | Ticket         |
| client_id         | Client         |
| agent_id          | Agent          |
| action_type       | Action         |
| action_by_id      | User           |
| action_at         | Timestamp      |
| previous_value    | Previous value |
| new_value         | New value      |
| notes             | Notes          |
| action_date       | Date           |
| audit_event_count | Always 1       |

---

# FCT_ESCALATIONS

**Grain**

One row per escalation.

| Column            | Description       |
| ----------------- | ----------------- |
| escalation_id     | Escalation        |
| ticket_id         | Ticket            |
| from_agent_id     | Originating agent |
| to_agent_id       | Receiving agent   |
| escalation_reason | Reason            |
| escalated_at      | Timestamp         |
| from_agent_name   | Agent             |
| to_agent_name     | Agent             |

---

# REPORTING MARTS

---

# RPT_SLA_KPIS

Executive KPI summary.

Key measures include:

* Total Tickets
* Open Tickets
* Closed Tickets
* Resolved Tickets
* SLA Breaches
* SLA Breach Percentage
* Average Response Time
* Average Resolution Time

---

# RPT_AGENT_PERFORMANCE

Agent performance dashboard.

Key measures include:

* Tickets Assigned
* Tickets Closed
* SLA Compliance
* Average Resolution Time
* Productivity Ratio
* Escalation Rate
* Performance Segment

---

# RPT_CLIENT_SLA

Client service performance dashboard.

Key measures include:

* Ticket Volume
* SLA Compliance
* Escalation Rate
* Average Ticket Age
* Resolution Metrics

---

# RPT_TICKET_SUMMARY

Operational reporting summary.

Dimensions include:

* Year
* Month
* Week
* Priority
* Category
* Channel
* Status

Measures include:

* Total Tickets
* SLA Breaches
* Average Response Time
* Average Resolution Time

---

# Business Key Relationships

| Parent              | Child            | Relationship     |
| ------------------- | ---------------- | ---------------- |
| DIM_CLIENTS         | FCT_TICKETS      | client_id        |
| DIM_AGENTS          | FCT_TICKETS      | agent_id         |
| DIM_PRIORITY        | FCT_TICKETS      | priority_id      |
| DIM_TICKET_CATEGORY | FCT_TICKETS      | category_id      |
| DIM_DATE            | FCT_TICKETS      | created_date_key |
| STG_TICKETS         | FCT_TICKET_AUDIT | ticket_id        |
| STG_TICKETS         | FCT_ESCALATIONS  | ticket_id        |

---

# Naming Conventions

| Convention     | Example             |
| -------------- | ------------------- |
| Staging        | STG_TICKETS         |
| Dimension      | DIM_CLIENTS         |
| Fact           | FCT_TICKETS         |
| Reporting Mart | RPT_SLA_KPIS        |
| Primary Key    | ticket_id           |
| Foreign Key    | client_id           |
| Boolean        | is_active           |
| Timestamp      | created_at          |
| Date           | contract_start_date |

---

# Data Governance

The reporting layer is the certified analytical layer consumed by Power BI and business users.

All transformations follow ELT principles:

* Raw data remains immutable.
* Business rules are implemented in dbt.
* Dimensions provide descriptive context.
* Facts store measurable business events.
* Reporting marts aggregate metrics for executive reporting.

This data dictionary should be maintained alongside the dbt project to ensure consistent understanding of the data model across engineering, analytics, and business teams.
>>>>>>> Stashed changes
