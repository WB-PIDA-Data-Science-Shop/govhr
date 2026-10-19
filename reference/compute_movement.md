# Compute movements as hires and separations

Counts, for each reference date, how many people are active, how many
joined since the previous date (hires) and how many left since the
previous date (separations). Hire, separation, and replacement rates are
also returned.

## Usage

``` r
compute_movement(data, ...)

# S3 method for class 'data.frame'
compute_movement(
  data,
  group_cols = NULL,
  status_col = "employment_status",
  ...
)

# S3 method for class 'tbl_dbi'
compute_movement(
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

  Character. Column holding employment status. Only rows equal to
  `"active"` are counted. Default `"employment_status"`.

## Value

A table with one row per `ref_date` and group, containing:

- headcount:

  Number of active people.

- hires:

  People active on this date but not on the previous one.

- separations:

  People active on the previous date but not on this one.

- hire_rate, separation_rate:

  `hires` and `separations` divided by the headcount on the previous
  date.

- replacement_rate:

  `hires` divided by `separations`.

Hires, separations and rates are `NA` on the first date, which has
nothing to compare with. A data.table for data frame input; a lazy table
for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

The previous date is the neighbouring date found in the data, so the
dates do not need to be evenly spaced.

Hires and separations both cover the time since the previous date, so on
every date after the first, `headcount` equals the previous date's
`headcount` plus `hires` minus `separations`.

People are counted once per date, even if they hold several contracts. A
separation is any exit from active status, including retirement.

With `group_cols`, each person is counted in the group they belong to on
that date, and each separation in the group the person left. A group
that everyone left still appears on the next date, with a `headcount` of
0. A group with nobody active on the previous date has no headcount to
compare with, so its separations and rates are `NA`. Moving from one
group to another is neither a hire nor a separation, so the headcount of
a group adds up only once those moves are counted too; use
[`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md)
to count them.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 2, 1, 3, 1, 3),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01"), each = 2)),
  employment_status = "active"
)
compute_movement(hr)
#>      ref_date headcount hires separations hire_rate separation_rate
#>        <Date>     <int> <int>       <int>     <num>           <num>
#> 1: 2020-01-01         2    NA          NA        NA              NA
#> 2: 2021-01-01         2     1           1       0.5             0.5
#> 3: 2022-01-01         2     0           0       0.0             0.0
#>    replacement_rate
#>               <num>
#> 1:               NA
#> 2:                1
#> 3:              NaN
```
