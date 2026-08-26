-- Determine the revenue, profits and profit margin of each category
SELECT
  products.Category,
  SUM(products.`Unit Price USD` * sales.Quantity) AS total_revenue_usd,
  SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity) AS total_profit_usd,
  SAFE_DIVIDE(
    SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity),
    SUM(products.`Unit Price USD` * sales.Quantity)
  ) * 100 AS profit_margin_percentage
FROM `casestudyanalysis.electronics_retail.sales` AS sales
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey
GROUP BY products.Category
ORDER BY total_profit_usd DESC;

-- Determine the profit of online and physical stores
SELECT
  CASE 
    WHEN sales.StoreKey = 0 THEN 'Online Store'
    ELSE 'Physical Store'
  END AS store_channel,
  SUM(products.`Unit Price USD` * sales.Quantity) AS total_revenue_usd,
  SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity) AS total_profit_usd,
  
FROM `casestudyanalysis.electronics_retail.sales` AS sales
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey
GROUP BY 1
ORDER BY total_profit_usd DESC;

-- Measures physical, online, and total revenue per country 
SELECT
  -- Use customer country so online-only countries are included
  CASE 
    WHEN sales.StoreKey = 0 THEN customers.Country
    ELSE stores.Country
    END AS country,

  -- Physical Store Revenue (StoreKey != 0) 
  SUM(
    CASE 
      WHEN sales.StoreKey != 0 THEN products.`Unit Price USD` * sales.Quantity 
      ELSE 0 
    END
  ) AS physical_rev_usd,

  -- Online Store Revenue (StoreKey = 0)
  SUM(
    CASE 
      WHEN sales.StoreKey = 0 THEN products.`Unit Price USD` * sales.Quantity 
      ELSE 0 
    END
  ) AS online_rev_usd,

  -- Total Revenue
  SUM(products.`Unit Price USD` * sales.Quantity) AS total_rev_usd,

  -- Online Share (%)
  ROUND(
    SAFE_DIVIDE(
      SUM(CASE WHEN sales.StoreKey = 0 THEN products.`Unit Price USD` * sales.Quantity ELSE 0 END),
      SUM(products.`Unit Price USD` * sales.Quantity)
    ) * 100, 
    1
  ) AS online_share_percentage

FROM `casestudyanalysis.electronics_retail.sales` AS sales
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey
LEFT JOIN `casestudyanalysis.electronics_retail.stores` AS stores
  ON sales.StoreKey = stores.StoreKey
LEFT JOIN `casestudyanalysis.electronics_retail.customers` AS customers
  ON sales.CustomerKey = customers.CustomerKey

GROUP BY
  country
ORDER BY
  total_rev_usd DESC;

-- StoreKey ranking in terms of revenue, profit, and profitability
SELECT
  sales.StoreKey,
  stores.`Open Date`,
  stores.State,
  stores.Country,
  
  SUM(products.`Unit Price USD` * sales.Quantity) AS total_revenue_usd,
  RANK() OVER (
    ORDER BY SUM(products.`Unit Price USD` * sales.Quantity) DESC
  ) AS revenue_rank,

  SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity) AS total_profit_usd,
  RANK() OVER (
    ORDER BY SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity) DESC
  ) AS profit_rank,
  
  SAFE_DIVIDE(
    SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity),
    SUM(products.`Unit Price USD` * sales.Quantity)
  ) * 100 AS profit_margin_percentage,
  RANK() OVER (
    ORDER BY SAFE_DIVIDE(
      SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity),
      SUM(products.`Unit Price USD` * sales.Quantity)
    ) DESC
  ) AS margin_rank

FROM `casestudyanalysis.electronics_retail.sales` AS sales
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey
INNER JOIN `casestudyanalysis.electronics_retail.stores` AS stores
  ON sales.StoreKey = stores.StoreKey
WHERE sales.StoreKey != 0 -- use comment if want to include Online Store(StoreKey = 0)
GROUP BY
  sales.StoreKey,
  stores.`Open Date`,
  stores.Country,
  stores.State
ORDER BY
  total_revenue_usd DESC;






















