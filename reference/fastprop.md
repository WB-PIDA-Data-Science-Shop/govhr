# Compute group-wise proportions from counts

fastprop() computes the proportion of counts within groups. It expects
the input to already contain a count column named \`n\` (for example the
output of \`dplyr::count()\` or \`fastcount()\`).

## Usage

``` r
fastprop(.data, ...)
```

## Arguments

- .data:

  A data frame or tibble containing a count column \`n\`.

- ...:

  Grouping variables. Proportions are computed within the combinations
  of these variables.

## Value

A tibble with the same columns as \`.data\` plus a numeric \`prop\`
column giving the group share (0–1). Missing \`n\` values are ignored in
the denominator via \`na.rm = TRUE\`.

## See also

dplyr::count, fastcount

## Examples

``` r
library(dplyr)
df <- tibble::tibble(group = c("a","a","b"))
df |> count(group) |> fastprop(group)
#> # A tibble: 2 × 3
#>   group     n  prop
#>   <chr> <int> <dbl>
#> 1 a         2     1
#> 2 b         1     1
```
