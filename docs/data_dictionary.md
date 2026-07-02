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