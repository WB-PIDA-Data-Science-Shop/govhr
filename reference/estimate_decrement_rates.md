# Estimate empirical decrement rates from a personnel panel

Estimates, for each age (and any grouping columns you supply), the
empirical probability that a person active in one snapshot ends up in
each possible employment status by the next snapshot – retirement,
another kind of exit, or simply staying active. These are the raw
ingredients (`qx`-style decrement rates) for building an actuarial life
table, e.g. with a life-table function that chains them across age.

The function walks every consecutive pair of snapshots in
`personnel_dt`, tracks the same individuals from one snapshot to the
next, and pools the results into one stable rate per age/group/outcome
using all of the data available, rather than relying on any single pair
of snapshots (which can be noisy for ages with few people).

## Usage

``` r
estimate_decrement_rates(
  personnel,
  age_col,
  status_col,
  personnel_id_col,
  ref_date_col,
  group_cols,
  personnel_dt = NULL
)
```

## Arguments

- personnel:

  A data.table (or data.frame/tibble, coerced automatically) containing
  the personnel panel: multiple snapshots of the same population over
  time, identified by `ref_date_col`. Must contain at least two
  distinct, non-missing reference dates.

- age_col:

  A single string naming the (integer, or coercible to integer) age
  column.

- status_col:

  A single string naming the employment status column, e.g.
  `"employment_status"`. The value `"active"` identifies who is exposed
  to risk in each snapshot; every other value your data uses (e.g.
  `"pensioner"`, `"deceased"`) is picked up automatically as its own
  outcome type – nothing needs to be hardcoded or registered in advance.

- personnel_id_col:

  A single string naming the personnel identifier column, used to track
  the same person across snapshots.

- ref_date_col:

  A single string naming the reference date column that identifies each
  snapshot.

- group_cols:

  A character vector of additional columns (e.g. gender, occupation,
  service type) to estimate separate rates by, alongside age.

- personnel_dt:

  Deprecated. Use `personnel` instead.

## Value

A data.table with one row per age / `group_cols` / outcome type, pooled
across every consecutive snapshot pair in `personnel_dt`:

- age_col, group_cols:

  The age and grouping columns, as supplied.

- status_col:

  The outcome type this row's rate applies to – `"active"` (stayed), an
  observed exit status (e.g. `"pensioner"`), or the synthetic
  `"non-retirement-exit"` (someone who dropped out of the panel without
  an explicit exit status). For a given age/group, these rows sum to 1.

- pop:

  Total exposure: the number of person-periods active at the start of a
  snapshot pair, summed across every pair that contributed to this
  age/group.

- exits:

  Total number of people in that exposure who had this outcome by the
  next snapshot, summed the same way.

- decrement_rate:

  The pooled rate, `exits / pop`. This is the empirical `qx` (or `px`,
  for the `"active"` row) to feed into a life table.

- n_periods:

  Number of distinct snapshot pairs that contributed to this
  age/group/outcome cell – a quick way to spot ages resting on very
  little data.

## Details

This section is for readers who want to know exactly how the rate is
computed, not just what it means.

**Two collapsing steps.** Estimating a life-table-ready rate means
collapsing two different axes, and this function only ever does the
first one:

- *Time*, here: every consecutive snapshot pair in `personnel_dt`
  (2015-2016, 2016-2017, ...) is walked via
  [`roll_snapshot_pairs()`](https://wb-pida-data-science-shop.github.io/govhr/reference/roll_snapshot_pairs.md),
  and each pair's exposure/outcome counts are pooled into one
  age-indexed rate. This function never chains anything across *age* –
  that is a separate step (a life-table function operating purely on
  this function's output).

**Pooling is exposure-weighted, not a mean of rates.** For a given
age/group/outcome, `pop` and `exits` are summed across every
contributing snapshot pair *before* dividing. A period-pair with 500
people at risk therefore contributes proportionally more than one with 2
people at risk. A plain average of the per-period rates would let a
noisy, thin period swing the estimate just as much as a large one – this
deliberately avoids that.

**Cohort tracking, not independent aggregation.** Within each snapshot
pair, exposure and outcomes are computed by joining the same individuals
from T0 to T1 on `personnel_id_col` (see
[`.compute_decrement_pair()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-compute_decrement_pair.md)),
not by aggregating each snapshot separately and matching on age
afterward. This matters: someone who was already a pensioner at T0 and
remains one at T1 is never miscounted as a newly observed exit, and each
person's age/group is taken from T0, so there is no fragile assumption
that snapshots are exactly one year apart.

**The outcome vocabulary is derived from the data.** Aside from the
synthetic `"non-retirement-exit"` (assigned to anyone who drops out of
the panel between snapshots without an explicit status change), every
outcome type reported is simply whatever value `status_col` takes on in
your data – including `"active"` itself, so you get a stay probability
alongside every exit-type probability. This means the function keeps
working unmodified if your data's status vocabulary differs from what
was used to build or test it (e.g. adding a `"deceased"` status requires
no code change).

**Caveat.** The literal string `"active"` is currently hardcoded as the
value of `status_col` that defines who is exposed to risk – unlike the
exit-side vocabulary, this one value is assumed rather than derived.

## See also

[`.compute_decrement_pair`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-compute_decrement_pair.md),
[`roll_snapshot_pairs`](https://wb-pida-data-science-shop.github.io/govhr/reference/roll_snapshot_pairs.md)

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

estimate_decrement_rates(
  personnel_dt = personnel_dt,
  age_col = "age",
  status_col = "employment_status",
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  group_cols = "gender"
)
} # }
```
