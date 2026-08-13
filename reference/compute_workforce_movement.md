# Function to compute workforce movement for hires, fires, retirement, or turnover

Function to compute workforce movement for hires, fires, retirement, or
turnover

## Usage

``` r
compute_workforce_movement(.data, movement_type, measurement_type, group_cols)
```

## Arguments

- .data:

  A data frame containing personnel data.

- movement_type:

  A character string indicating the type of movement: "hire", "fire",
  "retirement", or "turnover".

- measurement_type:

  A character string indicating the measurement type: "count" or "rate".
  Ignored for turnover, which is a ratio.

- group_cols:

  A character string indicating the grouping column, or "ref_date" for
  no grouping.

## Value

A data.table containing the aggregated movement data.

## Details

The function computes workforce movement counts or rates, based on the
specified movement type. For hires, fires, and retirements, it
calculates either the count or rate of events. For turnover, it
calculates the ratio of hires to separations (including retirements).
The data is grouped by the specified columns.
