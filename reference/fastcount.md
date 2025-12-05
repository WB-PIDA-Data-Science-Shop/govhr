# Fast counting via dtplyr

\`fastcount()\` delegates \[dplyr::count()\] to a \`data.table\` backend
by converting the input to a lazy \`dtplyr\` table first. This preserves
the familiar \`count()\` interface while exploiting \`data.table\`
performance.

## Usage

``` r
fastcount(x, ..., wt = NULL, sort = FALSE, name = NULL)
```

## Arguments

- x:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr).

- ...:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Variables to group by.

- wt:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Frequency weights. Can be `NULL` or a variable:

  - If `NULL` (the default), counts the number of rows in each group.

  - If a variable, computes `sum(wt)` for each group.

- sort:

  If `TRUE`, will show the largest groups at the top.

- name:

  The name of the new column in the output.

  If omitted, it will default to `n`. If there's already a column called
  `n`, it will use `nn`. If there's a column called `n` and `nn`, it'll
  use `nnn`, and so on, adding `n`s until it gets a new name.

## Value

A tibble with one row per group and a count column.

## Examples

``` r
df <- tibble::tibble(group = c("a", "a", "b"))
fastcount(df, group)
#> # A tibble: 2 × 2
#>   group     n
#>   <chr> <int>
#> 1 a         2
#> 2 b         1
```
