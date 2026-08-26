-- Checking non-null delivery date counts for online (StoreKey 0) vs physical stores
SELECT
  COUNTIF(StoreKey = 0 AND `Delivery Date` IS NOT NULL) AS online_deldate,
  COUNTIF(StoreKey != 0 AND `Delivery Date` IS NOT NULL) AS physical_deldate
FROM `casestudyanalysis.electronics_retail.sales`