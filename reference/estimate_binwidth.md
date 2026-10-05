# Estimate a bin width for a pay distribution

Picks a bin width with the Freedman-Diaconis rule, which is based on the
spread of the middle half of the data (the interquartile range), so a
few very high salaries do not distort it. Because that rule gives ever
narrower bins as the data grows, the width is then kept so that the bulk
of the distribution (1st to 99th percentile) spans between `min_bins`
and `max_bins` bins. Finally it is rounded up to a readable width: 1, 2
or 5 times a power of ten.

## Usage

``` r
estimate_binwidth(data, measure_col, min_bins = 20, max_bins = 60)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`).

- measure_col:

  Character. Name of the pay column.

- min_bins, max_bins:

  Whole numbers. Fewest and most bins allowed between the 1st and 99th
  percentile, before rounding. Default 20 and 60.

## Value

A positive whole number, usable as `binwidth` in
[`compute_percentile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_percentile.md).
