# Validate Data

Validates data against a set of predefined rules. Returns either a
summary report or the full validation object.

## Usage

``` r
validate_data(data, input_rules, output_format = c("report", "object"))
```

## Arguments

- data:

  A data.frame or data.table.

- input_rules:

  A set of rules, defined in a dataframe.

- output_format:

  A string specifying the output format: "report" for a summary report
  or "object" for the raw validation results.

## Value

A data.frame containing the audit report with columns:

- Rule:

  Short label for the rule

- Description:

  Detailed explanation of what the rule checks

- Total Records:

  Number of records evaluated

- Passes:

  Number of records that passed the rule

- Fails:

  Number of records that failed the rule

- Errors:

  Whether the rule threw an error during evaluation

## Details

The function validates data against user-defined rules using the
validate package.

## Examples

``` r
# run validation
audit_report <- validate_data(
    govhr::bra_hrmis_contract, govhr::contract_rules
)

# view the audit report
print(audit_report)
#> # A tibble: 16 × 7
#>    Rule              Description `Total Records` Passes `Pass Rate` Fails Errors
#>    <chr>             <chr>                 <int>  <int>       <dbl> <int> <lgl> 
#>  1 Unique contract … combinatio…            8885   8885       100       0 FALSE 
#>  2 Unique assignment combinatio…            8885   8885       100       0 FALSE 
#>  3 Valid date        ref_date i…            8885   8885       100       0 FALSE 
#>  4 Reasonable hours  working ho…            8885   6208        69.9  2677 FALSE 
#>  5 Valid status      employment…            8885   8868        99.8    17 FALSE 
#>  6 Gross composition gross sala…            8885   5872        66.1     1 FALSE 
#>  7 Net vs gross      net salary…            8885   7955        89.5     0 FALSE 
#>  8 Positive gross    gross sala…            8885   7955        89.5     0 FALSE 
#>  9 Positive base     base salar…            8885   5867        66.0     6 FALSE 
#> 10 Positive net      net salary…            8885   7955        89.5     0 FALSE 
#> 11 Base vs gross     base salar…            8885   5872        66.1     1 FALSE 
#> 12 Valid allowance   allowance …            8885   3107        35.0  5778 FALSE 
#> 13 Gross outlier     gross sala…            8885   7530        84.8   425 FALSE 
#> 14 Net outlier       net salary…            8885   7599        85.5   356 FALSE 
#> 15 Base outlier      base salar…            8885   5653        63.6   220 FALSE 
#> 16 Allowance outlier allowance …            8885   8790        98.9    95 FALSE 
```
