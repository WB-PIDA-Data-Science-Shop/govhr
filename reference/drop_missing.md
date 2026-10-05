# Drop rows with missing values in selected columns

Keeps only the rows where every column in `cols` is non-missing. This
implementation was designed for use with duckplyr databases.

## Usage

``` r
drop_missing(data, cols)
```

## Arguments

- data:

  A data frame or lazy database table.

- cols:

  A character vector of column names that must not be `NA`.

## Value

`data` with rows containing `NA` in any of `cols` removed.
