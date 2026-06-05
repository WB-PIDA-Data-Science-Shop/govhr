# Compute Tenure from a Stacked Contract Panel (Panel Version)

Vectorised equivalent of
[`compute_tenure`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure.md)
for a panel dataset where `ref_date_col` is a column rather than a
scalar. Computes cumulative years of service per *person × snapshot* in
a single pass over the full stacked panel — no per-snapshot loop
required.

The union-of-intervals algorithm is identical to `compute_tenure`:
contracts are sorted by start date, a `cummax` propagates the furthest
end seen so far, and each interval's contribution is classified as a new
span, partial extension, or nested (zero-contribution) segment. The key
difference is that `ref_date_col` participates in every row-wise
comparison and in the `cummax` grouping key, so each
`(personnel_id, ref_date)` pair is handled independently.

## Usage

``` r
compute_tenure_panel(
  contract_dt,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type_code"
)
```

## Arguments

- contract_dt:

  data.table. Full stacked contract panel. Must contain
  `personnel_id_col`, `ref_date_col`, `contract_id_col`,
  `start_date_col`, `end_date_col`, and `contract_type_col`.

- personnel_id_col:

  Character. Default: `"personnel_id"`.

- ref_date_col:

  Character. Name of the snapshot date column. Default: `"ref_date"`.

- contract_id_col:

  Character. Default: `"contract_id"`.

- start_date_col:

  Character. Default: `"start_date"`.

- end_date_col:

  Character. Default: `"end_date"`.

- contract_type_col:

  Character. Default: `"contract_type_code"`.

## Value

data.table with columns `personnel_id_col`, `ref_date_col`, and
`tenure_years`. One row per unique `(personnel_id, ref_date)`
combination present in `contract_dt`.
