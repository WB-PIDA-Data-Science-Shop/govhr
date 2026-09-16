#' Validate Data Against Quality Rules
#'
#' @title Validate Data Quality Using Rule-Based Framework
#'
#' @description
#' Validates data against a set of predefined rules.
#' Always returns a named list with two elements: \code{report} (an audit
#' summary data.table) and \code{violations} (a named list of data.tables,
#' one per rule, containing only the rows that failed that rule). This
#' structure supports both tabular display and row-level drill-down in Shiny.
#'
#' @param data A data.frame or data.table.
#' @param input_rules A data.frame of rules with columns \code{rule},
#'   \code{name}, \code{description}, \code{label}.
#' @param output_format Deprecated — kept for backward compatibility but
#'   ignored. The function now always returns \code{list(report, violations)}.
#'
#' @return A named list:
#' \describe{
#'   \item{\code{report}}{data.table with columns \code{Rule},
#'     \code{Description}, \code{Total Records}, \code{Passes},
#'     \code{Pass Rate}, \code{Fails}, \code{Errors}.}
#'   \item{\code{violations}}{Named list of data.tables, one per rule label.
#'     Each element contains the rows of \code{data} that failed that rule.
#'     Rules with zero failures return a zero-row data.table.}
#' }
#'
#' @examples
#' result <- validate_data(
#'   data       = govhr::bra_hrmis_contract,
#'   input_rules = govhr::contract_rules
#' )
#' result$report
#' result$violations[["salary_non_negative"]]
#'
#' @seealso
#' \code{\link{personnel_rules}}, \code{\link{contract_rules}}
#'
#' @importFrom validate validator confront description label summary values
#' @importFrom data.table as.data.table
#' @export
validate_data <- function(
  data,
  input_rules,
  output_format = c("report", "object")
) {
  data <- data.table::as.data.table(data)

  ## build validator and confront
  validation_results <- validate::validator(.data = input_rules)
  results <- validate::confront(data, validation_results)

  ## --- audit report -------------------------------------------------------
  rules_meta <- as.data.frame(input_rules)
  results_summary <- as.data.frame(validate::summary(results))

  audit_report <- data.table::as.data.table(
    merge(results_summary, rules_meta, by = "name", all.x = TRUE)
  )[, .(
    name,
    Rule = label,
    Description = description,
    `Total Records` = items,
    Passes = passes,
    `Pass Rate` = round(passes / items * 100, 2),
    Fails = fails,
    Errors = error
  )]

  ## --- per-rule violating rows --------------------------------------------
  ## validate::values() → logical array: rows = observations, cols = rules
  ## FALSE  = rule failed for that row
  ## NA     = rule could not be evaluated (treated as a violation)
  pass_matrix <- as.data.frame(validate::values(results)) ## nrow(data) × n_rules logical matrix

  ## map rule internal names → user-facing labels for the list names
  name_to_label <- stats::setNames(rules_meta$label, rules_meta$name)

  violations <- lapply(names(pass_matrix), function(rule_name) {
    lgl <- pass_matrix[[rule_name]]
    fail_rows <- which(!lgl | is.na(lgl))
    data[fail_rows]
  })
  names(violations) <- name_to_label[names(pass_matrix)]

  ## drop internal 'name' column before returning
  audit_report[, name := NULL]

  list(report = audit_report, violations = violations)
}
