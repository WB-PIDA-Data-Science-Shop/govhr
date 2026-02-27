#' Validate Data Against Quality Rules
#'
#' @title Validate Data Quality Using Rule-Based Framework
#'
#' @description
#' Validates HR data (personnel or contract records) against a set of 
#' predefined consistency rules using the \code{validate} package. Returns
#' a stakeholder-friendly audit report showing pass/fail rates for each rule.
#' 
#' This function is designed to work with rule sets defined as data frames
#' (e.g., \code{govhr::personnel_rules} or \code{govhr::contract_rules})
#' containing rule expressions, names, descriptions, and labels.
#'
#' @param data A data.frame or data.table containing the HR data to validate.
#'   Must include columns referenced in the validation rules.
#' @param input_rules A data.frame containing validation rules with columns:
#'   \itemize{
#'     \item \code{rule}: R expression as a character string (e.g., "age >= 18")
#'     \item \code{name}: Unique identifier for the rule
#'     \item \code{description}: Human-readable explanation
#'     \item \code{label}: Short label for reports/plots
#'   }
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
#' The function follows this workflow:
#' \enumerate{
#'   \item Parse rule expressions from input_rules$rule into validator object
#'   \item Confront the data with rules using validate::confront()
#'   \item Extract summary statistics (passes, fails, errors)
#'   \item Join summary with rule metadata (descriptions, labels)
#'   \item Format output as stakeholder-friendly report
#' }
#' 
#' Design rationale:
#' \itemize{
#'   \item Uses validate package for robust rule evaluation
#'   \item Separates rule definitions (data) from validation logic (function)
#'   \item Returns tidy data frame suitable for reporting/visualization
#'   \item Uses .data[[]] pronoun to avoid R CMD check NOTEs
#' }
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
#' @export
validate_data <- function(data, input_rules) {
  
  # Step 1: Create validator object from rule expressions
  # The validate package requires rules as a validator object, not a data frame.
  # We pass input_rules directly, and validator() will parse the 'rule' column.
  validation_results <- validate::validator(
    data, .data = input_rules
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
    dplyr::transmute(
      Rule = .data[['label']],                                    # Short label
      Description = .data[['description']],                       # Full explanation
      `Total Records` = .data[['items']],                        # N evaluated
      Passes = .data[['passes']],                                # N passed
      `Pass Rate` = .data[['passes']] / .data[['items']] * 100, # Percentage
      Fails = .data[['fails']],                                  # N failed
      Errors = .data[['error']]                                  # Error flag
    )
  
  return(audit_report)
}