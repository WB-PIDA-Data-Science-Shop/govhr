
generate_qc_report <- function(contract_dt,
                               personnel_dt,
                               est_dt,
                               output = "qc_report.html") {

  qc_obj <-
  compute_qualitycontrol(contract_dt = contract_dt,
                         personnel_dt = personnel_dt,
                         est_dt = est_dt)

  rmd_path <- system.file("templates",
                          "02a-standard_quality_control.rmd",
                          package = "govhr")

  rmarkdown::render(input = rmd_path,
                    params = list(contract_dt = contract_dt,
                                  personnel_dt = personnel_dt,
                                  est_dt = est_dt,
                                  qc_obj = qc_obj,
                                  run_qc = TRUE),
                    output_file = output)
}

