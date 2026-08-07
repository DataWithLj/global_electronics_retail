# 🎯Project Background & Business Problem
Core Focus: Business context, stakeholder needs, key problem statement, and primary KPIs.

## 📝Core Business Question
Where are sales and profit coming from?

---
## 📐 Data Architecture & Quality Checks

**Dataset:** [Global Electronics Retail](https://mavenanalytics.io/data-playground) by Maven Analytics  
**Scope:** 5 Raw Entities (`Customers`, `Exchange_Rates`, `Products`, `Sales`, `Stores`)

### Initial Data Audit
Prior to transformation, `INFORMATION_SCHEMA.COLUMNS` was queried to inspect table structures, column constraints, and data types across all raw tables:

* **Data Type Verification:** Confirmed that all raw fields matched their expected target data types (e.g., date as `DATE`, monetary values as `FLOAT`, keys as `INT`).
* **Schema Consistency:** Validated column ordinal positions across source tables.

### Data Quality Audit
There were no problems with customers table, exchange rates, product table, and stores table.

There were 49719 null delivery dates in sales table. ***Check if there is relation with store key and null in delivery data***
