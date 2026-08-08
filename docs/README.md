# 🎯Project Background & Business Problem
Core Focus: Business context, stakeholder needs, key problem statement, and primary KPIs.

## 📝Core Business Question
Where are sales and profit coming from?

---
# 📐 Data Architecture & Quality Checks

**Dataset:** [Global Electronics Retail](https://mavenanalytics.io/data-playground) by Maven Analytics  
**Scope:** 5 Raw Entities (`Customers`, `Exchange_Rates`, `Products`, `Sales`, `Stores`)

## Initial Data Audit
Prior to transformation, `INFORMATION_SCHEMA.COLUMNS` was queried to inspect table structures, column constraints, and data types across all raw tables:

* **Data Type Verification:** Confirmed that all raw fields matched their expected target data types (e.g., date as `DATE`, monetary values as `FLOAT`, keys as `INT`).
* **Schema Consistency:** Validated column ordinal positions across source tables.

## Data Quality Audit & Observations

### Entity Audit Overview
Initial structural and integrity checks (`INFORMATION_SCHEMA.COLUMNS`, key uniqueness, and null value scans) confirmed that **4 out of 5 raw tables required zero remediation**:
* **`Customers`**, **`Exchange_Rates`**, **`Products`**, and **`Stores`**: 100% clean schema alignment, valid primary/foreign keys, correct data types, and no anomalous null values.

### Sales Table Investigation
During the audit of the **`Sales`** table, a significant number of nulls were identified in the `Delivery_Date` column. Cross-table investigation confirmed these are not data errors, but expected business logic:

* **Physical Store Transactions:** 49,719 records contained `NULL` values for `Delivery_Date`. Checking StoreKey in the Stores table confirmed these purchases occurred at physical retail locations, where fulfillment happens immediately at the point of sale.
* **Online Fulfillment:** The remaining 13,165 records contained valid delivery timestamps, all corresponding strictly to online store orders.

### Duplicate Analysis & Integrity Checks

All 5 tables were audited for both primary key integrity and logical entity duplication.

| Entity | Duplicate Test Criteria | Result |
| :--- | :--- | :--- |
| **`Customers`** | Same `Name` + `Birthday` | **0 Duplicates** |
| **`Exchange_Rates`** | Same `Date` + `Currency` | **0 Duplicates** |
| **`Products`** | Same `Product Name` + `Brand` + `Color` + `Subcategory` | **0 Duplicates** |
| **`Sales`** | Same `Order Number` + `Line Number` | **0 Duplicates** |
| **`Stores`** | Primary Key (`StoreKey`) Uniqueness | **100% Unique** |

#### Store Entity Deduplication Logic
Further deduplication based on `State`, `Open Date`, or `Square Meters` was intentionally avoided. Because location data stops at the State level (lacking street addresses or cities), retail chains frequently operate multiple valid locations within the same state. Deduplicating on these fields risked removing real physical store branches.
