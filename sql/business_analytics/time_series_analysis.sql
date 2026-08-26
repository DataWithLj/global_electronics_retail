-- Time series analysis
-- Annual revenue and profit
SELECT
  EXTRACT(YEAR FROM sales.`Order Date`) AS order_year,
  
  -- Total Revenue
  ROUND(SUM(products.`Unit Price USD` * sales.Quantity)/1000000, 2) AS total_rev_usd,
  
  -- Total Profit
  ROUND(SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity)/1000000, 2) AS total_profit_usd,
  
  -- Overall Profit Margin (%)
  ROUND(
    SAFE_DIVIDE(
      SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity),
      SUM(products.`Unit Price USD` * sales.Quantity)
    ) * 100, 
    2
  ) AS profit_margin_pct

FROM `casestudyanalysis.electronics_retail.sales` AS sales
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey

GROUP BY
  order_year
ORDER BY
  order_year ASC;

-- Month and Year revenue and profit
SELECT
  EXTRACT(MONTH FROM sales.`Order Date`) AS order_month,
  EXTRACT(YEAR FROM sales.`Order Date`) AS order_year,

  ROUND(SUM(products.`Unit Price USD` * sales.Quantity)/1000000, 2) AS total_rev_usd,
  ROUND(SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity)/1000000, 2) AS total_profit_usd,
  ROUND(
    SAFE_DIVIDE(
      SUM((products.`Unit Price USD` - products.`Unit Cost USD`) * sales.Quantity),
      SUM(products.`Unit Price USD` * sales.Quantity)
    ) * 100, 
    2
  ) AS profit_margin_pct


FROM `casestudyanalysis.electronics_retail.sales` AS sales
INNER JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON sales.ProductKey = products.ProductKey
GROUP BY  
  EXTRACT(MONTH FROM sales.`Order Date`),
  EXTRACT(YEAR FROM sales.`Order Date`)
ORDER BY
  order_month ASC,
  order_year ASC

  