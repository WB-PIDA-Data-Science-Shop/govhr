#' Validate Data Against Quality Rules
#'
#' @title Validate Data Quality Using Rule-Based Framework
#'
#' @description
#' Validates data against a set of predefined rules.
#' Returns either a summary report or the full validation object.
#'
#' @param data A data.frame or data.table.
#' @param input_rules A set of rules, defined in a dataframe.
#' @param output_format A string specifying the output format: "report" for a summary report or "object" for the raw validation results.
#'
#' @return A data.frame containing the audit report with columns:
#'   \item{Rule}{Short label for the rule (from input_rules$label)}
#'   \item{Description}{Detailed explanation of what the rule checks}
#'   \item{Total Records}{Number of records evaluated}
#'   \item{Passes}{Number of records that passed the rule}
#'   \item{Pass Rate}{Percentage of records passing (0-100)}
#'   \item{Fails}{Number of records that failed the rule}
#'   \item{Errors}{Logical indicating whether the rule threw an error}
#'
#' @details
#' The function validates data against user-defined rules using the validate package.
#'
#' @examples
#' # Validate contract data
#' audit_report <- validate_data(
#'   data = govhr::bra_hrmis_contract,
#'   input_rules = govhr::contract_rules
#' )
#' 
#' # View the audit report
#' print(audit_report)
#' 
#' # Check rules with failures
#' audit_report[audit_report$Fails > 0, ]
#'
#' @seealso
#' \code{\link{personnel_rules}} for personnel validation rules
#' \code{\link{contract_rules}} for contract validation rules
#'
#' @importFrom validate validator confront description label summary
#' @importFrom dplyr left_join transmute %>%
#' @importFrom tibble tibble
#' @export
validate_data <- function(data, input_rules, output_format = c("report", "object")) {
  # Set rules
  validation_results <- validate::validator(
    .data = input_rules
  )

  # Step 2: Confront data with rules
  # This evaluates each rule against the data and tracks pass/fail/error status
  # for each record. The confrontation object stores detailed results.
  results <- validate::confront(data, validation_results)
  
  # Step 3: Extract rule metadata
  # Convert input_rules tibble to base data.frame for compatibility with
  # validate package output format.
  rules_meta <- as.data.frame(input_rules)
  
  # Step 4: Extract summary statistics
  # summary() returns a table with columns: name, items, passes, fails, nNA, error
  # We convert to data.frame for dplyr operations.
  results_summary <- results |> 
    validate::summary() |> 
    as.data.frame()
  
  # Step 5: Join results with metadata and format for stakeholders
  audit_report <- results_summary %>%
    dplyr::left_join(rules_meta, by = "name") %>%
    # Select and rename the columns you want stakeholders to see
    dplyr::transmute(
      Rule = .data[['label']],
      Description = .data[['description']],
      `Total Records` = .data[['items']],
      Passes = .data[['passes']],
      `Pass Rate` = round(.data[['passes']] / .data[['items']] * 100, 2),
      Fails = .data[['fails']],
      Errors = .data[['error']]
    )
  
  type <- match.arg(output_format)
  
  output <- switch(
    type,
    "object" = results,
    "report" = audit_report
  )

  return(output)
}