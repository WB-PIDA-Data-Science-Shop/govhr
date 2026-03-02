# Identify inconsistent column names across data frames

This function checks for consistency in column names across a list of
data frames. It returns the symmetric difference between the shared
columns (those present in all data frames) and the union of all column
names (those present in any data frame).

## Usage

``` r
find_inconsistent_colnames(data_list)
```

## Arguments

- data_list:

  A list of data frames to check.

## Value

A character vector of column names that are not shared across all data
frames. These are the inconsistent or unique column names that appear in
only some of the data frames.

## Examples

``` r
df1 <- data.frame(a = 1, b = 2)
df2 <- data.frame(a = 3, c = 4)
df_list <- list(df1, df2)
find_inconsistent_colnames(df_list)
#> # A tibble: 2 × 1
#>   colnames
#>   <chr>   
#> 1 b       
#> 2 c       
# Returns: "b" "c"
```
