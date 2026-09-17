# Convert data to match original class

Converts a dataset to have the same class as another reference dataset.
This is useful for ensuring consistent output formats when performing
operations that temporarily convert data structures (e.g., between
`data.table`, `data.frame`, or `tibble`).

## Usage

``` r
convert_data(data, data_original)
```

## Arguments

- data:

  A dataset to be converted. Typically a `data.table` or `data.frame`.

- data_original:

  The original dataset whose class should be matched.

## Value

The input `data` converted to the same class as `data_original`.

## Details

The function checks the class of `data_original` in the following order:

- If it is a tibble (`tbl_df`), `data` is converted using
  [`tibble::as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html).

- If it is a base data frame but not a data.table, `data` is converted
  using [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html).

- Otherwise, `data` is returned unchanged (e.g., for data.table input).

## Examples

``` r
if (FALSE) { # \dontrun{
df <- data.frame(x = 1:3)
dt <- data.table::as.data.table(df)

# Convert dt back to data.frame to match df
convert_data(dt, df)

# Convert to tibble if original was tibble
convert_data(dt, tibble::as_tibble(df))
} # }
```
