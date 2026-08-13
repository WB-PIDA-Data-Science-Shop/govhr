# Compute the proportion of consistent records in a data frame.

Compute the proportion of consistent records in a data frame.

## Usage

``` r
compute_record_consistency(data, id_col, group_cols = NULL, digits = 2)
```

## Arguments

- data:

  A data frame.

- id_col:

  A character string specifying the name of the column that uniquely
  identifies records (e.g., "personnel_id" or "contract_id").

- group_cols:

  A character vector specifying the names of the columns to group by.
  Default is NULL, which means no grouping.

- digits:

  An integer specifying the number of decimal places to round the result
  to. Default is 2.

## Value

A data frame with the proportion of consistent records in the data
frame, optionally by group.

## Details

A record is considered consistent if it has a unique identifier and all
its associated values are consistent. The function computes the
proportion of consistent records in the data frame, optionally grouped
by specified columns.

## Examples

``` r
govhr::compute_record_consistency(
 data = govhr::bra_hrmis_personnel,
 id_col = "personnel_id",
)
#> # A tibble: 1 × 1
#>   record_consistency
#>                <dbl>
#> 1                100
```
