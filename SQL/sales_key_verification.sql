-- Foreign key integrity checks for the sales table
-- Verify if ProductKey in sales exists in the products table
SELECT
  COUNT(*) AS unmatched
FROM `casestudyanalysis.electronics_retail.sales` AS sales
LEFT JOIN `casestudyanalysis.electronics_retail.products` AS products
  ON  sales.ProductKey = products.ProductKey
WHERE products.ProductKey IS NULL;

-- Verify if CustomerKey in sales exists in the cleaned_customers table
SELECT
  COUNT(*) AS unmatched
FROM `casestudyanalysis.electronics_retail.sales` AS sales
LEFT JOIN `casestudyanalysis.electronics_retail.cleaned_customers` AS customers
  ON  sales.CustomerKey = customers.CustomerKey
WHERE customers.CustomerKey IS NULL;

-- Verify if StoreKey in sales exists in the stores table
SELECT
  COUNT(*) AS unmatched
FROM `casestudyanalysis.electronics_retail.sales` AS sales
LEFT JOIN `casestudyanalysis.electronics_retail.stores` AS store
  ON  sales.StoreKey = store.StoreKey
WHERE store.StoreKey IS NULL;



