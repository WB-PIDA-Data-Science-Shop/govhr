# Compute value consistency

Computes, for each group, the share of identifiers that keep a single
value of `value_col`, as a percentage.

## Usage

``` r
compute_value_consistency(data, ...)

# S3 method for class 'data.frame'
compute_value_consistency(
  data,
  id_col,
  value_col,
  group_cols = NULL,
  digits = 2,
  ...
)

# S3 method for class 'tbl_dbi'
compute_value_consistency(
  data,
  id_col,
  value_col,
  group_cols = NULL,
  digits = 2,
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with `ref_date` and
  the columns named in `id_col` and `group_cols`.

- ...:

  Arguments passed to methods.

- id_col:

  Character. Column identifying the entity, such as `"personnel_id"`.

- value_col:

  Character. Column whose values should stay the same for each
  identifier, such as `"birth_date"`.

- group_cols:

  Character vector of columns to group by, such as `"ref_date"`, or
  `NULL` (default) for the whole table.

- digits:

  Whole number. Decimal places to round to. Default `2`.

## Value

A table with the grouping columns and `value_consistency`, from 0 to
100. A data.table for data frame input; a lazy table for `tbl_dbi` input
(use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Distinct values of `value_col` are counted per identifier and group,
across all dates unless `ref_date` is one of `group_cols`. An identifier
with exactly one distinct value is consistent. A missing value counts as
a value of its own, so an identifier recorded with and without a value
is not consistent.

## See also

[`compute_record_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_record_consistency.md),
which checks that each identifier has one record per date.
[`compute_global_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_global_consistency.md),
which combines both.

## Examples

``` r
hr <- data.frame(
  personnel_id = c("a", "a", "b"),
  ref_date = as.Date(c("2020-01-01", "2021-01-01", "2020-01-01")),
  birth_date = as.Date(c("1980-01-01", "1981-01-01", "1990-01-01"))
)
compute_value_consistency(hr, id_col = "personnel_id", value_col = "birth_date")
#>    value_consistency
#>                <num>
#> 1:                50
```
