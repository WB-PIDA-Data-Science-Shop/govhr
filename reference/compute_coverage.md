# Compute data coverage

Computes, for each group, the share of non-missing values in every other
column, as a percentage. Optionally averages the shares across columns,
giving one coverage value per group.

## Usage

``` r
compute_coverage(data, ...)

# S3 method for class 'data.frame'
compute_coverage(
  data,
  group_cols = NULL,
  include_ref_date = FALSE,
  aggregate = FALSE,
  ...
)

# S3 method for class 'tbl_dbi'
compute_coverage(
  data,
  group_cols = NULL,
  include_ref_date = FALSE,
  aggregate = FALSE,
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`).

- ...:

  Arguments passed to methods.

- group_cols:

  Character vector of columns to group by, or `NULL` (default) for no
  grouping.

- include_ref_date:

  Logical. Also group by `ref_date`. Default `FALSE`.

- aggregate:

  Logical. Average the coverage across columns, giving one value per
  group. Default `FALSE`.

## Value

A table with the grouping columns, `variable` (the name of a column,
unless `aggregate` is `TRUE`) and `coverage` (the share of non-missing
values, from 0 to 100). A data.table, also for `tbl_dbi` input.

## Details

Every column that is not a grouping column is covered, identifiers
included. Missing groups are kept as their own group. With
`aggregate = TRUE`, every column weighs equally in the average.

For `tbl_dbi` input, the coverage of every column is computed in the
database, giving one row per group, and only that summary is brought
into memory to be reshaped.

## See also

[`compute_global_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_global_coverage.md),
which gives a single coverage value for the whole table.
[`plot_coverage_trend()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_coverage_trend.md),
[`plot_coverage_bar()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_coverage_bar.md)
and
[`plot_coverage_heatmap()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_coverage_heatmap.md),
which draw coverage.

## Examples

``` r
hr <- data.frame(
  ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01")),
  gender = c("F", NA, "M"),
  birth_date = as.Date(c("1980-01-01", NA, NA))
)
compute_coverage(hr, include_ref_date = TRUE)
#>      ref_date   variable coverage
#>        <Date>     <char>    <num>
#> 1: 2020-01-01     gender       50
#> 2: 2020-01-01 birth_date       50
#> 3: 2021-01-01     gender      100
#> 4: 2021-01-01 birth_date        0
```
