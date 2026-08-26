--Stores Table Data Quality Audit
SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT StoreKey) AS unique_keys,
  CAST(MIN(`Open Date`) AS STRING) AS min_open,
  CAST(MAX(`Open Date`) AS STRING) AS max_open
FROM `casestudyanalysis.electronics_retail.stores`