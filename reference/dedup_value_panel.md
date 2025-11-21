# Deduplicate and disambiguate an attribute using both lag and lead values

Handles missing values and cases where the same date has conflicting
attribute values by inferring from the closest neighbor (lag first, then
lead).

## Usage

``` r
dedup_value_panel(data, attr_col, id_col, date_col)
```

## Arguments

- data:

  A data frame.

- attr_col:

  Attribute to disambiguate (unquoted).

- id_col:

  Unique identifier column (unquoted).

- date_col:

  Date column for ordering (unquoted).

## Value

A deduplicated data frame with attribute filled from neighbors when
missing or conflicting.

## Examples

``` r
library(tibble)

df <- tibble(
  personnel_id = c(1, 1, 1, 2, 2, 2, 2),
  gender    = c(NA, "M", "F", "F", NA, "M", "F"),
  ref_date  = as.Date(c(
    "2023-01-01", "2023-01-02", "2023-01-02",
    "2023-01-01", "2023-01-02", "2023-01-03", "2023-01-03"
  ))
)

dedup_value_panel(df, gender, personnel_id, ref_date)
#> # A tibble: 5 × 3
#>   personnel_id ref_date   gender
#>          <dbl> <date>     <chr> 
#> 1            1 2023-01-01 NA    
#> 2            1 2023-01-02 F     
#> 3            2 2023-01-01 F     
#> 4            2 2023-01-02 NA    
#> 5            2 2023-01-03 F     
```
