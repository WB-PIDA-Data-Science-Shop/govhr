# Decompose average-wage growth

Explains why the average wage across the whole workforce changes from
one period to the next: because pay changed inside groups, or because
staff shifted between higher- and lower-paid groups. This complements
[`compute_growth_decomposition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_growth_decomposition.md),
which explains each group's own wagebill.

## Usage

``` r
compute_wage_decomposition(growth_decomp, group_cols = NULL, simplify = TRUE)
```

## Arguments

- growth_decomp:

  Output of `compute_growth_decomposition(simplify = FALSE)`.

- group_cols:

  Optional character vector of columns identifying a higher-level unit
  (e.g. "country_code") within which the decomposition is computed
  separately. Must be a subset of the grouping columns used to build
  `growth_decomp`. `NULL` pools all groups into one workforce.

- simplify:

  Logical. If `TRUE` (default), return only `group_cols`, `ref_date` and
  the effect columns (`within_effect`, `between_effect`, `cross_effect`,
  `entry_effect`, `exit_effect`, `total_effect`). If `FALSE`, also
  return total headcount, total wagebill and average wage, each for the
  current and the previous period (`total_headcount`,
  `total_headcount_lag`, `total_wagebill`, `total_wagebill_lag`,
  `avg_wage`, `avg_wage_lag`).

## Value

A data.table with one row per reference date (per unit of `group_cols`,
if given) and the effects described in Details. `total_effect` is the
change in average wage; it is `NA` when either period has no employees,
which includes the panel's first period.

## Details

**Setup.** A group \\g\\ is a row of `growth_decomp` (one combination of
the grouping columns used there). In period \\t\\, let \\N\_{g,t}\\ be
the group's headcount, \\C\_{g,t}\\ its average wage (`wage`), \\N_t =
\sum_g N\_{g,t}\\ the total headcount and \\s\_{g,t} = N\_{g,t} / N_t\\
the group's share of headcount. The average wage of the workforce is
total wagebill over total headcount, which is the share-weighted mean of
group averages: \$\$\bar{C}\_t = \frac{W_t}{N_t} = \sum_g s\_{g,t} \\
C\_{g,t}\$\$ As in
[`compute_growth_decomposition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_growth_decomposition.md),
each group is continuing (\\g \in K\\: present in both periods),
entering (\\g \in E\\: present only in \\t\\) or exiting (\\g \in X\\:
present only in \\t-1\\).

**Decomposition.** Following Foster, Haltiwanger and Krizan (2001), with
\\\Delta\\ the change from \\t-1\\ to \\t\\: \$\$\Delta \bar{C}\_t =
\underbrace{\sum\_{g \in K} s\_{g,t-1} \Delta C_g}\_{\text{within}} +
\underbrace{\sum\_{g \in K} \Delta s_g (C\_{g,t-1} -
\bar{C}\_{t-1})}\_{\text{between}} + \underbrace{\sum\_{g \in K} \Delta
s_g \\ \Delta C_g}\_{\text{cross}} + \underbrace{\sum\_{g \in E}
s\_{g,t} (C\_{g,t} - \bar{C}\_{t-1})}\_{\text{entry}} -
\underbrace{\sum\_{g \in X} s\_{g,t-1} (C\_{g,t-1} -
\bar{C}\_{t-1})}\_{\text{exit}}\$\$

- **Within** (\\\sum_K s\_{g,t-1} \Delta C_g\\): pay growth inside
  continuing groups, weighted by their previous-period headcount shares.
  Pure pay effect.

- **Between** (\\\sum_K \Delta s_g (C\_{g,t-1} - \bar{C}\_{t-1})\\):
  movement of headcount toward groups paid above the previous period's
  overall average (positive) or below it (negative), at previous-period
  pay. Pure composition effect.

- **Cross** (\\\sum_K \Delta s_g \\ \Delta C_g\\): positive when the
  groups gaining headcount share are also the ones whose pay grows
  fastest.

- **Entry** (\\\sum_E s\_{g,t} (C\_{g,t} - \bar{C}\_{t-1})\\): new
  groups raise the average if they pay more than the previous period's
  overall average.

- **Exit** (\\-\sum_X s\_{g,t-1} (C\_{g,t-1} - \bar{C}\_{t-1})\\):
  departing groups raise the average if they were paid less than the
  previous period's overall average.

**Proof of identity.** Shares sum to one in each period, so subtracting
the previous period's average wage from every group average leaves the
change unaltered: \$\$\Delta \bar{C}\_t = \sum\_{g \in K \cup E}
s\_{g,t} (C\_{g,t} - \bar{C}\_{t-1}) - \sum\_{g \in K \cup X} s\_{g,t-1}
(C\_{g,t-1} - \bar{C}\_{t-1})\$\$ Substituting \\s\_{g,t} = s\_{g,t-1} +
\Delta s_g\\ and \\C\_{g,t} = C\_{g,t-1} + \Delta C_g\\ for continuing
groups yields the within, between and cross terms; the entry and exit
terms are what remain. Measuring against the previous period's average
is what gives the between, entry and exit terms their meaning: moving
staff raises the average only if they move to groups that are paid above
average.

## References

Foster, L., Haltiwanger, J. and Krizan, C. J. (2001). Aggregate
productivity growth: lessons from microeconomic evidence. In Hulten, C.
R., Dean, E. R. and Harper, M. J. (eds.), *New Developments in
Productivity Analysis*, pp. 303-372. University of Chicago Press.
