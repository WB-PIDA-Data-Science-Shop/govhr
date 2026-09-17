# Count unique non-missing values

Returns the number of unique values in a vector, excluding missing
values (NA).

## Usage

``` r
count_unique(x)
```

## Arguments

- x:

  A vector of any type (numeric, character, factor, etc.)

## Value

An integer representing the count of unique non-missing values in `x`.

## Examples

``` r
# Basic usage
count_unique(c(1, 2, 2, 3, 3, 3))
#> [1] 3

# With missing values
count_unique(c(1, 2, NA, 2, 3, NA))
#> [1] 3

# With character vector
count_unique(c("a", "b", "a", "c"))
#> [1] 3

# Empty vector
count_unique(c())
#> [1] 0

# All NA values
count_unique(c(NA, NA, NA))
#> [1] 0
```
