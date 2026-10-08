# Detect hires and separations

Flags, for each active person and reference date, whether they were
hired since the previous date and whether they are gone by the next
date.

## Usage

``` r
detect_movement(data, ...)

# S3 method for class 'data.frame'
detect_movement(data, status_col = "employment_status", ...)

# S3 method for class 'tbl_dbi'
detect_movement(data, status_col = "employment_status", ...)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with one row per
  person-record. Must contain `personnel_id`, `ref_date` and the column
  named in `status_col`.

- ...:

  Arguments passed to methods.

- status_col:

  Character. Column holding employment status. Only rows equal to
  `"active"` are considered. Default `"employment_status"`.

## Value

A table with one row per active person and `ref_date`, containing:

- personnel_id, ref_date:

  The person and date.

- prev_date, next_date:

  The neighbouring dates found in the data, which the person's status is
  compared with. `NA` on the first and last date.

- hire:

  `TRUE` if the person was not active on `prev_date`. `NA` on the first
  date, which has nothing to compare with.

- separation:

  `TRUE` if the person is not active on `next_date`. `NA` on the last
  date.

A data.table for data frame input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

The previous and next dates are the neighbouring dates found in the
data, so the dates do not need to be evenly spaced. People with several
contracts on a date appear once. A separation is any exit from active
status, including retirement.

## See also

[`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md),
which counts these hires and separations.
[`detect_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_retirement.md),
which flags the retirements among the separations.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 2, 1, 3, 1, 3),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01"), each = 2)),
  employment_status = "active"
)
detect_movement(hr)
#>    personnel_id   ref_date  prev_date  next_date   hire separation
#>           <num>     <Date>     <Date>     <Date> <lgcl>     <lgcl>
#> 1:            1 2020-01-01       <NA> 2021-01-01     NA      FALSE
#> 2:            2 2020-01-01       <NA> 2021-01-01     NA       TRUE
#> 3:            1 2021-01-01 2020-01-01 2022-01-01  FALSE      FALSE
#> 4:            3 2021-01-01 2020-01-01 2022-01-01   TRUE      FALSE
#> 5:            1 2022-01-01 2021-01-01       <NA>  FALSE         NA
#> 6:            3 2022-01-01 2021-01-01       <NA>  FALSE         NA
```
