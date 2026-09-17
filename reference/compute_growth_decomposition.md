# Compute growth decomposition of wagebill

Compute growth decomposition of wagebill

## Usage

``` r
compute_growth_decomposition(
  data,
  group_cols = NULL,
  measure_col = "gross_salary_lcu"
)
```

## Arguments

- data:

  A data frame containing the data to be analyzed. It should include
  columns for the grouping variables, a column for the reference date,
  and a column for the measure of interest (e.g., gross salary).

- group_cols:

  A character vector specifying the names of the columns to group by.

- measure_col:

  A string specifying the name of the column containing the measure of
  interest (default is "gross_salary_lcu").

## Value

A data.table with headcount, compensation, wagebill, wagebill_lag, the
continuing-period decomposition (employment/compensation/interaction
effects), entry/exit effects, is_observed, and a `transition_type` label
for each row: "start" (panel's first period for this group – left-
censored, no baseline available), "continuing" (observed this period and
last), "entry" (observed now, not last period – a genuinely new
group_cols combination, or a reappearance after any length of absence),
or "exit" (not observed now – covers both the period a group first
disappears, which carries the real dollar effect, and every subsequent
period it remains absent, which correctly carries a zero effect since
nothing further changed).
