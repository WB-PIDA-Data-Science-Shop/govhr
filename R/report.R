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

