# Compare each row with its neighbour

Flags the rows whose values in `cols` all equal those of the row before
(or after) it. Used to find runs of rows belonging to the same entity
and group in
[`detect_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_transition.md).

## Usage

``` r
same_as_neighbour(dt, cols, type = "lag")
```

## Arguments

- dt:

  A data.table already sorted by `cols`.

- cols:

  Character vector of the columns to compare.

- type:

  Character. `"lag"` (default) compares each row with the row before it,
  `"lead"` with the row after it.

## Value

A logical vector with one element per row of `dt`: `TRUE` if the row
matches its neighbour in every column of `cols`, and `FALSE` otherwise,
including the first (or last) row, which has no neighbour.

## Details

Shifting within `by` groups runs once per group, which is far slower
than one vectorised comparison when there are millions of entities.
