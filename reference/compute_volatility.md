# Compute Volatility Measures Over Time

Computes a variety of volatility statistics (e.g., percent change,
rolling standard deviation, coefficient of variation) for a variable
aggregated over time and optionally by grouping variables. Missing time
periods are automatically filled for all groups, ensuring consistent
temporal coverage before volatility is calculated.

## Usage

``` r
compute_volatility(
  data,
  col,
  agg_fn,
  vol_fn = c("pct_change", "sd", "cv", "rolling_sd", "rolling_cv", "rolling_pct_change"),
  time,
  groups,
  window_size = NULL
)
```

## Arguments

- data:

  A data.frame or data.table containing the dataset.

- col:

  A character string specifying the column whose volatility should be
  computed.

- agg_fn:

  A character string specifying the aggregation function to apply before
  volatility is calculated. Must match a function name available to
  \`compute_fastsummary()\`.

- vol_fn:

  A character string specifying the volatility measure to compute.
  Options are: \`"pct_change"\`, \`"sd"\`, \`"cv"\`, \`"rolling_sd"\`,
  \`"rolling_cv"\`, \`"rolling_pct_change"\`.

- time:

  A character string representing the time variable. Must be sortable
  (e.g., Date, year, numeric).

- groups:

  A character vector of grouping variables. Use \`NULL\` to compute
  volatility for the entire dataset without grouping.

- window_size:

  Integer window length for rolling volatility functions. Required when
  \`vol_fn\` is one of the rolling variants.

## Value

A \`data.table\` containing: \* grouping variables (if provided), \* the
time variable (for rolling and period-based volatility), and \* the
computed volatility statistic, named using \`vol_fn\`.

For non-rolling aggregate volatility functions (\`sd\`, \`cv\`), the
function returns one row per group.

## Details

This function first summarizes the input data using
\[compute_fastsummary()\], aggregating \`col\` using \`agg_fn\` for each
combination of \`groups\` and \`time\`.

After aggregation, the function constructs a full grid of all time
periods crossed with all unique group combinations using
\`data.table::CJ()\`, filling implicit missing time–group combinations
with \`NA\`.

Volatility measures are computed by calling an internal registry of
volatility functions defined in \[\`define_vol_fns()\`\].

Available volatility methods include:

\* \*\*pct_change\*\* — period-to-period percent change \* \*\*sd\*\* —
standard deviation of the aggregated values over time \* \*\*cv\*\* —
coefficient of variation (\`sd(x) / mean(x)\`) \* \*\*rolling_sd\*\* —
rolling standard deviation using a fixed window \* \*\*rolling_cv\*\* —
rolling coefficient of variation \* \*\*rolling_pct_change\*\* — percent
change over a rolling window

## See also

\* \[\`define_vol_fns()\`\] for the internal volatility function
registry \* \[\`compute_fastsummary()\`\] for the aggregation step

## Examples

``` r
if (FALSE) { # \dontrun{
# Percent change in base salary by occupation over time
compute_volatility(
  data      = bra_hrmis_contract,
  col       = "base_salary_lcu",
  agg_fn    = "sum",
  vol_fn    = "pct_change",
  time      = "ref_date",
  groups    = "occupation_isconame"
)

# Rolling 3-period coefficient of variation
compute_volatility(
  data      = bra_hrmis_contract,
  col       = "whours",
  agg_fn    = "mean",
  vol_fn    = "rolling_cv",
  time      = "ref_date",
  groups    = "occupation_native",
  window_size = 3
)
} # }
```
