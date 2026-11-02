# Detect retirements

Detects, for each active person and reference date, whether they leave
active status by the next date into a pension, i.e. whether their next
status after leaving is pensioner.

## Usage

``` r
detect_retirement(data, ...)

# S3 method for class 'data.frame'
detect_retirement(data, status_col = "employment_status", ...)

# S3 method for class 'tbl_dbi'
detect_retirement(data, status_col = "employment_status", ...)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with one row per
  person-record. Must contain `personnel_id`, `ref_date` and the column
  named in `status_col`.

- ...:

  Arguments passed to methods.

- status_col:

  Character. Column holding employment status, with active personnel
  recorded as `"active"` and retirees as `"pensioner"`. Default
  `"employment_status"`.

## Value

A table with one row per active person and `ref_date`, containing
`personnel_id`, `ref_date`, `next_date` (the next date with active
personnel) and `retirement`: `TRUE` if the person retires by
`next_date`, and `NA` on the last date, which has nothing to compare
with. A data.table for data frame input; a lazy table for `tbl_dbi`
input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

A retirement is an exit from active status whose next status is
pensioner.
[`detect_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_movement.md)
counts every other exit as a separation, so every exit is either a
separation or a retirement, never both, and the two tables share their
rows. A pension drawn alongside an active contract is not a retirement.
As with separations, a retirement is flagged on the person's last active
date and counted by
[`compute_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_retirement.md)
on `next_date`, the first date they are absent.

Pension registration can lag the exit, so the pensioner record may
appear at any later date, not only the next one. A retirement is dated
by the exit, not by the registration. A person who returns to active
work before any pensioner record is not retired at the earlier exit.
There is no limit on the lag, so an exit followed years later by a
deferred pension also counts as a retirement.

As in
[`detect_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_movement.md),
`next_date` is the next date with active personnel, and pensioner
records are looked up from `next_date` onwards. A date holding only
pensioner records is never a `next_date`, so:

- a pensioner record dated after the exit but before `next_date` is not
  seen. The exit is still a retirement if another pensioner record
  follows on or after `next_date`, and a separation otherwise.

- an exit after the last date with active personnel is `NA`, even if
  pensioner records follow.

- an exit shortly before the last date with active personnel may be
  flagged as a separation because the pension is not registered yet.

## See also

[`compute_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_retirement.md),
which counts these retirements.
[`detect_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_movement.md),
which flags the other exits as separations.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 2, 1, 2, 2),
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01", "2022-01-01"
  )),
  employment_status = c("active", "active", "pensioner", "active", "active")
)
detect_retirement(hr)
#>    personnel_id   ref_date  next_date retirement
#>           <num>     <Date>     <Date>     <lgcl>
#> 1:            1 2020-01-01 2021-01-01       TRUE
#> 2:            2 2020-01-01 2021-01-01      FALSE
#> 3:            2 2021-01-01 2022-01-01      FALSE
#> 4:            2 2022-01-01       <NA>         NA
```
