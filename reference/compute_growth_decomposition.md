# Compute growth decomposition of wagebill

Compute growth decomposition of wagebill

## Usage

``` r
compute_growth_decomposition(data, ...)

# S3 method for class 'data.frame'
compute_growth_decomposition(
  data,
  group_cols = NULL,
  measure_col = "gross_salary_lcu",
  simplify = TRUE,
  ...
)

# S3 method for class 'tbl_dbi'
compute_growth_decomposition(
  data,
  group_cols = NULL,
  measure_col = "gross_salary_lcu",
  simplify = TRUE,
  ...
)
```

## Arguments

- data:

  Data frame or remote table (`tbl_dbi`) containing a `ref_date` column,
  the grouping columns and the measure.

- ...:

  Arguments passed to methods.

- group_cols:

  Character vector of columns to group by, or `NULL` for no grouping.
  Must not include `ref_date`.

- measure_col:

  Character. Numeric column to decompose. Default `"gross_salary_lcu"`.

- simplify:

  Logical. If `TRUE` (default), return only `group_cols`, `ref_date`,
  `transition_type` and the effect columns (`employment_effect`,
  `wage_effect`, `interaction_effect`, `entry_effect`, `exit_effect`,
  `total_effect`). If `FALSE`, also return the intermediate columns
  (`headcount`, `wage`, `wagebill`, their lags, `delta_wage`,
  `is_observed` and `observed_lag`).
  [`compute_wage_decomposition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wage_decomposition.md)
  requires `simplify = FALSE`.

## Value

A data.table (a lazy table for `tbl_dbi` input) with one row per group x
reference date, containing the grouping columns, `ref_date`,
`transition_type` and the columns selected by `simplify`.
`transition_type` is "start" (panel's first period), "continuing"
(observed this period and last), "entry" (observed this period but not
last) or "exit" (not observed this period).

## Details

The function explains how each group's wagebill changes from one period
to the next, decomposing the change into an effect due to headcount, an
effect due to average pay, and an effect due to both moving together.

**1. Building the panel.** Rows with a missing value in `measure_col` or
any of `group_cols` are dropped. For each group \\g\\ (a combination of
`group_cols`) and period \\t\\ (`ref_date`):

- headcount \\N\_{g,t}\\: number of records;

- wage \\C\_{g,t}\\: mean of `measure_col`;

- wagebill \\W\_{g,t} = \sum_i w_i = N\_{g,t} \\ C\_{g,t}\\.

Every group is then expanded to every `ref_date` in `data`. A group
absent in a period gets \\N = 0\\, \\W = 0\\ and \\C\\ = `NA`, so gaps
are explicit rather than silently skipped. Reference dates absent from
the whole of `data` are not added. Each row is compared with the same
group's previous reference date, \\t-1\\.

**2. Continuing groups** (observed at \\t-1\\ and \\t\\). Write \\\Delta
N = N_t - N\_{t-1}\\ and \\\Delta C = C_t - C\_{t-1}\\ (`delta_wage`).
Since \\W_t = (N\_{t-1} + \Delta N)(C\_{t-1} + \Delta C)\\, expanding
the product gives us the following identity: \$\$W_t - W\_{t-1} =
\underbrace{C\_{t-1} \Delta N}\_{\text{employment}} +
\underbrace{N\_{t-1} \Delta C}\_{\text{wage}} + \underbrace{\Delta N \\
\Delta C}\_{\text{interaction}}\$\$

- `employment_effect` \\= C\_{t-1} \Delta N\\: the change had pay stayed
  at last period's average and only headcount changed.

- `wage_effect` \\= N\_{t-1} \Delta C\\: the change had headcount stayed
  at last period's level and only average pay changed.

- `interaction_effect` \\= \Delta N \\ \Delta C\\: the extra change from
  both moving at once (new staff paid the new average).

**3. Entry and exit.** When a group is missing in one of the two
periods, \\\Delta C\\ is undefined, so the three effects above are `NA`
and the entire change is attributed to entry or exit:

- entry (absent at \\t-1\\, present at \\t\\): `entry_effect` \\= W_t\\.

- exit (present at \\t-1\\, absent at \\t\\): `exit_effect` \\=
  -W\_{t-1}\\. Later periods in which the group stays absent are also
  labelled "exit" but carry `exit_effect` = 0, as nothing further
  changed. A group absent from the panel's first period is likewise
  "exit" with 0 until it enters.

A group that disappears and later reappears therefore shows one exit,
zero-effect "exit" rows during the gap, and one entry.

**4. Total effect.** `total_effect` is the sum of the effects that apply
to the row, so it always equals \\W_t - W\_{t-1}\\ (with \\W = 0\\ when
unobserved). It is `NA` in the panel's first period ("start"), which has
no baseline. Consequently, summing `total_effect` over time for a group
recovers its wagebill in the last period minus its wagebill in the first
period.
