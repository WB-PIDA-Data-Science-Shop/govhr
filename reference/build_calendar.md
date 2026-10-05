# Build a calendar of reference dates

Lists each distinct `ref_date` in the data alongside the reference date
immediately before and after it. Useful for matching each period to its
neighbours, e.g. when computing period-over-period changes.

## Usage

``` r
build_calendar(data)
```

## Arguments

- data:

  A data frame or lazy database table with a `ref_date` column.

## Value

A table with one row per distinct `ref_date` and columns `ref_date`,
`prev_date` (the previous reference date, `NA` for the first) and
`next_date` (the next reference date, `NA` for the last).
