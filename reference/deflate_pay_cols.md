# Convert pay columns to constant prices

Converts pay columns to constant prices of `base_month` with
[`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md).
[`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md)
runs in R, so it is applied to the distinct countries and dates only (a
small table), and the resulting deflators are joined back. This keeps a
database table in the database.

## Usage

``` r
deflate_pay_cols(data, pay_cols, base_month)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with `country_code`
  and `ref_date` columns.

- pay_cols:

  Character vector of the pay columns to convert.

- base_month:

  The base month passed to
  [`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md).

## Value

`data` with `pay_cols` in constant prices. Rows with no `country_code`
get `NA`.
