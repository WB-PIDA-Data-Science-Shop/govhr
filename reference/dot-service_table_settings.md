# The rarely needed settings of compute_service_table()

[`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md)
takes `radix`, `smooth` and `span` through `...`, since few users need
them. This gives each its default and stops on any other name, so a
misspelt setting (e.g. `smoth = TRUE`) is not silently ignored.

## Usage

``` r
.service_table_settings(...)
```

## Arguments

- ...:

  The `...` of
  [`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md).

## Value

A list with `radix`, `smooth` and `span`.
