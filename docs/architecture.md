
---

# 🏛️ `docs/architecture.md`

```markdown
# 🏛️ NorthBridge IMS — System Architecture

## Overview
The NorthBridge IMS platform is a modern end-to-end data engineering solution designed for customer service ticketing and SLA performance analytics.

It is built using a layered ELT architecture.

---

# 🧱 ARCHITECTURE OVERVIEW

```text
S3 (Raw Data Storage)
        ↓
Airbyte (Ingestion Layer)
        ↓
Snowflake RAW Schema
        ↓
dbt STAGING Layer
        ↓
dbt FACT Layer
        ↓
dbt DIMENSIONS Layer
        ↓
dbt REPORTING MARTS
        ↓
Power BI Dashboards