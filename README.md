# 🌍 Global Electronics Retail Performance & Strategy

SQL Data Analysis & Power BI Dashboards evaluating historical sales data to uncover actionable growth opportunities, optimize operational planning, and identify key customer segments.

👉 **[Read the full documentation](docs/README.md)**

---

## 📌 Executive Summary
Global Electronics operates across international retail channels, generating multi-year transactional records spanning various store locations, customer demographics, and product lines. This analysis evaluates historical sales and customer data to uncover purchasing trends, seasonal demand cycles, and category profitability.

The primary business goal is to derive actionable growth strategies by optimizing operational planning, refining channel marketing, and identifying high-value customer segments.

* **Primary Business Task:** Analyze multi-channel transactional data to identify revenue drivers and purchasing patterns, applying key insights to optimize inventory allocation and elevate customer lifetime value.
* **Key Finding:** Sales exhibit strong demand seasonality in Q4 (~25% of annual revenue) and a high profit baseline (~58.58%) across international markets, with high-volume categories (Computers & Home Appliances) anchoring overall growth.
* **Top Recommendation:** Capitalize on peak Q4 demand through proactive October inventory staging, scale international digital marketing to capture margin-rich online demand, and attach high-margin accessories at checkout to boost Average Order Value (AOV).

---

## 🛠️ Tools & Technologies
* **SQL (Google BigQuery):** Cleaned data, categorical audit, and conduct exploratory data analysis.
* **Power BI:** Interactive visual dashboards for stakeholder presentations and trend exploration.

---

## 📊 Key Findings & Insights

* **Executive Performance:** Generated **$55.76M in Total Revenue** with a **58.58% Profit Margin** across 11.89K customers. The United States serves as the primary regional market ($29.90M), while channel sales are anchored by the central Online store ($11.40M) and top-performing physical retail locations.
* **Seasonality & Trends:** Revenue scaled steadily from 2016 through its peak in 2019 ($18.30M revenue / $10.70M profit) before experiencing a 2020 contraction. Sales exhibit predictable Q4 holiday spikes, consistently peaking in December (reaching $2.48M in Dec 2019).
* **Customer Demographics:** High customer concentration shows the top 10% customer tier accounts for **29.59% of total revenue ($16.50M)**. Customers aged 65+ demonstrate the highest purchasing power across both genders, generating $15.78M combined.
* **Product Drivers:** Computers serve as the flagship product category, driving **$19.30M in revenue** across 44K units sold, with Desktop subcategories alone contributing $2.94M.

---

## 💡 Strategic Recommendations

Based on multi-year sales trends, customer buying habits, and high profit margins (~58.58%), here are the main action steps:

* **Global Expansion:** Boost digital ads in overseas markets to win new online customers without using heavy discounts.
  * *Data Insight:* High, steady profit margins (~58.58%) across international areas.
  * *Business Goal:* Gain new customers and grow market share abroad.

* **Seasonality & Inventory Planning:** Increase marketing efforts and stock up on products starting in October before the busy holiday season.
  * *Data Insight:* Q4 (Nov/Dec) brings in ~25% of yearly sales.
  * *Business Goal:* Take advantage of peak holiday shopping and avoid running out of stock.

* **Automated Customer Retention:** Set up automatic follow-up emails with personalized product suggestions based on past purchases.
  * *Data Insight:* Most revenue comes from top repeat buyers.
  * *Business Goal:* Get existing customers to buy more often and spend more over time.

* **Basket Building & Cross-Selling:** Show cheap accessories at online checkout whenever a customer buys an expensive item.
  * *Data Insight:* Most sales volume comes from main categories (Computers & Home Appliances).
  * *Business Goal:* Increase average order totals and get customers to add more items to their cart.

---

## 📂 Data Cleaning & Analysis Workflow
<details>
 <summary>Click to view detailed BigQuery SQL & methodology breakdown</summary>
<p></p>
 
This project followed a systematic end-to-end data pipeline in **SQL (Google BigQuery)**, progressing from structural audits to multi-dimensional Exploratory Data Analysis (EDA).

### 1. Initial Schema & Integrity Audit
* **Schema Verification:** Queried `INFORMATION_SCHEMA.COLUMNS` to validate column structures, positional orders, and target data types across all 5 raw tables (`Customers`, `Exchange_Rates`, `Products`, `Sales`, `Stores`).
* **Null & Completeness Checks:** Verified 100% data completeness across 4 out of 5 entities. Identified expected business logic in `Sales.Delivery_Date` where 49,719 `NULL` values corresponded directly to in-store purchases (immediate fulfillment) versus 13,165 valid delivery timestamps for online orders.
* **Deduplication:** Tested logical entity criteria (e.g., `Name + Birthday` for Customers, `Order Number + Line Item` for Sales). Confirmed zero duplicated records while preserving valid physical store branches sharing state locations.

### 2. Data Cleaning & Transformation
* **String Normalization:** Cleaned `Customers.Name` and `Customers.City` by stripping unwanted special characters (`?`), trimming extra spaces, removing parenthetical county details, and applying proper Title Case.
* **Referential Integrity Validation:** Ensured 100% valid Foreign Key mappings (`ProductKey`, `CustomerKey`, `StoreKey`) from the `Sales` fact table to all dimension tables with zero orphan records.
* **Financial & Domain Logic:** Audited product hierarchy to ensure every subcategory linked to a single category. Verified that all unit prices exceeded unit costs, ensuring zero negative-margin products.
* **Multi-Currency Mapping:** Verified complete date and currency coverage between `Sales` and `Exchange_Rates` to guarantee accurate conversion rates for global transactions.

### 3. Exploratory Data Analysis (EDA) in BigQuery
* **Aggregation & Rollups:** Structured `GROUP BY` queries across product categories, subcategories, and order years to calculate total revenue, net profit, and profit margins.
* **Geographic & Channel Breakdown:** Multi-table `JOIN` operations between `Sales`, `Stores`, and `Customers` to evaluate cross-border channel economics and regional volume splits.
* **Customer Lifetime Value & NTILE Percentile Bucketing:** Leveraged window functions (`NTILE(100) OVER (ORDER BY customer_total_spend DESC)`) inside Common Table Expressions (CTEs) to segment buyers into 100 percentile tiers and calculate non-overlapping Pareto revenue concentration.
* **Time-Series Analysis:** Utilized `DATE_DIFF` and calendar functions to analyze multi-year growth patterns, age cohort demographics, and seasonal holiday demand.


</details>
