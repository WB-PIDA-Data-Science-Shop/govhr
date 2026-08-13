# Compute the proportion of consistent records and values in a data frame.

Compute the proportion of consistent records and values in a data frame.

## Usage

``` r
compute_global_consistency(data, id_col, value_cols, digits = 2)
```

## Arguments

- data:

  A data frame.

- id_col:

  A character string specifying the name of the column that uniquely
  identifies records.

- value_cols:

  A character vector specifying the name(s) of columns whose values are
  to be checked for consistency. Value consistency is computed
  separately for each column and averaged across columns before being
  combined with record consistency.

- digits:

  An integer specifying the number of decimal places to round the result
  to. Default is 2.

## Value

A numeric value representing the proportion of consistent records and
values in the data frame.

## Details

Consistency is defined as the proportion of records and values that are
consistent across the dataset. A record is considered consistent if it
has a unique identifier and all its associated values are consistent. A
value is considered consistent if it does not contradict other values
for the same record.

## Examples

``` r
govhr::compute_global_consistency(
  data = govhr::bra_hrmis_personnel,
  id_col = "personnel_id",
  value_cols = c("birth_date")
)
#> [1] 100
```
