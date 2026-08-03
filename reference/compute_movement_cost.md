# Function to compute the total cost associated with personnel movements.

Function to compute the total cost associated with personnel movements.

## Usage

``` r
compute_movement_cost(
  .data,
  id_col = "personnel_id",
  event_type,
  start_date = NULL,
  end_date = NULL,
  status_col = "employment_status",
  freq = NULL,
  measure_col,
  group_cols = NULL,
  latest_measure = FALSE
)
```

## Arguments

- .data:

  A data frame containing the data to be processed.

- id_col:

  The name of the column representing personnel IDs (default is
  "personnel_id").

- event_type:

  A character vector indicating which movement event(s) to include
  (e.g., "hire", "fire", "retirement"). Multiple types can be supplied
  to compute costs for each type.

- start_date:

  The start date for the classification period. Defaults to the minimum
  reference date found in \`.data\`.

- end_date:

  The end date for the classification period. Defaults to the maximum
  reference date found in \`.data\`.

- status_col:

  The name of the column representing employment status (default is
  "employment_status").

- freq:

  The frequency of the reference dates. Defaults to a guess based on
  \`.data\`.

- measure_col:

  The name of the column containing the cost/measure to sum.

- group_cols:

  A character vector of column names to group the data by.

- latest_measure:

  A logical value indicating whether to return only the measures for the
  latest reference date.

## Value

A data frame containing the movement cost for each requested event type
within the specified groups and reference dates.
