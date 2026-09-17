# Find duplicate identifiers in a data frame

Identifies duplicated values of a specified identifier column in a data
frame or tibble. Returns a tibble with the identifier values that appear
more than once and their counts.

## Usage

``` r
find_duplicate_ids(data, identifier)
```

## Arguments

- data:

  A data frame or tibble.

- identifier:

  The column to check for duplicates. This should be passed as a bare
  (unquoted) column name using tidy evaluation.

## Value

A tibble with the identifier column and a count column `n` indicating
the number of times each duplicate appears.

## Examples

``` r
library(dplyr)
library(tibble)

df <- tibble(id = c(1, 2, 2, 3, 3, 3, 4))
find_duplicate_ids(df, id)
#> # A tibble: 2 × 2
#>      id     n
#>   <dbl> <int>
#> 1     2     2
#> 2     3     3
```
