# Flatten a nested volatility list into a single labelled data.table

Takes the nested list produced by the volatility section of
\[\`compute_qualitycontrol()\`\] (or built manually from
\[\`compute_volatility()\`\] calls) and collapses it into a single tidy
\`data.table\`. Dictionary labels are joined for the grouping variable
and the measured indicator, and a human-readable volatility-function
label is added via an internal lookup table.

## Usage

``` r
flatten_volatility(vol_list, dict = govhr::dictionary)
```

## Arguments

- vol_list:

  A named list (possibly nested) whose leaves are \`data.table\`s
  returned by \[\`compute_volatility()\`\].

- dict:

  A data.frame with at least columns \`variable_id\` and
  \`variable_name\` used to look up human labels. Defaults to
  \`govhr::dictionary\`.

## Value

A \`data.table\` with columns:

- \`stat_type\`:

  Top-level list element name (e.g. \`"salary_vol"\`).

- \`vol_fn\`:

  Code name of the volatility function (e.g. \`"pct_change"\`).

- \`vol_fn_label\`:

  Human label (e.g. \`"Percent Change"\`).

- \`group_var\`:

  Column name(s) used as the grouping variable.

- \`group_var_label\`:

  Dictionary label for \`group_var\` (NA for composites).

- \`group_val\`:

  Value of the grouping variable (character).

- \`ref_date\`:

  Time period.

- \`indicator\`:

  Aggregated indicator code (e.g. \`"gross_salary_lcu_sum"\`).

- \`indicator_label\`:

  Dictionary label for the base variable.

- \`value\`:

  Aggregated numeric value.

- \`vol_stat\`:

  Computed volatility statistic.
