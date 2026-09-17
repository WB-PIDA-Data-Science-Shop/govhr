# Complete columns in a dataframe

If any column in `cols` is missing from `data`, this function adds it
and populates it with NA values.

## Usage

``` r
complete_columns(data, cols)
```

## Arguments

- data:

  A data frame or tibble.

- cols:

  A character vector of column names to check.

## Value

A tibble with all requested columns, missing ones filled with NA.

## Examples

``` r
library(tibble)

df <- tibble(a = 1:3, b = letters[1:3])
complete_columns(df, c("a", "b", "c"))
#> # A tibble: 3 × 3
#>       a b     c    
#>   <int> <chr> <lgl>
#> 1     1 a     NA   
#> 2     2 b     NA   
#> 3     3 c     NA   
```
