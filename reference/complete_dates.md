# Complete Panel Data by Identifier and Reference Dates

Expands a dataset to include all combinations of identifiers and
reference dates within a specified start–end range. This is useful for
ensuring that each identifier has a record for every time point, even if
data are missing.

## Usage

``` r
complete_dates(data, id_col, start_date, end_date, freq = "year")
```

## Arguments

- data:

  A data.frame or data.table containing at least an identifier column.

- id_col:

  Character. Name of the identifier column (e.g., \`"personnel_id"\`).

- start_date:

  Character or Date. Start of the full date sequence (e.g.,
  \`"2007-09-01"\`).

- end_date:

  Character or Date. End of the full date sequence (e.g.,
  \`"2018-01-01"\`).

- freq:

  Character. Interval for date sequence passed to `seq.Date(by = ...)`.
  Default is \`"year"\`.

## Value

A `data.table` containing all possible combinations of identifiers and
reference dates between the given start and end points, merged with the
original data.

## Details

This function generates a complete identifier–date grid using
[`seq.Date()`](https://rdrr.io/r/base/seq.Date.html) between
`start_date` and `end_date`, then merges it with the original dataset
using a left join (`all.x = TRUE`).

## Examples

``` r
if (FALSE) { # \dontrun{
complete_dt <- complete_dates(
  data = personnel_df,
  id_col = "personnel_id",
  start_date = "2007-09-01",
  end_date = "2018-01-01",
  freq = "year"
)
} # }
```
