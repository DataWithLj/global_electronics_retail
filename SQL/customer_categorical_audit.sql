-- Audit customer table categorical values and null counts
SELECT
  -- Low-variety columns (shows all unique values per column)
  ARRAY_AGG(DISTINCT Gender IGNORE NULLS) AS distinct_genders,
  ARRAY_AGG(DISTINCT Country IGNORE NULLS) AS distinct_countries,
  ARRAY_AGG(DISTINCT Continent IGNORE NULLS) AS distinct_continents,

  -- NULL counts (to see if missing values exist)
  COUNTIF(Name IS NULL) AS missing_name_count,
  COUNTIF(Gender IS NULL) AS missing_gender_count,
  COUNTIF(City IS NULL) AS missing_city_count,
  COUNTIF(Country IS NULL) AS missing_country_count,
  COUNTIF(State IS NULL) AS missing_state_count,
  COUNTIF(Continent IS NULL) AS missing_continent_count,

FROM `casestudyanalysis.electronics_retail.customers`;


-- Check for leading/trailing whitespaces and unexpected special characters
SELECT
  COUNTIF(LENGTH(Name) != LENGTH(TRIM(Name))) AS name_has_whitespace,
  COUNTIF(LENGTH(City) != LENGTH(TRIM(City))) AS name_has_whitespace,
  COUNTIF(LENGTH(State) != LENGTH(TRIM(State))) AS name_has_whitespace,
  COUNTIF(REGEXP_CONTAINS(Name,r'[^\p{L}\s\-\']')) AS name_with_special,
  COUNTIF(REGEXP_CONTAINS(City,r'[^\p{L}\s\-\']')) AS city_with_special,
  COUNTIF(REGEXP_CONTAINS(State,r'[^\p{L}\s\-\']')) AS state_with_special
FROM `casestudyanalysis.electronics_retail.customers`;

-- Inspect records that contain special characters
SELECT
  Name,
  City,
  State
FROM `casestudyanalysis.electronics_retail.customers`
WHERE
  REGEXP_CONTAINS(Name,r'[^\p{L}\s\-\'\.\&/]') OR
  REGEXP_CONTAINS(City,r'[^\p{L}\s\-\'\.\&/]') OR
  REGEXP_CONTAINS(State,r'[^\p{L}\s\-\'\.\&/]');


-- Clean text fields (Name & City) and create cleaned table
CREATE OR REPLACE TABLE casestudyanalysis.electronics_retail.cleaned_customers AS
SELECT
  
  -- Clean Name: remove '?', normalize spaces, and convert to Title Case
  INITCAP(
    TRIM(
      REGEXP_REPLACE(
        REPLACE(Name, '?', ''), 
        r'\s+', ' '
      )
    )
  ) AS Name,
  
  -- Clean City: remove '?', strip text inside parentheses, normalize spaces, and convert to Title Case
  INITCAP(
    TRIM(
      REGEXP_REPLACE(
        REGEXP_REPLACE(
          REPLACE(City, '?', ''), 
          r'\s*\(.*?\)', ''   
        ),
        r'\s+', ' '            
      )
    )
  ) AS City,

  * EXCEPT(Name, City)

FROM casestudyanalysis.electronics_retail.customers;

-- Verify cleaned Name and City fields for remaining special characters
SELECT
  Name,
  City
FROM `casestudyanalysis.electronics_retail.cleaned_customers`
WHERE
  REGEXP_CONTAINS(Name,r'[^\p{L}\s\-\'\.\&/]') OR
  REGEXP_CONTAINS(City,r'[^\p{L}\s\-\'\.\&/]')