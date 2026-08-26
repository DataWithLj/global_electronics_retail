/*
DATA TYPE CHECKS
Purpose: Verifies that column data types are assigned correctly across all five schemas.
*/
SELECT
  table_name,
  column_name,
  data_type
  FROM `casestudyanalysis.electronics_retail.INFORMATION_SCHEMA.COLUMNS`
  WHERE
    table_name IN ('customers', 'exchange_rates', 'products', 'sales', 'stores')
  ORDER BY
    table_name, ordinal_position