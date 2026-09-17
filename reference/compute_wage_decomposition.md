# Decompose aggregate average-compensation growth into within, between, cross, entry, and exit effects (Foster-Haltiwanger-Krizan style)

Takes the per-group output of compute_growth_decomposition() and answers
a different question than that function does: not "why did group i's own
wagebill change" but "why did average compensation across ALL groups
combined change" – specifically, how much is pay growth within groups
versus a shift in headcount share toward higher- or lower-paid groups.

## Usage

``` r
compute_wage_decomposition(growth_decomp, group_cols = NULL)
```

## Arguments

- growth_decomp:

  Output of compute_growth_decomposition()

- group_cols:

  Optional character vector of columns identifying a higher-level unit
  (e.g. "country_code") within which shares/composition are computed
  separately. NULL pools all rows into one global composition per
  ref_date.

## Value

A data.table, one row per ref_date (or per ref_date x `group_cols`),
with avg_compensation, avg_compensation_lag, within_effect,
between_effect, cross_effect, entry_effect, exit_effect, and
total_effect (which equals avg_compensation - avg_compensation_lag by
construction, except at the panel's first period, which is NA – no
lagged baseline).
