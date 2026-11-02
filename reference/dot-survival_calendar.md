# Pair each snapshot date with the next one

Used by both methods of
[`build_survival_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/build_survival_panel.md),
so in-memory and database panels measure intervals the same way. The
last date has no next one, so it is not in the calendar: joining the
calendar drops the last snapshot, which is censored.

## Usage

``` r
.survival_calendar(dates)
```

## Arguments

- dates:

  A sorted vector of distinct snapshot dates.

## Value

A data frame with one row per date but the last: `.ref` (the date),
`next_date` (the next one) and `.interval` (the years between them).
