# Classify Personnel Movement Events

This function classifies the personnel module into three types of
movements: hires, fires, or retirements.

## Usage

``` r
classify_personnel_event(
  .data,
  id_col,
  event_type,
  start_date,
  end_date,
  status_col,
  freq = "year"
)
```

## Arguments

- .data:

  A data frame containing personnel data.

- id_col:

  The name of the column representing personnel IDs.

- event_type:

  The type of movement to classify (e.g., "hire", "fire", and
  "retirement").

- start_date:

  The start date for the classification period.

- end_date:

  The end date for the classification period.

- status_col:

  The name of the column representing employment status.

- freq:

  The frequency of the reference dates (default is "year").

## Value

A data frame with an additional column indicating the type of movement
for each personnel record.
