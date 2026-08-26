-- Sales Data Quality Audit
-- Check total rows and missing/null values
SELECT
  'sales' AS table_name,
  COUNT(*) AS total_rows,
  COUNTIF(`Order Number` IS NULL) AS null_order_num,
  COUNTIF(`Line Item` IS NULL) AS null_line_num,
  COUNTIF(`Order Date` IS NULL) AS null_orddate,
  COUNTIF(`Delivery Date` IS NULL) AS null_deldates,
  COUNTIF(CustomerKey IS NULL) AS null_customer_keys,
  COUNTIF(StoreKey IS NULL) AS null_store_key,
  COUNTIF(ProductKey IS NULL) AS null_product_keys,
  COUNTIF(Quantity IS NULL) AS null_quantity,
  COUNTIF(`Currency Code` IS NULL) AS null_currency,
  CAST(MIN(`Order Date`) AS STRING) AS min_orddate,
  CAST(MAX(`Order Date`) AS STRING) AS max_orddate,
  CAST(MIN(Quantity) AS STRING) AS min_quantity,
  CAST(MAX(Quantity) AS STRING) AS max_quantity
FROM `casestudyanalysis.electronics_retail.sales`;


-- Checking non-null delivery date counts for online (StoreKey 0) vs physical stores
SELECT

  COUNTIF(StoreKey = 0 AND `Delivery Date` IS NOT NULL) AS online_deldate,

  COUNTIF(StoreKey != 0 AND `Delivery Date` IS NOT NULL) AS physical_deldate

FROM `casestudyanalysis.electronics_retail.sales`;


-- Check for invalid delivery dates (Delivery Date occurs before Order Date)
SELECT
  COUNT(*) AS mismatched_rows
FROM `casestudyanalysis.electronics_retail.sales`
WHERE 
  `Delivery Date` IS NOT NULL
  AND `Delivery Date` < `Order Date`