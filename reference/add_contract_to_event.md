# Add Contract Information to Event Records

This function merges contract information into an event dataset (such as
hires, terminations, or transfers) by matching on \`personnel_id\` and
\`ref_date\`. It ensures that selected variables from the contract
dataset are attached to corresponding events without duplicating
records.

## Usage

``` r
add_contract_to_event(event_dt, contract_dt, keep_vars)
```

## Arguments

- event_dt:

  A data.table containing personnel event records. Must include the
  columns \`personnel_id\` and \`ref_date\`.

- contract_dt:

  A data.table containing contract information, also including
  \`personnel_id\` and \`ref_date\`. The contract dataset provides
  additional attributes describing the personnel's contractual context
  on each reference date.

- keep_vars:

  A character vector of variable names in \`contract_dt\` to be merged
  into the event dataset. These typically describe contract-level
  attributes such as position, department, or employment type.

## Value

A data.table identical to \`event_dt\`, but with the specified variables
from \`contract_dt\` joined in by matching on \`personnel_id\` and
\`ref_date\`.

## Details

The function performs a \*right join\* operation of the \`contract_dt\`
onto \`event_dt\` (via \`data.table\`'s \`on\` syntax). Only unique
combinations of \`personnel_id\`, \`ref_date\`, and \`keep_vars\` are
retained from the contract dataset prior to the join, preventing
duplicate key matches.

This function is particularly useful when enriching HR event logs with
contextual information about the employee’s contract at the time of each
event.

## See also

\[data.table::merge()\], \[data.table::unique()\]

## Examples

``` r
if (FALSE) { # \dontrun{
library(data.table)

event_dt <- data.table(
  personnel_id = c(1, 2, 3),
  ref_date = as.IDate(c("2020-01-01", "2020-02-01", "2020-03-01")),
  type_event = c("hire", "fire", "hire")
)

contract_dt <- data.table(
  personnel_id = c(1, 2, 3),
  ref_date = as.IDate(c("2020-01-01", "2020-02-01", "2020-03-01")),
  department = c("Finance", "HR", "IT"),
  contract_type = c("permanent", "temporary", "consultant")
)

enriched_events <- add_contract_to_event(
  event_dt,
  contract_dt,
  keep_vars = c("department", "contract_type")
)
} # }
```
