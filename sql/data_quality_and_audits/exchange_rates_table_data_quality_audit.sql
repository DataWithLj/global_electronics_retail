--Exchange Rates Table Data Quality Audit
SELECT
  'exchange_rates' AS table_name,
  COUNT(*) AS total_rows,
  COUNTIF(Date IS NULL) AS count_null_date,
  COUNTIF(Exchange IS NULL)AS count_null_exchange,
  CAST(MIN(Exchange) AS STRING) AS min_range,
  CAST(MAX(Exchange) AS STRING) AS max_range,
  CAST(MIN(Date) AS STRING) AS min_date,
  CAST(MAX(Date) AS STRING) AS max_date
FROM `casestudyanalysis.electronics_retail.exchange_rates`
