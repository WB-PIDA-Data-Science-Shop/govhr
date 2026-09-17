# Graduate (smooth and gap-fill) empirical decrement rates

Takes the pooled output of
[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)
and returns a version with no age gaps and much less small-cell noise –
both prerequisites for
[`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md)'s
age-chaining recursion, which needs a complete, stable `qx` curve to run
at all.

Each exit cause (every `status_col` value other than `active_value`) is
graduated independently via
[`.smooth_rate_curve()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-smooth_rate_curve.md),
weighted by exposure (`pop`) so ages with more data pull their local
curve harder than thin, noisy ages. `active_value` (the "stayed"
outcome) is deliberately never smoothed on its own – it is derived
afterward as `1 - ` the sum of the smoothed exit rates, which is what
guarantees every age/group's rates still sum to exactly 1 after
smoothing (independently smoothing every outcome type would not preserve
that).

## Usage

``` r
smooth_decrement_rates(
  decrements,
  age_col,
  status_col,
  group_cols,
  active_value = "active",
  span = 0.75,
  decrement_dt = NULL
)
```

## Arguments

- decrements:

  A data.table (or coercible) shaped like the output of
  [`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md):
  one row per age / `group_cols` / `status_col`, with a `pop` (exposure)
  and `decrement_rate` column.

- age_col:

  A single string naming the age column.

- status_col:

  A single string naming the outcome-type column.

- group_cols:

  A character vector of stratifying columns (e.g. gender), or `NULL` for
  no stratification.

- active_value:

  A single string giving the `status_col` value that represents "stayed"
  rather than an exit. Defaults to `"active"`.

- span:

  Numeric. The [`loess()`](https://rdrr.io/r/stats/loess.html) smoothing
  span passed through to
  [`.smooth_rate_curve()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-smooth_rate_curve.md).
  Defaults to `0.75`.

- decrement_dt:

  Deprecated. Use `decrements` instead.

## Value

A data.table with one row per age / `group_cols` / `status_col`,
spanning the full observed age range within each group with no gaps:

- age_col, group_cols:

  As supplied.

- status_col:

  The outcome type, including `active_value`.

- decrement_rate:

  The graduated rate, clipped to `[0, 1]`. Sums to 1 across outcome
  types for a given age/group (up to the clamping caveat below).

`pop`, `exits`, and `n_periods` from `decrement_dt` are not carried
forward: an interpolated age never had a real headcount, so those
columns would be fabricated rather than meaningful.

## Details

**Age grid.** Each group's target age grid (`min(age)` to `max(age)`) is
computed once across *all* outcome types in `decrement_dt`, not
separately per `status_col`, so every exit cause ends up graduated onto
exactly the same set of ages within a group.

**Clamping caveat.** If the smoothed exit rates for a given age/group
happen to sum to slightly more than 1 (possible when several causes are
each pushed up near a sparse edge), the derived `active_value` rate is
clamped to 0 rather than going negative. In that edge case the row then
sums to slightly less than 1 rather than exactly 1 – a known
imperfection that is not further corrected.

## See also

[`.smooth_rate_curve`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-smooth_rate_curve.md),
[`estimate_decrement_rates`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md),
[`compute_service_table`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md)
