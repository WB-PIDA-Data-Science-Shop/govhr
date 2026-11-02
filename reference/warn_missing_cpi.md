# Warn about values that could not be deflated

Warns about the country-months that
[`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md)
could not deflate, so a silent `NA` does not slip into downstream
analysis. A row with no CPI for its own month is reported once; a
country with no CPI in `base_month` is reported with the range of months
its CPI data covers.

## Usage

``` r
warn_missing_cpi(deflated, base_month)
```

## Arguments

- deflated:

  A data frame with columns `col` (the value to deflate),
  `country_code`, `ref_month`, `cpi_month` and `cpi_base`, as built
  inside
  [`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md).

- base_month:

  Date. The base month passed to
  [`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md).

## Value

`NULL`, invisibly. Called for its warnings.
