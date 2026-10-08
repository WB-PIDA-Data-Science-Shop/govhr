# Compute record consistency

Computes, for each group, the share of identifiers that appear in
exactly one record per reference date, as a percentage.

## Usage

``` r
compute_record_consistency(data, ...)

# S3 method for class 'data.frame'
compute_record_consistency(data, id_col, group_cols = NULL, digits = 2, ...)

# S3 method for class 'tbl_dbi'
compute_record_consistency(data, id_col, group_cols = NULL, digits = 2, ...)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with `ref_date` and
  the columns named in `id_col` and `group_cols`.

- ...:

  Arguments passed to methods.

- id_col:

  Character. Column identifying the entity, such as `"personnel_id"`.

- group_cols:

  Character vector of columns to group by, such as `"ref_date"`, or
  `NULL` (default) for the whole table.

- digits:

  Whole number. Decimal places to round to. Default `2`.

## Value

A table with the grouping columns and `record_consistency`, from 0 to
100. A data.table for data frame input; a lazy table for `tbl_dbi` input
(use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Records are counted per identifier, `ref_date` and group. A combination
with exactly one record is consistent, and `record_consistency` is the
share of consistent combinations in each group. Missing identifiers and
groups are kept as their own value.

## See also

[`compute_value_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_value_consistency.md),
which checks that each identifier keeps the same value.
[`compute_global_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_global_consistency.md),
which combines both.

## Examples

``` r
hr <- data.frame(
  personnel_id = c("a", "a", "b"),
  ref_date = as.Date("2020-01-01")
)
compute_record_consistency(hr, id_col = "personnel_id")
#>    record_consistency
#>                 <num>
#> 1:                 50
```
