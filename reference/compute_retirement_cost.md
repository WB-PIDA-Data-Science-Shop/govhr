# Compute the cost of retirements

Adds up, for each reference date, the pay of the people who retire at
that date.

## Usage

``` r
compute_retirement_cost(data, ...)

# S3 method for class 'data.frame'
compute_retirement_cost(
  data,
  measure_col,
  group_cols = NULL,
  status_col = "employment_status",
  ...
)

# S3 method for class 'tbl_dbi'
compute_retirement_cost(
  data,
  measure_col,
  group_cols = NULL,
  status_col = "employment_status",
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with one row per
  person-record. Must contain `personnel_id`, `ref_date` and the columns
  named in `measure_col` and `status_col`.

- ...:

  Arguments passed to methods.

- measure_col:

  Character. Name of the pay column to add up.

- group_cols:

  Character vector of columns to group by, such as `"est_id"`, or `NULL`
  (default) for the whole workforce. Must not include `ref_date`.

- status_col:

  Character. Column holding employment status, with active personnel
  recorded as `"active"` and retirees as `"pensioner"`. Default
  `"employment_status"`.

## Value

A table with one row per `ref_date` and group, containing
`retirement_cost`, the retirees' pay. `retirement_cost` is 0 when nobody
retired, and `NA` on the last date, which has nothing to compare with. A
data.table for data frame input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Retirees are costed at their pay on their last active date. The pay on
all of a retiree's active records that date is added up, so people with
several contracts are costed in full; pay recorded alongside, such as a
pension, is not. Missing pay counts as 0.

With `group_cols`, each retiree's pay is counted in the group of the
record it comes from. Every group with active personnel on a date
appears for that date.

## See also

[`detect_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_retirement.md),
which flags the retirees.
[`compute_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_retirement.md),
which counts them.
[`compute_movement_cost()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement_cost.md),
which costs the hires and separations.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 2, 1, 2),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 2)),
  employment_status = c("active", "active", "pensioner", "active"),
  wage = c(100, 250, 60, 250)
)
compute_retirement_cost(hr, measure_col = "wage")
#>      ref_date retirement_cost
#>        <Date>           <num>
#> 1: 2020-01-01             100
#> 2: 2021-01-01              NA
```
