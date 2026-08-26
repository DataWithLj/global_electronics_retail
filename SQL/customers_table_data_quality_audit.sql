--Customers Table Data Quality Audit
SELECT
  'customers' AS table_name,
  COUNT(*) AS total_rows,
  COUNT(DISTINCT CustomerKey) AS unique_keys,
  COUNTIF(CustomerKey IS NULL) AS count_null_keys,
  CAST(MIN(CustomerKey) AS STRING) AS min_key,
  CAST(MAX(CustomerKey) AS STRING) AS max_key,
  CAST(MIN(Birthday) AS STRING) AS min_date,
  CAST(MAX(Birthday) AS STRING) AS max_date
  FROM `casestudyanalysis.electronics_retail.customers`


