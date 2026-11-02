# Check that a panel has enough snapshots

Panel analyses that compare consecutive snapshots (decrement rates,
movement and exit rates, ...) need a minimum number of distinct
reference dates. Callers count the distinct, non-missing dates
themselves, so the check works the same for in-memory and database
tables.

## Usage

``` r
.check_panel_snapshots(
  n_snaps,
  min_snaps = 2L,
  arg = "data",
  ref_date_col = "ref_date"
)
```

## Arguments

- n_snaps:

  Integer. Number of distinct, non-missing reference dates in the panel.

- min_snaps:

  Integer. Minimum number of snapshots required. Default `2`, the fewest
  that form one consecutive pair.

- arg:

  Character. Name of the argument holding the panel, used in the error
  message.

- ref_date_col:

  Character. Name of the reference date column, used in the error
  message.

## Value

`n_snaps`, invisibly. Stops with an error if it is below `min_snaps`.
