# Validate Data Quality Using Rule-Based Framework

Validates data against a set of predefined rules. Always returns a named
list with two elements: `report` (an audit summary data.table) and
`violations` (a named list of data.tables, one per rule, containing only
the rows that failed that rule). This structure supports both tabular
display and row-level drill-down in Shiny.

## Usage

``` r
validate_data(data, input_rules, output_format = c("report", "object"))
```

## Arguments

- data:

  A data.frame or data.table.

- input_rules:

  A data.frame of rules with columns `rule`, `name`, `description`,
  `label`.

- output_format:

  Deprecated — kept for backward compatibility but ignored. The function
  now always returns `list(report, violations)`.

## Value

A named list:

- `report`:

  data.table with columns `Rule`, `Description`, `Total Records`,
  `Passes`, `Pass Rate`, `Fails`, `Errors`.

- `violations`:

  Named list of data.tables, one per rule label. Each element contains
  the rows of `data` that failed that rule. Rules with zero failures
  return a zero-row data.table.

## Details

Validate Data Against Quality Rules

## See also

[`personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md),
[`contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md)

## Examples

``` r
result <- validate_data(
  data       = govhr::bra_hrmis_contract,
  input_rules = govhr::contract_rules
)
result$report
#>                   Rule
#>                 <char>
#>  1:         Valid date
#>  2:       Valid status
#>  3: Unique contract ID
#>  4:  Unique assignment
#>  5:   Reasonable hours
#>  6:    Valid allowance
#>  7:  Allowance outlier
#>  8:      Base vs gross
#>  9:       Base outlier
#> 10:      Positive base
#> 11:  Gross composition
#> 12:      Gross outlier
#> 13:     Positive gross
#> 14:       Net vs gross
#> 15:        Net outlier
#> 16:       Positive net
#>                                                                                     Description
#>                                                                                          <char>
#>  1:            ref_date is a valid date (not in future, not before reasonable historical bound)
#>  2:                   employment status is valid (active contracts have start_date <= ref_date)
#>  3:           combination of contract_id and ref_date is unique (no duplicate contract records)
#>  4: combination of contract_id, personnel_id, and ref_date is unique (no duplicate assignments)
#>  5:                                                   working hours are positive and reasonable
#>  6:                                                       allowance is non-negative if provided
#>  7:                        allowance is not a statistical outlier (within IQR-based thresholds)
#>  8:                                                    base salary does not exceed gross salary
#>  9:                      base salary is not a statistical outlier (within IQR-based thresholds)
#> 10:                                                                     base salary is positive
#> 11:                                     gross salary is consistent with base salary + allowance
#> 12:                     gross salary is not a statistical outlier (within IQR-based thresholds)
#> 13:                                                                    gross salary is positive
#> 14:                                            net salary is less than or equal to gross salary
#> 15:                       net salary is not a statistical outlier (within IQR-based thresholds)
#> 16:                                                                      net salary is positive
#>     Total Records Passes Pass Rate Fails Errors
#>             <int>  <int>     <num> <int> <lgcl>
#>  1:         14773  14773    100.00     0  FALSE
#>  2:         14773  14738     99.76    35  FALSE
#>  3:         14773  14773    100.00     0  FALSE
#>  4:         14773  14773    100.00     0  FALSE
#>  5:         14773  14773    100.00     0  FALSE
#>  6:         14773   3857     26.11 10916  FALSE
#>  7:         14773  14569     98.62   204  FALSE
#>  8:         14773  11120     75.27     0  FALSE
#>  9:         14773  10692     72.38   428  FALSE
#> 10:         14773  11120     75.27     0  FALSE
#> 11:         14773  11120     75.27     0  FALSE
#> 12:         14773  14025     94.94   748  FALSE
#> 13:         14773  14773    100.00     0  FALSE
#> 14:         14773  14773    100.00     0  FALSE
#> 15:         14773  14186     96.03   587  FALSE
#> 16:         14773  14773    100.00     0  FALSE
result$violations[["salary_non_negative"]]
#> NULL
```
