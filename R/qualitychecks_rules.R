#' Validate Data
#'
#' @description
#' Validates conract data against a set of consistency rules.
#' Returns an audit report data frame
#' with validation results.
#'
#' @param data A data.frame or data.table.
#' @param input_rules A set of rules, defined in a dataframe.
#'
#' @return A data.frame containing the audit report with columns:
#'   \item{Rule}{Short label for the rule}
#'   \item{Description}{Detailed explanation of what the rule checks}
#'   \item{Total Records}{Number of records evaluated}
#'   \item{Passes}{Number of records that passed the rule}
#'   \item{Fails}{Number of records that failed the rule}
#'   \item{Errors}{Whether the rule threw an error during evaluation}
#'
#' @details
#' The function checks the data according to user-inputed rules.
#'
#' @examples
#' # run validation
#' audit_report <- validate_data(
#'     govhr::bra_hrmis_contract, govhr::contract_rules
#' )
#' 
#' # view the audit report
#' print(audit_report)
#'
#' @importFrom validate validator confront description label
#' @importFrom dplyr left_join select %>%
#' @export
validate_data <- function(data, input_rules) {
  # Set rules
  validation_results <- validate::validator(
    data, .data = input_rules
  )

  # Confront the data with the rules
  results <- validate::confront(data, validation_results)
  
  # Extract rules metadata into a dataframe
  rules_meta <- as.data.frame(input_rules)
  
  # Extract the confrontation summary into a dataframe
  results_summary <- as.data.frame(summary(results))
  
  # Join them together using the rule 'name'
  audit_report <- results_summary %>%
    dplyr::left_join(rules_meta, by = "name") %>%
    # Select and rename the columns you want stakeholders to see
    dplyr::select(
      Rule = label,
      Description = description,
      `Total Records` = items,
      Passes = passes,
      Fails = fails,
      Errors = error
    )
  
  return(audit_report)
}