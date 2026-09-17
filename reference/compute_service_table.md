# Compute an actuarial service table from a personnel panel

Builds a multiple-decrement service table: for each age (and any
`group_cols` you supply), the number of survivors (`lx`), person- years
of service (`Lx`, `Tx`), and expected remaining years of service (`ex`)
for a synthetic cohort experiencing today's age-specific empirical
decrement rates at every future age.

This chains
[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)'s
pooled, age-indexed rates across *age* – a different axis from the
time-pooling that function already did. By default the rates are
graduated first via
[`smooth_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/smooth_decrement_rates.md),
since the chain below requires a complete, gapless, reasonably stable
`qx` curve to produce a sensible result.

## Usage

``` r
compute_service_table(
  personnel,
  age_col,
  status_col,
  personnel_id_col,
  ref_date_col,
  group_cols,
  radix = 1e+05,
  smooth = FALSE,
  span = 0.75,
  personnel_dt = NULL
)
```

## Arguments

- personnel:

  A data.table (or data.frame/tibble, coerced automatically) containing
  the personnel panel. Passed straight through to
  [`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md).

- age_col:

  A single string naming the age column.

- status_col:

  A single string naming the employment status column. The value
  `"active"` identifies the "stayed" outcome that the survival chain is
  built from.

- personnel_id_col:

  A single string naming the personnel identifier column.

- ref_date_col:

  A single string naming the reference date column.

- group_cols:

  A character vector of additional columns (e.g. gender, service type)
  to compute a separate service table for, or `NULL` for a single table
  over the whole population.

- radix:

  Numeric. The size of the synthetic starting cohort at the youngest
  observed age. Purely a normalizing constant – it cancels out of `ex`
  and does not represent real people. Defaults to `100000`.

- smooth:

  Logical. Whether to graduate the decrement rates via
  [`smooth_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/smooth_decrement_rates.md)
  before chaining. Defaults to `FALSE`: the raw pooled rates are chained
  directly, *unless* a `group_cols` stratum has an age gap, in which
  case `compute_service_table()` smooths reactively (with a warning)
  regardless of this setting, since the chain cannot run on a gappy age
  sequence. Set to `TRUE` to always smooth up front, including for noise
  reduction on strata that have no gap at all.

- span:

  Numeric. Forwarded to
  [`smooth_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/smooth_decrement_rates.md)
  when `smooth = TRUE`. Defaults to `0.75`.

- personnel_dt:

  Deprecated. Use `personnel` instead.

## Value

A data.table with one row per age / `group_cols`:

- age_col, group_cols:

  As supplied.

- px:

  Probability of remaining active from age x to x+1.

- lx:

  Survivors at age x, out of `radix` at the youngest age: \\l(x) = radix
  \prod\_{y\<x} p(y)\\.

- lx_next:

  Survivors at age x+1: \\l(x) \cdot p(x)\\.

- Lx:

  Person-years of service between age x and x+1: \\(l(x) + l\_{next}(x))
  / 2\\ (trapezoidal approximation, assuming exits are spread uniformly
  across the year).

- Tx:

  Total remaining person-years of service from age x onward: \\\sum\_{y
  \ge x} L(y)\\.

- ex:

  Expected remaining years of service at age x: \\T(x) / l(x)\\.

## Details

**This is a stationary-cohort summary, not a projection of your real
workforce headcount.** `lx` describe a hypothetical synthetic cohort
that experiences today's cross-sectional age-specific rates at every
future age – they are not a forecast of how many of your actual current
employees will retire in each future calendar year. For that, the raw
output of
[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)
(applied to your real current headcount by age, stepped forward through
calendar time) is the right input, not this table.

**Caveat.** The literal string `"active"` is hardcoded as the
`status_col` value the survival chain is built from – inherited directly
from
[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)
and
[`.compute_decrement_pair()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-compute_decrement_pair.md),
where the same caveat applies.

## See also

[`estimate_decrement_rates`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md),
[`smooth_decrement_rates`](https://wb-pida-data-science-shop.github.io/govhr/reference/smooth_decrement_rates.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(data.table)

personnel_dt <- data.table(
  personnel_id = c("P1", "P2", "P1", "P2"),
  ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01")),
  age = c(60L, 45L, 61L, 46L),
  employment_status = c("active", "active", "pensioner", "active"),
  gender = c("M", "F", "M", "F")
)

compute_service_table(
  personnel_dt = personnel_dt,
  age_col = "age",
  status_col = "employment_status",
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  group_cols = "gender"
)
} # }
```
