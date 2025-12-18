# Quality Control Report

``` r
library(govhr)
```

``` r
# Generate the quality control report
generate_qc_report(
  contract_dt = govhr::bra_hrmis_contract,
  personnel_dt = govhr::bra_hrmis_personnel,
  est_dt = govhr::bra_hrmis_est,
  output = "quality_control_report.html"
)
```
