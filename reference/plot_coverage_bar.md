# Plot Coverage by Group (Coloured Bar Chart)

Computes per-group coverage using \[compute_coverage()\] (without
\`ref_date\`, not aggregated) and renders a horizontal bar chart
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

\* \*\*High (\>=80 \* \*\*Medium (50-79 \* \*\*Low (\<50
