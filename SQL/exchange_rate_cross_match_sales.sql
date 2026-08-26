-- Audit exchange_rates table distinct currency values and missing counts
-- Inspect distinct currencies (helps identify leading/lagging spaces) and check for NULLs
SELECT
  ARRAY_AGG(DISTINCT Currency) AS distinct_currency,
  COUNTIF(Currency IS NULL) AS missing_currency
FROM `casestudyanalysis.electronics_retail.exchange_rates`;

-- Check for sales records that lack a matching exchange rate by date and currency code
SELECT 
  COUNT(*) AS unmatched_sales_rows
FROM `casestudyanalysis.electronics_retail.sales` AS s
LEFT JOIN `casestudyanalysis.electronics_retail.exchange_rates` AS e
  ON s.`Order Date` = e.Date
  AND s.`Currency Code` = e.Currency
WHERE e.Exchange IS NULL;

-- Compare overall date ranges between sales and exchange_rates to verify date coverage
SELECT 
    MIN(s.`Order Date`) AS sales_start_date,
    MAX(s.`Order Date`) AS sales_end_date,
    MIN(e.Date) AS rates_start_date,
    MAX(e.Date) AS rates_end_date,
 
    CASE WHEN MIN(e.Date) <= MIN(s.`Order Date`) THEN 'COVERED' ELSE 'GAP AT START' END AS start_coverage_status,
    CASE WHEN MAX(e.Date) >= MAX(s.`Order Date`) THEN 'COVERED' ELSE 'GAP AT END' END AS end_coverage_status
FROM `casestudyanalysis.electronics_retail.sales` AS s
CROSS JOIN `casestudyanalysis.electronics_retail.exchange_rates` AS e
