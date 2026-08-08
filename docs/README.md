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

### Duplicate Checking
To find if there's duplicate in `customer` table, the table was inspected if there are customers that have the same name and birthday. The query didn't return any data.
To find if there's duplicate in `exchange_rates` table, the table was inspected if there are exchange rates that have the same date and currency. The query didn't return any data.
To find if there's duplicate in `products` table, the table was inspected if there are products that have the same product name, brand, color, and subcategory. The query didn't return any data.


