# Compute the proportion of consistent values in a data frame.

Compute the proportion of consistent values in a data frame.

## Usage

``` r
compute_value_consistency(
  data,
  id_col,
  value_col,
  group_cols = NULL,
  digits = 2
)
```

## Arguments

- data:

  A data frame.

- id_col:

  A character string specifying the name of the column that uniquely
  identifies records.

- value_col:

  A character string specifying the name of the column whose values are
  to be checked for consistency.

- group_cols:

  A character vector specifying the names of the columns to group by.
  Default is no grouping.

- digits:

  An integer specifying the number of decimal places to round the result
  to. Default is 2.

## Value

A data frame with the proportion of consistent values in the data frame,
optionally by group.

## Details

Consistency is broadly defined as the proportion of records and values
that are consistent across the dataset. A value is considered consistent
if it does not differ from other values for the same record. The
function computes the proportion of records with consistent values in
the data frame, optionally grouped by specified columns.

## Examples

``` r
govhr::compute_value_consistency(
 data = govhr::bra_hrmis_personnel,
 id_col = "personnel_id",
 value_col = "birth_date"
)
#> # A tibble: 1 × 1
#>   value_consistency
#>               <dbl>
#> 1               100
```
