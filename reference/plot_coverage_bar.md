# Plot coverage by group (coloured bar chart)

Computes per-group coverage using
[`compute_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_coverage.md)
(without `ref_date`, not aggregated) and renders a horizontal bar chart
coloured green-yellow-red according to the same cutpoints used by the
value boxes:

## Usage

``` r
plot_coverage_bar(data)
```

## Arguments

- data:

  A data frame. Typically the contract, personnel, or establishment
  dataset for the active module.

## Value

A ggplot2 object.

## Details

- **High (\>=80%)** — green (`#388e3c`)

- **Medium (50-79%)** — yellow (`#f9a825`)

- **Low (\<50%)** — red (`#d32f2f`)
