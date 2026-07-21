# Compute total time spent in each specific group per person (eg paygrade, occupation)

Derives, for each person and (optionally) each grouping variable such as
paygrade, the total cumulative tenure accrued in that state, taken from
the most recent panel snapshot at which the person is still observed in
that state. Built on top of
[`compute_tenure_panel`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure_panel.md),
which computes overlap-safe cumulative tenure at every reference date;
this function collapses that panel down to one row per
`personnel_id`/`group_cols` combination by keeping only the latest
`ref_date` at which the combination appears.

## Usage

``` r
compute_employment_spells(
  contract_dt,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL
)
```

## Arguments

- contract_dt:

  data.table. Stacked contract panel, as passed to
  [`compute_tenure_panel`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure_panel.md).

- personnel_id_col:

  Character. Name of the personnel identifier column. Default is
  `"personnel_id"`.

- ref_date_col:

  Character. Name of the reference date column. Default is `"ref_date"`.

- contract_id_col:

  Character. Name of the contract identifier column. Default is
  `"contract_id"`.

- start_date_col:

  Character. Name of the contract start date column. Default is
  `"start_date"`.

- end_date_col:

  Character. Name of the contract end date column. Default is
  `"end_date"`.

- contract_type_col:

  Character. Name of the contract type column. Default is
  `"contract_type"`.

- group_cols:

  Optional character vector of additional variables over which tenure
  should be calculated independently (for example, establishment,
  occupation, or organization). Default is `NULL`.

## Value

A data.table with one row per unique combination of `personnel_id` and
`group_cols`, containing:

- ref_date:

  The last reference date at which the person was observed in this
  `group_cols` state.

- spell_years:

  Total cumulative tenure, in years, accrued in this state as of that
  date.

## Details

A `group_cols` combination (e.g. `paygrade`, or `contract_id` +
`paygrade`) stops appearing in the underlying tenure panel once the
person's recorded state changes, so the last `ref_date` at which a
combination is observed marks the end of that spell. `spell_years` is
the cumulative tenure value at that final snapshot, summed across any
residual duplicate rows for the same combination and date.

Two caveats affect interpretation:

- If `contract_id` is included in `group_cols` and a person is renewed
  onto a new contract while remaining on the same paygrade, this will be
  treated as two separate spells rather than one continuous spell,
  understating true time-in-grade for that person.

- If a person leaves a given `group_cols` state and later returns to it
  (e.g. paygrade A -\> B -\> A) under the same grouping combination, the
  two non-contiguous stints are combined into a single spell, and
  `spell_years` will reflect their combined duration rather than just
  the most recent stint.

This function does not distinguish spells that ended because the person
transitioned to a new state from spells that are still ongoing as of the
last available panel snapshot (right-censored spells); both are treated
identically.

## See also

[`compute_tenure_panel`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure_panel.md)
