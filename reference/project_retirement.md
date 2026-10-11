# Project retirements of the current workforce

Projects, for each year ahead, how many people in the current workforce
reach the retirement age, what share of the current headcount they make
up and, optionally, what their retirement costs are. The current
workforce is everyone active on the latest reference date.

## Usage

``` r
project_retirement(data, ...)

# S3 method for class 'data.frame'
project_retirement(
  data,
  threshold_age = 60,
  birth_col = "birth_date",
  group_cols = NULL,
  measure_col = NULL,
  status_col = "employment_status",
  retirement_coefficient = 0.6,
  horizon = 10,
  ...
)

# S3 method for class 'tbl_dbi'
project_retirement(
  data,
  threshold_age = 60,
  birth_col = "birth_date",
  group_cols = NULL,
  measure_col = NULL,
  status_col = "employment_status",
  retirement_coefficient = 0.6,
  horizon = 10,
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with one row per
  person-record. Must contain `personnel_id`, `ref_date` and the columns
  named in `birth_col` and `status_col`, and in `measure_col` if given.

- ...:

  Arguments passed to methods.

- threshold_age:

  Whole number. Age at which people retire. Default `60`.

- birth_col:

  Character. Column holding dates of birth. Default `"birth_date"`.

- group_cols:

  Character vector of columns to group by, such as `"est_id"`, or `NULL`
  (default) for the whole workforce. Must not include `ref_date`.

- measure_col:

  Character. Pay column used to cost the retirements, or `NULL`
  (default) to only count them.

- status_col:

  Character. Column holding employment status, with active personnel
  recorded as `"active"`. Default `"employment_status"`.

- retirement_coefficient:

  Number. Share of their pay that retirees go on receiving as a pension,
  used to cost the retirements. Default `0.6`.

- horizon:

  Whole number. How many years past the latest reference date to
  project. Default `10`.

## Value

A table with one row per projected year and group, containing:

- ref_date:

  The last day of the year in which people reach `threshold_age`.

- headcount:

  Number of people in the current workforce.

- projected_retirements:

  People in the current workforce who reach `threshold_age` that year.

- projected_retirement_rate:

  `projected_retirements` divided by `headcount`.

- projected_cost:

  Only with `measure_col`: the retirees' pay on the latest date, times
  `retirement_coefficient`.

A data.table for data frame input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Only people active on the latest date are projected: people who left
earlier, or whose record that date is not active, are no longer in the
workforce. Nor are people who reached `threshold_age` by the latest
date, even if they are still active.

The projected years are those whose last day falls after the latest date
and at most `horizon` years after it. Every group in the current
workforce appears in every year, with zero retirements when nobody
reaches `threshold_age`.

People are counted once, even if they hold several contracts, and the
pay on all their contracts is costed. With `group_cols`, each person is
counted in the group they belong to on the latest date. People with a
missing `personnel_id` are not counted, as in
[`compute_headcount()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_headcount.md).

## See also

[`compute_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_retirement.md),
which counts the retirements that already happened.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 2, 3, 1, 2, 3),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
  employment_status = c(rep("active", 5), "pensioner"),
  birth_date = as.Date(rep(c("1962-05-01", "1990-01-01", "1950-01-01"), 2)),
  gross_salary_lcu = c(100, 200, 300, 110, 210, 90)
)
project_retirement(hr, measure_col = "gross_salary_lcu")
#>       ref_date headcount projected_retirements projected_retirement_rate
#>         <Date>     <int>                 <int>                     <num>
#>  1: 2021-12-31         2                     0                       0.0
#>  2: 2022-12-31         2                     1                       0.5
#>  3: 2023-12-31         2                     0                       0.0
#>  4: 2024-12-31         2                     0                       0.0
#>  5: 2025-12-31         2                     0                       0.0
#>  6: 2026-12-31         2                     0                       0.0
#>  7: 2027-12-31         2                     0                       0.0
#>  8: 2028-12-31         2                     0                       0.0
#>  9: 2029-12-31         2                     0                       0.0
#> 10: 2030-12-31         2                     0                       0.0
#>     projected_cost
#>              <num>
#>  1:              0
#>  2:             66
#>  3:              0
#>  4:              0
#>  5:              0
#>  6:              0
#>  7:              0
#>  8:              0
#>  9:              0
#> 10:              0
```
