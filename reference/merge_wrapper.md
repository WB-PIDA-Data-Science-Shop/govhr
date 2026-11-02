# Left-join two tables with `merge()`

Calls [`merge()`](https://rdrr.io/pkg/data.table/man/merge.html) with
`all.x = TRUE`, so every row of `x` is kept.

## Usage

``` r
merge_wrapper(...)
```

## Arguments

- ...:

  Arguments passed to
  [`merge()`](https://rdrr.io/pkg/data.table/man/merge.html), such as
  `x`, `y` and `by`.

## Value

The merged table.
