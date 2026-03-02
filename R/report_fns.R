#' Generate Quality Control Report for HR Data
#'
#' @description
#' Produces a comprehensive HTML quality control report for harmonized HR data.
#' The report includes diagnostics on data structure, primary key integrity,
#' cross-module orphan checks, missingness patterns, and temporal volatility
#' across Contract, Personnel, and Establishment modules.
#'
#' @param contract_dt A data.table containing the Contract module data with
#'   harmonized column names according to \code{\link{dictionary}}.
#'   Should include columns such as contract_id, personnel_id, est_id,
#'   ref_date, salary fields, and occupation information.
#' @param personnel_dt A data.table containing the Personnel module data with
#'   harmonized column names. Should include personnel_id and demographic
#'   information.
#' @param est_dt A data.table containing the Establishment module data with
#'   harmonized column names. Should include est_id and establishment
#'   characteristics.
#' @param output Character string specifying the output file name. Defaults to
#'   "qc_report.html". The file will be created in the current working
#'   directory.
#'
#' @return A quality control report, in HTML.
#'
#' The generated report includes:
#' \itemize{
#'   \item Module dimensions and variable structure conformity
#'   \item Primary key uniqueness checks
#'   \item Cross-module orphan record identification
#'   \item Comprehensive missingness analysis with visualizations
#'   \item Temporal volatility metrics for salary, wagebill, and staff counts
#' }
#'
#' @examples
#' \dontrun{
#' # Generate quality control report for Brazilian HRMIS data
#' generate_qc_report(
#'   contract_dt = bra_hrmis_contract,
#'   personnel_dt = bra_hrmis_personnel,
#'   est_dt = bra_hrmis_est,
#'   output = "brazil_qc_report.html"
#' )
#' }
#'
#' @seealso
#' \code{\link{compute_qualitycontrol}} for the underlying diagnostic functions
#' \code{\link{dictionary}} for the harmonization dictionary
#'
#' @importFrom rmarkdown render
#' @export
generate_qc_report <- function(
  contract_dt,
  personnel_dt,
  est_dt,
  output = "qc_report.html"
) {
  qc_obj <-
    compute_qualitycontrol(
      contract_dt = contract_dt,
      personnel_dt = personnel_dt,
      est_dt = est_dt
    )

  rmd_path <- system.file(
    "templates",
    "02a-standard_quality_control.rmd",
    package = "govhr"
  )

  rmarkdown::render(
    input = rmd_path,
    params = list(
      contract_dt = contract_dt,
      personnel_dt = personnel_dt,
      est_dt = est_dt,
      qc_obj = qc_obj,
      run_qc = TRUE
    ),
    output_file = output
  )
}

#' Generate Standard HR Analytics Report
#'
#' @description
#' Produces a comprehensive HTML analytics report for harmonized HR data using
#' a Quarto template. The report includes descriptive statistics, visualizations,
#' and optional quality control diagnostics across Contract, Personnel, and
#' Establishment modules.
#'
#' @param contract_dt A data.table containing the Contract module data with
#'   harmonized column names according to \code{\link{dictionary}}.
#'   Should include columns such as contract_id, personnel_id, est_id,
#'   ref_date, salary fields, and occupation information.
#' @param personnel_dt A data.table containing the Personnel module data with
#'   harmonized column names. Should include personnel_id and demographic
#'   information.
#' @param est_dt A data.table containing the Establishment module data with
#'   harmonized column names. Should include est_id and establishment
#'   characteristics.
#' @param country_code The reference country code. Must be specified in the three-letter, World Bank standard (e.g., BRA for Brazil).
#' @param output Character string specifying the output file name. Defaults to
#'   "hr_report.html". The file will be created in the current working
#'   directory.
#'
#' @return An HR report, in HTML.
#'
#' @examples
#' \dontrun{
#' # Generate HR analytics report for Brazilian HRMIS data
#' generate_hr_report(
#'   contract_dt = bra_hrmis_contract,
#'   personnel_dt = bra_hrmis_personnel,
#'   est_dt = bra_hrmis_est,
#'   country_code = "BRA",
#'   output = "brazil_hr_report.html"
#' )
#' }
#'
#' @seealso
#' \code{\link{generate_qc_report}} for the data quality assessment report.
#' \code{\link{dictionary}} for the harmonization dictionary.
#'
#' @importFrom rmarkdown render
#' @export
generate_hr_report <- function(
  contract_dt,
  personnel_dt,
  est_dt,
  country_code,
  output = "hr_report.html"
) {
  qmd_path <- system.file(
    "templates",
    "standard_hr_report.qmd",
    package = "govhr"
  )

  rmarkdown::render(
    input = qmd_path,
    params = list(
      contract_dt = contract_dt,
      personnel_dt = personnel_dt,
      country_code = country_code
    ),
    output_file = output
  )
}

