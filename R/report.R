#' Generate Standard HR Analytics Report
#'
#' @description
#' Produces a comprehensive HTML analytics report for harmonized HR data using
#' a Quarto template. The report includes descriptive statistics, visualizations,
#' and optional quality control diagnostics across Contract, Personnel, and
#' Establishment modules.
#'
#' @param contracts A data.table containing the Contract module data with
#'   harmonized column names according to \code{\link{dictionary}}.
#'   Should include columns such as contract_id, personnel_id, est_id,
#'   ref_date, salary fields, and occupation information.
#' @param personnel A data.table containing the Personnel module data with
#'   harmonized column names. Should include personnel_id and demographic
#'   information.
#' @param establishments A data.table containing the Establishment module data with
#'   harmonized column names. Should include est_id and establishment
#'   characteristics.
#' @param country_code The reference country code. Must be specified in the three-letter, World Bank standard (e.g., BRA for Brazil).
#' @param output Character string specifying the output file name. Defaults to
#'   "hr_report.html". The file will be created in the current working
#'   directory.
#' @param contract_dt Deprecated. Use `contracts` instead.
#' @param personnel_dt Deprecated. Use `personnel` instead.
#' @param est_dt Deprecated. Use `establishments` instead.
#'
#' @returns An HR report, in HTML.
#'
#' @examples
#' \dontrun{
#' # Generate HR analytics report for Brazilian HRMIS data
#' generate_hr_report(
#'   contract_dt = bra_hrmis_contract,
#'   personnel_dt = bra_hrmis_personnel,
#'   establishments = bra_hrmis_est,
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
  contracts,
  personnel,
  establishments,
  country_code,
  output = "hr_report.html",
  contract_dt = NULL,
  personnel_dt = NULL,
  est_dt = NULL
) {
  contracts <- resolve_renamed_arg(contracts, contract_dt, "contract_dt", "contracts")
  personnel <- resolve_renamed_arg(personnel, personnel_dt, "personnel_dt", "personnel")
  establishments <- resolve_renamed_arg(establishments, est_dt, "est_dt", "establishments")
  qmd_path <- system.file(
    "templates",
    "standard_hr_report.qmd",
    package = "govhr"
  )

  rmarkdown::render(
    input = qmd_path,
    params = list(
      contract_dt = contracts,
      personnel_dt = personnel,
      country_code = country_code
    ),
    output_file = output
  )
}
