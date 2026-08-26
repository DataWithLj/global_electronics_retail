-- Product Table Data Integrity Verification
-- Check for distinct values and count NULL/missing values across product attributes
SELECT
  ARRAY_AGG(DISTINCT Subcategory) AS distinct_subcategory,
  ARRAY_AGG(DISTINCT Color) AS distinct_color,
  ARRAY_AGG(DISTINCT Brand) AS distinct_brand,

  COUNTIF(`Product Name` IS NULL) AS missing_product_name,
  COUNTIF(Brand IS NULL) AS missing_brand,
  COUNTIF(Color IS NULL) AS missing_color,
  COUNTIF(`Unit Cost USD` IS NULL) AS missing_unit_cost,
  COUNTIF(`Unit Price USD` IS NULL) AS missing_unit_price,
  COUNTIF(Subcategory IS NULL) AS missing_subcategory,
  COUNTIF(SubcategoryKey IS NULL) AS missing_subcategorykey,
  COUNTIF(CategoryKey IS NULL) AS missing_categorykey,
  COUNTIF(Category IS NULL) AS missing_category
FROM `casestudyanalysis.electronics_retail.products`;

-- Check for 1-to-many hierarchy violations: Subcategory mapped to multiple Categories
SELECT 
  Subcategory,
  COUNT(DISTINCT Category) AS distinct_category_count,
  ARRAY_AGG(DISTINCT Category) AS mapped_categories
FROM `casestudyanalysis.electronics_retail.products`
GROUP BY Subcategory
HAVING distinct_category_count > 1;

-- Check if CategoryKey belongs to more than 1 Category name
SELECT 
  CategoryKey,
  COUNT(DISTINCT Category) AS distinct_category_count,
  ARRAY_AGG(DISTINCT Category) AS mapped_categories
FROM `casestudyanalysis.electronics_retail.products`
GROUP BY CategoryKey
HAVING distinct_category_count > 1;

-- Check for 1-to-many hierarchy violations: SubcategoryKey mapped to multiple Subcategory names
SELECT 
  SubcategoryKey,
  COUNT(DISTINCT Subcategory) AS distinct_subcategory_count,
  ARRAY_AGG(DISTINCT Subcategory) AS mapped_subcategories
FROM `casestudyanalysis.electronics_retail.products`
GROUP BY SubcategoryKey
HAVING distinct_subcategory_count > 1;

-- Check for pricing anomalies: Unit Cost exceeds Unit Price (negative gross margin)
SELECT 
  `Product Name`,
  `Unit Cost USD`,
  `Unit Price USD`,
FROM `casestudyanalysis.electronics_retail.products`
WHERE `Unit Cost USD` > `Unit Price USD`;

-- Check for invalid price values: Non-positive (<= 0) Unit Cost or Unit Price
SELECT 
  ProductKey,
  `Product Name`,
  `Unit Cost USD`,
  `Unit Price USD`
FROM `casestudyanalysis.electronics_retail.products`
WHERE `Unit Cost USD` <= 0
   OR `Unit Price USD` <= 0;

-- Check text formatting issues: Leading/trailing whitespace and non-standard special characters in Product Name 
SELECT
  COUNTIF(LENGTH(`Product Name`) != LENGTH(TRIM(`Product Name`))) AS name_has_whitespace,
  COUNTIF(REGEXP_CONTAINS(`Product Name`, r"""[^a-zA-Z0-9\s\-&"/.,'():]""")) AS product_name_invalid_chars
FROM `casestudyanalysis.electronics_retail.products`;







