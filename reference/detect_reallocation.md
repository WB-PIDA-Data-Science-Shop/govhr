# Detect Personnel Reallocation Events

Identifies reallocation events when a personnel's set of establishments
changes between consecutive reference dates. Removes hire events and
only keeps reallocation events after the earliest reference date for
each personnel.

## Usage

``` r
detect_reallocation(data, personnel_hire)
```

## Arguments

- data:

  A data.frame or tibble containing at least the columns: -
  \`personnel_id\`: Unique personnel identifier. - \`ref_date\`:
  Reference date (Date or convertible to Date). - \`est_id\`:
  Establishment ID.

- personnel_hire:

  A data.frame or tibble containing hire events with columns
  \`personnel_id\` and \`ref_date\`.

## Value

A tibble with columns: - \`personnel_id\` - \`ref_date\` -
\`est_id_nested\`: List-column of establishment IDs for that personnel
and date. - \`type_event\`: \`"reallocation"\` or \`"no reallocation"\`.

## Examples

``` r
if (FALSE) { # \dontrun{
personnel_reallocation_df <- detect_reallocation(contract_rename_est_df, personnel_hire_df)
} # }
```
