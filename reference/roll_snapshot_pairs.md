# Iterate Consecutive Snapshot Pairs in a Panel data.table

Sets a data.table key on `date_col` (enabling O(log N) binary-search
subsetting rather than O(N) full-table scans), then calls a
user-supplied function `f(snap_a, snap_b, ...)` for every consecutive
pair of distinct dates in the panel. Results are collected and returned
as a single `data.table` via `rbindlist`.

This helper enforces the key-setting pattern for all callers that need
to walk a longitudinal panel snapshot by snapshot. At scale (50 M rows,
15 annual snapshots) the difference between an unkeyed and a keyed scan
is roughly 5–10×.

## Usage

``` r
roll_snapshot_pairs(panel_dt, date_col, f, ...)
```

## Arguments

- panel_dt:

  data.table. Panel data containing all snapshots. The key is
  set/updated in-place on entry; pass
  [`data.table::copy()`](https://rdrr.io/pkg/data.table/man/copy.html)
  if the caller must preserve the original key.

- date_col:

  Character scalar. Name of the date column that identifies snapshots
  (e.g. `"ref_date"`). `NA` values are silently dropped before
  iteration.

- f:

  Function. Called as `f(snap_a, snap_b, ...)` where `snap_a` and
  `snap_b` are the T0 and T1 subsets respectively. Must return a
  `data.table` or `NULL`; `NULL` rows are skipped.

- ...:

  Additional arguments forwarded to `f` unchanged.

## Value

A single `data.table` produced by
`rbindlist(results, fill = TRUE, use.names = TRUE)` over all non-`NULL`
results. Returns an empty
[`data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
when all calls return `NULL` or the panel has fewer than two distinct
dates.

## Examples

``` r
if (FALSE) { # \dontrun{
library(data.table)
panel <- data.table(
  ref_date     = as.Date(c("2015-01-01","2015-01-01","2016-01-01","2016-01-01")),
  personnel_id = c("P1", "P2", "P1", "P2"),
  paygrade     = c("G1", "G2", "G2", "G2")
)

count_movers <- function(a, b) {
  data.table(n_persons_t0 = nrow(a), n_persons_t1 = nrow(b))
}

roll_snapshot_pairs(panel, date_col = "ref_date", f = count_movers)
} # }
```
