# Compute retirements

Counts, for each reference date, how many people are active and how many
of them leave active status by the next date into a pension, i.e. whose
next status after leaving is pensioner.

## Usage

``` r
compute_retirement(data, ...)

# S3 method for class 'data.frame'
compute_retirement(
  data,
  group_cols = NULL,
  status_col = "employment_status",
  ...
)

# S3 method for class 'tbl_dbi'
compute_retirement(
  data,
  group_cols = NULL,
  status_col = "employment_status",
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with one row per
  person-record. Must contain `personnel_id`, `ref_date` and the column
  named in `status_col`.

- ...:

  Arguments passed to methods.

- group_cols:

  Character vector of columns to group by, such as `"est_id"`, or `NULL`
  (default) for the whole workforce. Must not include `ref_date`.

- status_col:

  Character. Column holding employment status, with active personnel
  recorded as `"active"` and retirees as `"pensioner"`. Default
  `"employment_status"`.

## Value

A table with one row per `ref_date` and group, containing:

- headcount:

  Number of active people.

- retirements:

  Active people who are no longer active on the next date and are next
  recorded as pensioners. `NA` on the last date, which has nothing to
  compare with.

- retirement_rate:

  `retirements` divided by `headcount`.

A data.table for data frame input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

The next date is the neighbouring date found in the data, so the dates
do not need to be evenly spaced. People are counted once per date, even
if they hold several contracts. With `group_cols`, each person is
counted in the group they belong to on that date.

Pension registration can lag the exit, so the pensioner record may
appear at any later date, not only the next one. A retirement is dated
by the exit, not by the registration. A person who returns to active
work before any pensioner record counts as a separation, not a
retirement, at the earlier exit. There is no limit on the lag, so an
exit followed years later by a deferred pension also counts as a
retirement.

## See also

[`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md),
whose separations include these retirements and whose rates share their
denominator.
[`detect_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_retirement.md),
which flags the retirements of each person.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 2, 1, 2, 2),
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01", "2022-01-01"
  )),
  employment_status = c("active", "active", "pensioner", "active", "active")
)
compute_retirement(hr)
#>      ref_date headcount retirements retirement_rate
#>        <Date>     <int>       <int>           <num>
#> 1: 2020-01-01         2           1             0.5
#> 2: 2021-01-01         1           0             0.0
#> 3: 2022-01-01         1          NA              NA
```
