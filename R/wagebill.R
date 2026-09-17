
#' Compute wage bill aggregates with optional macro-fiscal shares
#'
#' @description
#' Computes aggregate wage bill statistics from contract-level salary data.
#' The function converts salary variables to constant purchasing power parity
#' (PPP) using macro indicators, then aggregates by specified grouping variables.
#' Optionally computes wage bill shares relative to macro-fiscal aggregates
#' (e.g., GDP, public expenditure, revenue).
#'
#' @param contracts A data.frame or tibble containing contract-level salary data.
#'   Must include the columns specified in `wage_vars` and `groups`.
#' @param wage_vars Character vector of salary column names to aggregate.
#'   Defaults to `c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu")`.
#' @param group_cols Character vector of grouping columns for aggregation.
#'   Defaults to `c("country_code", "year")`.
#' @param share_macro Logical; if `TRUE`, computes wage bill shares relative
#'   to macro-fiscal aggregates specified in `macro_vars`. Defaults to `FALSE`.
#' @param macro_vars Character vector of macro indicator column names to use
#'   as denominators when `share_macro = TRUE`. Defaults to
#'   `c("gdp_lcu", "pexpenditure_lcu", "prevenue_lcu", "taxrevenue_lcu")`.
#' @param drop_na Logical; if `TRUE`, removes `NA` values before aggregation.
#'   Defaults to `TRUE`.
#' @param groups Deprecated. Use `group_cols` instead.
#' @param contract_df Deprecated. Use `contracts` instead.
#'
#' @returns A wage bill table with optional grouping variables,
#'   an `indicator` column (describing the wage variable and level of analysis),
#'   and a `value` column. When `share_macro = TRUE`, values represent
#'   shares (wage bill / macro aggregate).
#'
#' @examples
#' # Compute wage bill totals by country and year
#' \dontrun{
#' compute_wagebill(
#'   contract_df = govhr::bra_hrmis_contract,
#'   wage_vars = c("gross_salary_lcu"),
#'   groups = c("country_code", "year")
#' )
#'
#' # Compute wage bill as share of GDP and public expenditure
#' compute_wagebill(
#'   contract_df = govhr::bra_hrmis_contract,
#'   wage_vars = c("gross_salary_lcu", "net_salary_lcu"),
#'   groups = c("country_code", "year"),
#'   share_macro = TRUE,
#'   macro_vars = c("gdp_lcu", "pexpenditure_lcu")
#' )
#' }
#'
#' @seealso
#' \code{\link{convert_constant_ppp}} for PPP conversion
#' \code{\link{compute_fastsummary}} for general aggregation
#' \code{\link{compute_fastshare}} for share computation (when `share_macro = TRUE`)
#'
#' @export
compute_wagebill <- function(
  contracts,
  wage_vars = c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu"),
  group_cols = c("country_code", "year"),
  share_macro = FALSE,
  macro_vars = c(
    "gdp_lcu",
    "pexpenditure_lcu",
    "prevenue_lcu",
    "taxrevenue_lcu"
  ),
  drop_na = TRUE,
  groups = NULL,
  contract_df = NULL
) {
  group_cols <- resolve_renamed_arg(group_cols, groups, "groups", "group_cols")
  contracts <- resolve_renamed_arg(contracts, contract_df, "contract_df", "contracts")
  data_ppp <- contracts |>
    convert_constant_ppp(
      cols = wage_vars
    )

  if (share_macro) {
    data_ppp |>
      compute_fastshare(
        cols = wage_vars,
        macro_cols = macro_vars,
        group_cols = group_cols,
        fns = "sum",
        output = "long"
      )
  } else {
    data_ppp |>
      compute_fastsummary(
        cols = wage_vars,
        group_cols = group_cols,
        fns = "sum",
        output = "long"
      )
  }
}
