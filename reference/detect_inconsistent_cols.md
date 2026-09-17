# Detect inconsistent columns in a data frame

This function checks whether any of the specified column names appear in
a given data frame. It is typically used to identify the presence of
inconsistent or unexpected column names across multiple data frames.

## Usage

``` r
detect_inconsistent_cols(data, inconsistent_cols)
```

## Arguments

- data:

  A data frame to inspect.

- inconsistent_cols:

  A character vector of column names considered inconsistent.

## Value

A logical value: `TRUE` if any inconsistent columns are present in the
data frame, `FALSE` otherwise.

## Examples

``` r
df <- data.frame(a = 1:3, b = 4:6)
detect_inconsistent_cols(df, c("c", "d")) # returns FALSE
#> [1] FALSE
detect_inconsistent_cols(df, c("a", "c")) # returns TRUE
#> [1] TRUE
```
