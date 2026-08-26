--Checking duplicates for customers, exchange_rates, products, and sales
--customers table duplicate check
SELECT
  Name,
  Birthday,
  COUNT(*) AS duplicate_count
FROM `casestudyanalysis.electronics_retail.customers`
GROUP BY
  Name,
  Birthday
HAVING COUNT(*) > 1;

--echange_rates table duplicate check
SELECT
  Date,
  Currency,
  COUNT(*) AS duplicate_count
FROM `casestudyanalysis.electronics_retail.exchange_rates`
GROUP BY
  Date,
  Currency
HAVING COUNT(*) > 1;

--products table duplicate check
SELECT
  `Product Name`,
  Brand,
  Color,
  Subcategory,
  COUNT(*) AS duplicate_count
FROM `casestudyanalysis.electronics_retail.products`
GROUP BY
  `Product Name`,
  Brand,
  Color,
  Subcategory
HAVING COUNT(*) > 1;

--sales table duplicate check
SELECT
  `Order Number`,
  `Line Item`,
  COUNT(*) AS duplicate_count
FROM `casestudyanalysis.electronics_retail.sales`
GROUP BY
  `Order Number`,
  `Line Item`
HAVING COUNT(*) > 1;







