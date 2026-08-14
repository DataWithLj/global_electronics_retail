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

During the audit of the **`Sales`** table, all columns were verified to be **100% complete with zero null values**, with the sole exception of `Delivery_Date`. Investigation confirmed these nulls represent expected business logic rather than data errors:

* **Physical Store Transactions:** 49,719 records contained `NULL` values for `Delivery_Date`. Checking `StoreKey` in the `Stores` table confirmed these purchases occurred at physical retail locations, where fulfillment happens immediately at the point of sale.
* **Online Fulfillment:** The remaining 13,165 records contained valid delivery timestamps, all corresponding strictly to online store orders. Verified that all delivery dates occurred on or after the `Order Date` (`Delivery_Date >= Order Date`), with zero chronological discrepancies..
* **Overall Completeness:** Confirmed 0 missing or null values across all other transaction fields (`Order Number`, `Line Item`, `Order Date`, `CustomerKey`, `ProductKey`, `StoreKey`, `Quantity`, and `Currency Code`).

### Duplicate Analysis & Integrity Checks

All 5 tables were audited for both primary key integrity and logical entity duplication.

| Entity | Duplicate Test Criteria | Result |
| :--- | :--- | :--- |
| **`Customers`** | Same `Name` + `Birthday` | **0 Duplicates** |
| **`Exchange_Rates`** | Same `Date` + `Currency` | **0 Duplicates** |
| **`Products`** | Same `Product Name` + `Brand` + `Color` + `Subcategory` | **0 Duplicates** |
| **`Sales`** | Same `Order Number` + `Line Number` | **0 Duplicates** |
| **`Stores`** | Primary Key (`StoreKey`) Uniqueness | **100% Unique** |

#### Note:
Further deduplication based on `State`, `Open Date`, or `Square Meters` was intentionally avoided. Because location data stops at the State level (lacking street addresses or cities), retail chains frequently operate multiple valid locations within the same state. Deduplicating on these fields risked removing real physical store branches.

### Categorical audit

### `Customers` Table Validation

All fields (`Gender`, `Country`, `State`, `Continent`) were verified to be free of nulls and special characters. Specific string cleaning was performed on `Name` and `City`:

| Field | Issue Identified | Remediation Action | Example Transformation |
| :--- | :--- | :--- | :--- |
| **`Name`** | Stray special characters (`?`), extra spaces | Removed special characters, collapsed multiple spaces to single spaces, applied Title Case | `"john  ?doe"` → `"John Doe"` |
| **`City`** | Parenthetical county names, extra spaces | Stripped secondary location details inside parentheses, normalized spacing, applied Title Case | `"Spring Lake (Highlands)"` → `"Spring Lake"` |

### `Exchange_Rates` Table Validation

The `Exchange_Rates` table was verified to be clean and fully aligned with transaction logs:

* **Currency Standardization:** ISO currency codes are valid, standardized, and error-free.
* **Date & Currency Coverage:** Verified that every `Date` + `Currency` pair present in the `Sales` table has an exact matching rate in `Exchange_Rates`, guaranteeing complete coverage for multi-currency transformations.

### `Products` Table Audit & Validation

The `Products` table was audited for structural accuracy, relationship hierarchy, and logical business boundaries:

* **Data Completeness:** 100% complete records with no null values or unwanted special characters across product attributes (`Product Name`, `Brand`, `Color`, `Cost`, `Price`, `Category`, `Subcategory`).
* **Category Hierarchy:** Mapped category structures to ensure zero orphan or overlapping subcategories. Every `Subcategory` links strictly to one `Category`.
* **Financial Logic:**
  * **Positive Values:** All prices and costs are non-zero positive numbers.
  * **Margin Integrity:** Confirmed that `Unit Price USD` is consistently higher than `Unit Cost USD` across all items.

### `Sales` Table Referential Integrity

#### Foreign Key Validation
Verified 100% referential integrity between the `Sales` fact table and all dimension tables, confirming **zero orphan records**:
* **`ProductKey`:** Every product key in `Sales` maps to a valid primary key in `Products`.
* **`CustomerKey`:** Every customer key in `Sales` maps to a valid primary key in `Customers`.
* **`StoreKey`:** Every store key in `Sales` maps to a valid primary key in `Stores`.

---
# ⚙️Technical Methodology

## 📊 Category Financial Performance

A comparative analysis of revenue, net profit, and profit margins across all 8 product categories reveals clear portfolio drivers and profitability efficiency.

| Category | Total Revenue (USD) | Total Profit (USD) | Profit Margin (%) | Revenue Rank | Profit Rank |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Computers** | $19,301,595.46 | $11,277,447.90 | 58.4% | 1 | 1 |
| **Home Appliances** | $10,795,478.59 | $6,296,338.85 | 58.3% | 2 | 2 |
| **Cameras and Camcorders** | $6,520,168.02 | $3,919,800.99 | 60.1% | 3 | 3 |
| **Cell Phones** | $6,183,791.22 | $3,498,626.54 | 56.6% | 4 | 5 |
| **TV and Video** | $5,928,982.69 | $3,536,694.39 | 59.7% | 5 | 4 |
| **Audio** | $3,169,627.74 | $1,827,851.77 | 57.7% | 6 | 7 |
| **Music, Movies and Audio Books** | $3,131,006.44 | $1,909,259.17 | 61.0% | 7 | 6 |
| **Games and Toys** | $724,829.43 | $396,668.77 | 54.7% | 8 | 8 |

---

### 💡 Key Insights & Observations

* **Top Portfolio Drivers:** **Computers** ($19.30M revenue / $11.28M profit) and **Home Appliances** ($10.80M revenue / $6.30M profit) anchor the business, accounting for over 58% of total revenue combined.
* **Profitability Flips:** 
  * **TV and Video vs. Cell Phones:** While *Cell Phones* generated higher top-line revenue ($6.18M vs $5.93M), *TV and Video* yielded higher bottom-line profit ($3.54M vs $3.50M) due to a stronger profit margin (59.7% vs 56.6%).
  * **Music/Movies vs. Audio:** *Music, Movies and Audio Books* outperformed *Audio* in net profit ($1.91M vs $1.83M) despite lower revenue, driven by a portfolio-leading **61.0% profit margin**.
* **Highest & Lowest Margins:** 
  * **Highest Margin Category:** *Music, Movies and Audio Books* (61.0%), followed closely by *Cameras and Camcorders* (60.1%).
  * **Lowest Margin Category:** *Games and Toys* (54.7%), which represents both the smallest volume ($724.8K revenue) and lowest profitability rate.

## 🏪 Sales Channel & Store Performance

A detailed analysis comparing channel-level performance and individual store metrics reveals key drivers in revenue volume and profitability efficiency.

---

### 🛍️ Channel Breakdown

While physical retail locations drive the vast majority of total sales volume, both physical and e-commerce channels achieve virtually identical profitability rates.

| Channel | Total Revenue (USD) | Total Profit (USD) | Profit Margin (%) | Revenue Share (%) |
| :--- | :---: | :---: | :---: | :---: |
| **Physical** | $44,351,154.96 | $25,989,995.74 | 58.60% | 79.55% |
| **Online** | $11,404,324.63 | $6,672,692.64 | 58.51% | 20.45% |
| **Total** | **$55,755,479.59** | **$32,662,688.38** | **58.58%** | **100.00%** |

* **Volume Driver:** Physical stores generate **~80% of total revenue** ($44.35M) and net profit ($25.99M).
* **Margin Parity:** Both channels convert sales to profit at an identical rate (~**58.5% margin**), demonstrating consistent pricing integrity across fulfillment methods.

---

### 📊 Individual Store Performance Analysis

Evaluating stores individually reveals a clear distinction between **high-volume revenue generators** and **high-efficiency margin leaders**.

#### 1. Top Revenue & Profit Performers
* **Online Store:** Ranks **#1 overall** in total dollar volume ($11.40M revenue), but ranks **#33** in profit margin percentage (58.51%).
* **Top Physical Stores (US Dominance):** All top 3 physical stores in overall revenue and net profit are located in the **United States**:
  * **Store 55 (Nevada, US):** Ranked **#1** ($1.42M revenue / $830.6K profit | 58.58% margin, rank #30)
  * **Store 50 (Kansas, US):** Ranked **#2** ($1.39M revenue / $819.7K profit | 58.77% margin, rank #22)
  * **Store 54 (Nebraska, US):** Ranked **#3** ($1.38M revenue / $810.3K profit | 58.53% margin, rank #32)

#### 2. Least Revenue & Profit Performers
* **Bottom Physical Stores:** The lowest sales and profit figures across the entire physical network belong to international locations:
  * **Store 2 (Northern Territory, Australia):** Lowest overall ($15.2K revenue / $9.5K profit)
  * **Store 14 (Franche-Comté, France):** Second lowest ($105.7K revenue / $63.6K profit)
  * **Store 13 (Corse, France):** Third lowest ($150.9K revenue / $89.0K profit)

#### 3. Margin Efficiency Leaders
* **Top Efficient Stores:** 
  * **Store 2 (Northern Territory, Australia):** Ranked **#1** in profit margin at **62.68%**.
  * **Store 16 (Limousin, France):** Ranked **#2** in profit margin at **60.26%**.
  * **Store 4 (Tasmania, Australia):** Ranked **#3** in profit margin at **60.20%**.
* **Volume vs. Efficiency Trade-off:** Store **2** generated the lowest absolute sales volume across the physical network ($15.2k revenue), yet retained the highest profit percentage per sale across all locations.

---

### ❓ Key Financial Health Takeaways

* **Zero Negative-Margin Locations:** No stores in the portfolio operate near zero or at a loss. Every location operates within a healthy profit margin corridor of **57.9% to 62.7%**. 
* **Diagnosis:** Lower-performing locations (like Stores 2, 14, 13, and 17) suffer strictly from low customer transaction volume rather than poor unit economics or discounting.












