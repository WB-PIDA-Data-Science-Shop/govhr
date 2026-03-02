#' Validate Data
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
#'   \item{Rule}{Short label for the rule}
#'   \item{Description}{Detailed explanation of what the rule checks}
#'   \item{Total Records}{Number of records evaluated}
#'   \item{Passes}{Number of records that passed the rule}
#'   \item{Fails}{Number of records that failed the rule}
#'   \item{Errors}{Whether the rule threw an error during evaluation}
#'
#' @details
#' The function validates data against user-defined rules using the validate package.
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
#' @importFrom validate validator confront description label summary
#' @importFrom dplyr left_join transmute %>%
#' @importFrom tibble tibble
#' @export
validate_data <- function(data, input_rules, output_format = c("report", "object")) {
  # Set rules
  validation_results <- validate::validator(
    .data = input_rules
  )

  # Confront the data with the rules
  results <- validate::confront(data, validation_results)
  
  # Extract rules metadata into a dataframe
  rules_meta <- as.data.frame(input_rules)
  
  # Extract the confrontation summary into a dataframe
  results_summary <- results |> 
    validate::summary() |> 
    tibble::tibble()
  
  # Join them together using the rule 'name'
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