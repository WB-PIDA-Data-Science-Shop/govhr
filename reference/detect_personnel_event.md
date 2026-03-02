# Detect Personnel Events

Expands a dataset of personnel and reference dates to include all
possible personnel–date combinations, fills missing periods, and
identifies "hire" or "fire" events based on changes in status over time.

## Usage

``` r
detect_personnel_event(
  data,
  id_col,
  event_type,
  start_date,
  end_date,
  freq = "year"
)
```

## Arguments

- data:

  A data.table or data.frame containing at least the columns: -
  \`personnel_id\`: Unique identifier for personnel. - \`ref_date\`:
  Reference date (must be coercible to Date). - \`status\`: Personnel
  status (e.g., "active", "inactive").

- id_col:

  Character. Name of the identifier column (e.g., \`"personnel_id"\`).

- event_type:

  Character. Either \`"hire"\` or \`"fire"\`, controlling which event to
  detect.

- start_date:

  Optional start date for the full date sequence (default:
  \`"2007-09-01"\`).

- end_date:

  Optional end date for the full date sequence (default:
  \`"2018-01-01"\`).

- freq:

  Frequency for the sequence of dates (default: \`"year"\`). Can be any
  valid value for `seq.Date(by = ...)`.

## Value

A dataset with event types detected (e.g., hire or fire).

## Examples

``` r
if (FALSE) { # \dontrun{
hires <- detect_personnel_event(personnel_df, id_col = "personnel_id", start_date = "2007-09-01",
                       end_date = "2018-01-01", event_type = "hire")

fires <- detect_personnel_event(personnel_df, id_col = "personnel_id", start_date = "2007-09-01",
                       end_date = "2018-01-01", event_type = "fire")
} # }
```
