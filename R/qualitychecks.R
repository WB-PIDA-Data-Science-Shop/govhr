#' Compute Comprehensive Quality Control Checks for Harmonized HRMIS Data
#'
#' This function runs a full suite of quality control (QC) diagnostics across
#' three harmonized HRMIS modules—contract, personnel, and establishment.
#' It performs structure checks against a harmonization dictionary,
#' primary key uniqueness checks, orphan detection across modules, salary
#' validation, date logic checks, missingness profiling, and volatility
#' analysis for selected indicators.
#'
#' @param contract_dt A data.frame or data.table containing the harmonized
#'   Contract module.
#' @param personnel_dt A data.frame or data.table containing the harmonized
#'   Personnel module.
#' @param est_dt A data.frame or data.table containing the harmonized
#'   Establishment module.
#'
#' @details
#' The function executes the following QC components:
#'
#' \describe{
#'   \item{\strong{Structure checks}}{
#'     Verifies that variable names in each module match those expected in the
#'     harmonization dictionary.
#'   }
#'
#'   \item{\strong{Primary key uniqueness}}{
#'     Tests whether \code{contract_id}, \code{personnel_id}, and
#'     \code{ref_date} uniquely identify observations in the Contract module.
#'   }
#'
#'   \item{\strong{Orphan checks}}{
#'     Detects cases where contract data reference personnel or establishment
#'     IDs not present in the respective parent modules.
#'   }
#'
#'   \item{\strong{Salary checks}}{
#'     Validates salary fields for numeric type, non-negativity, and logical
#'     consistency (e.g., base salary ≤ gross salary ≥ net salary).
#'   }
#'
#'   \item{\strong{Date logic}}{
#'     Identifies contracts with \code{end_date < start_date}.
#'   }
#'
#'   \item{\strong{Missingness profiling}}{
#'     Computes missingness overall and by occupation, ISCO category,
#'     reference date, and establishment.
#'   }
#'
#'   \item{\strong{Volatility analysis}}{
#'     Calculates period-over-period volatility in wage bill, salaries, staffing
#'     counts, and contract counts using the \code{compute_volatility()} function.
#'   }
#' }
#'
#' @return
#' A named list containing:
#'
#' \describe{
#'   \item{\code{n_obs}}{Number of observations in the Contract module.}
#'   \item{\code{n_vars}}{Number of variables in the Contract module.}
#'   \item{\code{structure}}{Results of structure/dictionary checks for each module.}
#'   \item{\code{keys}}{Primary key uniqueness diagnostics.}
#'   \item{\code{orphans}}{Orphan record diagnostics across modules.}
#'   \item{\code{salaries}}{Salary consistency and validation results.}
#'   \item{\code{date_logic}}{Results of date-related logical checks.}
#'   \item{\code{missingness}}{Missingness summaries overall and by grouping.}
#'   \item{\code{volatility}}{Volatility diagnostics for selected indicators.}
#' }
#'
#' @importFrom data.table as.data.table :=
#'
#' @examples
#' \dontrun{
#' qc <- compute_qualitycontrol(
#'   contract_dt = bra_hrmis_contract,
#'   personnel_dt = bra_hrmis_personnel,
#'   est_dt = bra_hrmis_est
#' )
#'
#' qc$structure
#' qc$salaries
#' }
#'
#' @export


compute_qualitycontrol <- function(contract_dt,
                                   personnel_dt,
                                   est_dt){

  ### ensure all modules are data.tables
  contract_dt <- as.data.table(contract_dt)
  personnel_dt <- as.data.table(personnel_dt)
  est_dt <- as.data.table(est_dt)

  ### structure and dictionary checks

  dict_list <- split(harmonization_dict,
                     harmonization_dict$Module)
  

  structure_checks <-
    mapply(FUN = function(data,
                          dict_names){
      
      
      
      structure_checks <- qc_compare_names(data = data,
                                           dict_names = dict_names$VariableID,
                                           output_format = "badges")

      return(structure_checks)

    }, data = list(contract_dt, est_dt, personnel_dt),
       dict_names = dict_list,
       SIMPLIFY = FALSE)



  key_checks <- qc_primary_key_uniqueness(dt = contract_dt,
                                          keys = c("contract_id", "personnel_id", "ref_date"))


  ### checking for orphan keys (i.e. personnel IDs in bra_hrmis_contract)
  orphan_checks <- list()

  orphan_checks$personnel_vs_contract <- qc_merge_check(
    parent_dt = personnel_dt,
    child_dt  = contract_dt,
    parent_id = "personnel_id",
    child_id  = "personnel_id"
  )

  orphan_checks$establishment_vs_contract <- qc_merge_check(
    parent_dt = est_dt,
    child_dt  = contract_dt,
    parent_id = "est_id",
    child_id  = "est_id"
  )


  # -----------------------------------
  # 4. SALARY CHECKS
  # -----------------------------------
  salary_vars <- colnames(contract_dt)[grepl("_salary_",
                                             colnames(contract_dt))]

  salary_checks <- qc_salary_checks(contract_dt, cols = salary_vars)

  # -----------------------------------
  # 5. DATE LOGIC
  # -----------------------------------
  date_checks <- contract_dt[, .(n_end_before_start = sum(!is.na(end_date) & end_date < start_date))]

  # -----------------------------------
  # 6. MISSINGNESS
  # -----------------------------------
  missingness <- list(overall = compute_missingness(data = contract_dt),
                      by_occupation = compute_missingness(data = contract_dt,
                                                          by = "occupation_native"),
                      by_isco = compute_missingness(data = contract_dt,
                                                    by = c("occupation_isconame")),
                      by_ref = compute_missingness(data = contract_dt,
                                                   by = c("ref_date")),
                      by_est = compute_missingness(data = contract_dt,
                                                   by = c("est_id")))

  # -----------------------------------
  # 7. VOLATILITY
  # -----------------------------------
  gaps <- length(unique(contract_dt$ref_date))

  window_size = max(2, floor(gaps / 2))

  ## contract level 
  contract_volatility <- 
    list(salary_vol = bind_rows(compute_volatility(data = contract_dt,
                                                   col = "gross_salary_lcu",
                                                   agg_fn = "sum",
                                                   vol_fn = "rolling_cv",
                                                   time = "ref_date",
                                                   groups = "contract_id",
                                                   window_size = window_size),
                                compute_volatility(data = contract_dt,
                                                   col = "base_salary_lcu",
                                                   agg_fn = "sum",
                                                   vol_fn = "rolling_cv",
                                                   time = "ref_date",
                                                   groups = "contract_id",
                                                   window_size = window_size),
                                compute_volatility(data = contract_dt,
                                                   col = "net_salary_lcu",
                                                   agg_fn = "sum",
                                                   vol_fn = "rolling_cv",
                                                   time = "ref_date",
                                                   groups = "contract_id",
                                                   window_size = window_size),
                                compute_volatility(data = contract_dt,
                                                   col = "allowance_lcu",
                                                   agg_fn = "sum",
                                                   vol_fn = "rolling_cv",
                                                   time = "ref_date",
                                                   groups = "contract_id",
                                                   window_size = window_size)),
          ctrcount_vol = compute_volatility(data = contract_dt,
                                            col = "contract_id",
                                            agg_fn = "count_unique",
                                            vol_fn = "pct_change",
                                            time = "ref_date",
                                            groups = "est_id",
                                            window_size = window_size),
          workhours_vol = compute_volatility(data = contract_dt,
                                             col = "whours",
                                             agg_fn = "sum",
                                             vol_fn = "rolling_cv",
                                             time = "ref_date",
                                             groups = "contract_id",
                                             window_size = window_size))
  
 ### put together all the objects
  qc_object <- list(n_obs = nrow(contract_dt),
                    n_vars = ncol(contract_dt),
                    structure = structure_checks,
                    keys = key_checks,
                    orphans = orphan_checks,
                    salaries = salary_checks,
                    date_logic = date_checks,
                    missingness = missingness,
                    volatility = contract_volatility)

  return(qc_object)


}


