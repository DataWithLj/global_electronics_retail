--Products Table Data Quality Audit
SELECT
  'products' AS table_name,
  COUNT(*) AS total_rows,
  COUNT(DISTINCT ProductKey) AS unique_keys,
  COUNTIF(ProductKey IS NULL) AS count_null_keys,
  CAST(MIN(`Unit Cost USD`) AS STRING) AS min_cost,
  CAST(MAX(`Unit Cost USD`) AS STRING) AS max_cost,
  CAST(MIN(`Unit Price USD`) AS STRING) AS min_price,
  CAST(MAX(`Unit Price USD`) AS STRING) AS max_price
FROM `casestudyanalysis.electronics_retail.products`
;