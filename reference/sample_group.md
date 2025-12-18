# Sample groups and return all rows for those groups

sample_group() randomly samples a specified number of unique values from
a grouping column and returns all rows belonging to the sampled groups.

## Usage

``` r
sample_group(.data, group, n)
```

## Arguments

- .data:

  A data.frame, tibble, or data.table.

- group:

  Unquoted column name used to define groups.

- n:

  Integer; number of distinct groups to sample. If greater than the
  number of available groups, all groups are returned.

## Value

An object of the same class as \`.data\` (tibble -\> tibble, data.table
-\> data.table, data.frame -\> data.frame) containing only rows whose
group value was sampled.

## Examples

``` r
df <- tibble::tibble(id = 1:8, grp = rep(letters[1:4], each = 2))
sample_group(df, grp, 2)
#> # A tibble: 4 × 2
#>      id grp  
#>   <int> <chr>
#> 1     3 b    
#> 2     4 b    
#> 3     5 c    
#> 4     6 c    
```
