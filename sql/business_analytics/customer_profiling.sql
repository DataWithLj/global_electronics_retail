-- Core Customer Profiling

-- Revenue base on age brackets
SELECT
  CASE
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) < 18 THEN 'Minor'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 18 AND 25 THEN 'Young Adults'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 26 AND 35 THEN 'Young Professionals'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 36 AND 50 THEN 'Mid-Life Consumers'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 51 AND 65 THEN 'Mature Affluents'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) > 65 THEN 'Seniors'
  END AS demographic_group,
  SUM(products.`Unit Price USD` * sales.Quantity) AS total_revenue_usd,
  SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity) AS total_profit_usd,
  SAFE_DIVIDE(
    SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity),
    SUM(products.`Unit Price USD` * sales.Quantity)
  ) * 100 AS profit_margin_percentage

FROM `casestudyanalysis.electronics_retail.cleaned_customers` AS customers
INNER JOIN `casestudyanalysis.electronics_retail.sales` AS sales
  ON customers.CustomerKey = sales.CustomerKey
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey
GROUP BY 1
ORDER BY
  total_revenue_usd DESC;

-- Revenue base on country
SELECT
  customers.Country,
  SUM(products.`Unit Price USD` * sales.Quantity) AS total_revenue_usd,
  SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity) AS total_profit_usd,
  SAFE_DIVIDE(
    SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity),
    SUM(products.`Unit Price USD` * sales.Quantity)
  ) * 100 AS profit_margin_percentage

FROM `casestudyanalysis.electronics_retail.cleaned_customers` AS customers
INNER JOIN `casestudyanalysis.electronics_retail.sales` AS sales
  ON customers.CustomerKey = sales.CustomerKey
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey
GROUP BY customers.Country
ORDER BY
  total_revenue_usd DESC;

-- Revenue base on gender
SELECT
  SUM(CASE WHEN customers.Gender = 'Male' THEN products.`Unit Price USD` * sales.Quantity ELSE 0 END) AS male_revenue_usd,
  SUM(CASE WHEN customers.Gender = 'Male' THEN (products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity ELSE 0 END) AS male_profit_usd,
  SUM(CASE WHEN customers.Gender = 'Female' THEN products.`Unit Price USD` * sales.Quantity ELSE 0 END) AS female_revenue_usd,
  SUM(CASE WHEN customers.Gender = 'Female' THEN (products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity ELSE 0 END) AS female_profit_usd,
  SUM(CASE WHEN customers.Gender = 'Male' THEN products.`Unit Price USD` * sales.Quantity ELSE 0 END) -
  SUM(CASE WHEN customers.Gender = 'Female' THEN products.`Unit Price USD` * sales.Quantity ELSE 0 END) AS revenue_diff_usd
FROM `casestudyanalysis.electronics_retail.cleaned_customers` AS customers
INNER JOIN `casestudyanalysis.electronics_retail.sales` AS sales
  ON customers.CustomerKey = sales.CustomerKey
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey;

-- Revenue base on age brackets and gender
SELECT
  customers.Gender,
  CASE
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) < 18 THEN 'Minor'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 18 AND 25 THEN 'Young Adults'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 26 AND 35 THEN 'Young Professionals'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 36 AND 50 THEN 'Mid-Life Consumers'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 51 AND 65 THEN 'Mature Affluents'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) > 65 THEN 'Seniors'
  END AS demographic_group,
  SUM(products.`Unit Price USD` * sales.Quantity) AS total_revenue_usd,
  SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity) AS total_profit_usd,
  SAFE_DIVIDE(
    SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity),
    SUM(products.`Unit Price USD` * sales.Quantity)
  ) * 100 AS profit_margin_percentage

FROM `casestudyanalysis.electronics_retail.cleaned_customers` AS customers
INNER JOIN `casestudyanalysis.electronics_retail.sales` AS sales
  ON customers.CustomerKey = sales.CustomerKey
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey
GROUP BY
  customers.Gender,
  2
ORDER BY
  total_revenue_usd DESC;

-- Revenue base on age brackets and counry
SELECT
  customers.Country,
  CASE
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) < 18 THEN 'Minor'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 18 AND 25 THEN 'Young Adults'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 26 AND 35 THEN 'Young Professionals'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 36 AND 50 THEN 'Mid-Life Consumers'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) BETWEEN 51 AND 65 THEN 'Mature Affluents'
    WHEN DATE_DIFF(sales.`Order Date`, customers.Birthday, YEAR) > 65 THEN 'Seniors'
  END AS demographic_group,
  SUM(products.`Unit Price USD` * sales.Quantity) AS total_revenue_usd,
  SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity) AS total_profit_usd,
  SAFE_DIVIDE(
    SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity),
    SUM(products.`Unit Price USD` * sales.Quantity)
  ) * 100 AS profit_margin_percentage

FROM `casestudyanalysis.electronics_retail.cleaned_customers` AS customers
INNER JOIN `casestudyanalysis.electronics_retail.sales` AS sales
  ON customers.CustomerKey = sales.CustomerKey
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey
GROUP BY
  customers.Country,
  2
ORDER BY
  total_revenue_usd DESC;

-- Revenue Contribution by Top Customer Percentiles (1%, 10%, 20%)
-- Step 1: Calculate lifetime spend for every single unique customer
WITH customer_lifetime_spend AS (
  SELECT
    customers.CustomerKey,
    SUM(products.`Unit Price USD` * sales.Quantity) AS customer_total_spend
  FROM `casestudyanalysis.electronics_retail.cleaned_customers` AS customers
  INNER JOIN `casestudyanalysis.electronics_retail.sales` AS sales
    ON customers.CustomerKey = sales.CustomerKey
  INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
    ON sales.ProductKey = products.ProductKey
  GROUP BY
    customers.CustomerKey
),

-- Step 2: Rank customers into 100 buckets (1 = highest spenders, 100 = lowest spenders)
ranked_customers AS (
  SELECT
    CustomerKey,
    customer_total_spend,
    NTILE(100) OVER (ORDER BY customer_total_spend DESC) AS spend_percentile
  FROM customer_lifetime_spend
)

-- Step 3: Aggregate spend for Top 1%, Top 10%, and Top 20%
SELECT
  -- Revenue sums for each top group
  SUM(CASE WHEN spend_percentile <= 1 THEN customer_total_spend ELSE 0 END) AS top_1_pct_revenue,
  SUM(CASE WHEN spend_percentile <= 10 THEN customer_total_spend ELSE 0 END) AS top_10_pct_revenue,
  SUM(CASE WHEN spend_percentile <= 20 THEN customer_total_spend ELSE 0 END) AS top_20_pct_revenue,

  -- Percentage share of overall total revenue ($55.75M)
  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN spend_percentile <= 1 THEN customer_total_spend ELSE 0 END),
      SUM(customer_total_spend)
    ) * 100, 2
  ) AS top_1_pct_share,

  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN spend_percentile <= 10 THEN customer_total_spend ELSE 0 END),
      SUM(customer_total_spend)
    ) * 100, 2
  ) AS top_10_pct_share,

  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN spend_percentile <= 20 THEN customer_total_spend ELSE 0 END),
      SUM(customer_total_spend)
    ) * 100, 2
  ) AS top_20_pct_share

FROM ranked_customers;

-- Nonoverlapping ranking
WITH customer_lifetime_spend AS (
  SELECT
    customers.CustomerKey,
    SUM(products.`Unit Price USD` * sales.Quantity) AS customer_total_spend
  FROM `casestudyanalysis.electronics_retail.cleaned_customers` AS customers
  INNER JOIN `casestudyanalysis.electronics_retail.sales` AS sales
    ON customers.CustomerKey = sales.CustomerKey
  INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
    ON sales.ProductKey = products.ProductKey
  GROUP BY
    customers.CustomerKey
),

ranked_customers AS (
  SELECT
    CustomerKey,
    customer_total_spend,
    NTILE(100) OVER (ORDER BY customer_total_spend DESC) AS spend_percentile
  FROM customer_lifetime_spend
)

SELECT
  -- Non-overlapping Revenue Tiers
  SUM(CASE WHEN spend_percentile = 1 THEN customer_total_spend ELSE 0 END) AS top_1_pct_revenue,
  SUM(CASE WHEN spend_percentile BETWEEN 2 AND 10 THEN customer_total_spend ELSE 0 END) AS next_9_pct_revenue,
  SUM(CASE WHEN spend_percentile BETWEEN 11 AND 20 THEN customer_total_spend ELSE 0 END) AS next_10_pct_revenue,
  SUM(CASE WHEN spend_percentile > 20 THEN customer_total_spend ELSE 0 END) AS remaining_80_pct_revenue,

  -- Non-overlapping Revenue Share Percentages
  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN spend_percentile = 1 THEN customer_total_spend ELSE 0 END),
      SUM(customer_total_spend)
    ) * 100, 2
  ) AS top_1_pct_share,

  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN spend_percentile BETWEEN 2 AND 10 THEN customer_total_spend ELSE 0 END),
      SUM(customer_total_spend)
    ) * 100, 2
  ) AS next_9_pct_share,

  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN spend_percentile BETWEEN 11 AND 20 THEN customer_total_spend ELSE 0 END),
      SUM(customer_total_spend)
    ) * 100, 2
  ) AS next_10_pct_share,

  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN spend_percentile > 20 THEN customer_total_spend ELSE 0 END),
      SUM(customer_total_spend)
    ) * 100, 2
  ) AS remaining_80_pct_share

FROM ranked_customers;




