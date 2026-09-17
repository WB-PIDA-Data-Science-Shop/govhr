# Harmonize column names based on a dictionary

This function standardizes column names in a data frame using a
dictionary that maps inconsistent or time-varying column names to a
standardized set of column names.

## Usage

``` r
harmonize_columns(data, dictionary)
```

## Arguments

- data:

  A data frame whose columns need to be renamed.

- dictionary:

  Either a named character vector (names are the desired standardized
  column names and values are the original column names), or a data
  frame with two columns: `from` (original column names) and `to`
  (standardized names).

## Value

A data frame with harmonized column names.

## Examples

``` r
# Using a named character vector
dict <- c("age" = "Q1_age", "gender" = "Q2_sex", "income" = "Q3_income")
df <- data.frame(Q1_age = 25, Q2_sex = "M", Q3_income = 50000)
harmonize_columns(df, dict)
#>   age gender income
#> 1  25      M  50000

# Using a data frame dictionary
dict_df <- data.frame(
  from = c("Q1_age", "Q2_sex", "Q3_income"),
  to = c("age", "gender", "income")
)
harmonize_columns(df, dict_df)
#>   age gender income
#> 1  25      M  50000
```
