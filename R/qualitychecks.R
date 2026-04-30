#' Compute Comprehensive Quality Control Checks for Harmonized HRMIS Data
#'
#' @description
#' Runs a full suite of QC diagnostics across the three harmonized HRMIS
#' modules—contract, personnel, and establishment.  Rule-based validation
#' uses the \pkg{validate} framework and the built-in
#' \code{govhr::contract_rules} / \code{govhr::personnel_rules} datasets,
#' optionally extended with country-specific rules supplied via
#' \code{custom_rules}.
#'
#' @param contract_dt A data.frame or data.table — harmonized Contract module.
#' @param personnel_dt A data.frame or data.table — harmonized Personnel module.
#' @param est_dt A data.frame or data.table — harmonized Establishment module.
#' @param custom_rules A named list with optional elements \code{contract} and
#'   \code{personnel}, each a data.frame with the same four-column schema as
#'   \code{govhr::contract_rules} (\code{rule}, \code{name},
#'   \code{description}, \code{label}).  These rows are appended to the
#'   package-level rules before validation.  Use \code{NULL} (the default) to
#'   run only the built-in rules.
#'
#' @details
#' \describe{
#'   \item{\strong{Structure checks}}{Variable names checked against the
#'     harmonization dictionary for each module.}
#'   \item{\strong{Orphan checks}}{Cross-module referential integrity:
#'     personnel and establishment IDs in the Contract module are checked
#'     against their parent modules.}
#'   \item{\strong{Rule-based validation}}{\code{govhr::contract_rules} and
#'     \code{govhr::personnel_rules} (plus any \code{custom_rules}) are
#'     evaluated via \code{validate_data()}, covering uniqueness, date logic,
#'     salary consistency, working hours, age ranges, and more.}
#'   \item{\strong{Missingness profiling}}{Missingness by key grouping
#'     variables (contract type, occupation, reference date).  Groups are
#'     silently skipped if the column is absent from the data.}
#'   \item{\strong{Volatility analysis}}{Period-over-period percent change for
#'     salaries, contract counts, working hours, occupation diversity, and
#'     contract-type diversity, each by multiple groupings.  Groupings are
#'     silently skipped if the required columns are absent.}
#' }
#'
#' @return A named list:
#' \describe{
#'   \item{\code{n_obs}}{Row count of the Contract module.}
#'   \item{\code{n_vars}}{Column count of the Contract module.}
#'   \item{\code{structure}}{Dictionary-comparison results for each module.}
#'   \item{\code{orphans}}{Orphan ID diagnostics.}
#'   \item{\code{validation}}{Named list: \code{contract} and \code{personnel}
#'     audit reports from \code{validate_data()}.}
#'   \item{\code{missingness}}{Long-format data.table of missingness by group.}
#'   \item{\code{volatility}}{Named list: \code{contract} and \code{personnel}
#'     flat data.tables from \code{flatten_volatility()}.}
#' }
#'
#' @importFrom data.table as.data.table rbindlist melt setnames :=
#'
#' @examples
#' \dontrun{
#' qc <- compute_qualitycontrol(
#'   contract_dt  = bra_hrmis_contract,
#'   personnel_dt = bra_hrmis_personnel,
#'   est_dt       = bra_hrmis_est
#' )
#' qc$validation$contract
#' qc$volatility$contract
#' }
#'
#' @export
compute_qualitycontrol <- function(contract_dt,
                                   personnel_dt,
                                   est_dt,
                                   custom_rules = list(contract  = NULL,
                                                       personnel = NULL)) {

  # Ensure all modules are data.tables
  contract_dt <- as.data.table(contract_dt)
  personnel_dt <- as.data.table(personnel_dt)
  est_dt <- as.data.table(est_dt)

  # Structure and dictionary checks

  dict_list <- split(
    govhr::dictionary,
    govhr::dictionary$module
  )
  

  structure_checks <-
    mapply(FUN = function(data,
                          dict_names){
      
      
      
      structure_checks <- compare_to_dictionary(data = data,
                                                dict_names = dict_names$variable_id,
                                                output_format = "badges")

      return(structure_checks)

    }, data = list(contract_dt, est_dt, personnel_dt),
       dict_names = dict_list,
       SIMPLIFY = FALSE)



  # -----------------------------------
  # 2. ORPHAN CHECKS (cross-module referential integrity)
  # -----------------------------------
  orphan_checks <- list()

  orphan_checks$personnel_vs_contract <- check_orphan_id(
    parent_dt = personnel_dt,
    child_dt  = contract_dt,
    parent_id = "personnel_id",
    child_id  = "personnel_id"
  )

  orphan_checks$establishment_vs_contract <- check_orphan_id(
    parent_dt = est_dt,
    child_dt  = contract_dt,
    parent_id = "est_id",
    child_id  = "est_id"
  )

  # -----------------------------------
  # 3. RULE-BASED VALIDATION
  # -----------------------------------
  ## Merge package-level rules with any country-specific additions
  contract_rules_merged <- if (!is.null(custom_rules$contract)) {
    rbind(govhr::contract_rules, custom_rules$contract)
  } else {
    govhr::contract_rules
  }

  personnel_rules_merged <- if (!is.null(custom_rules$personnel)) {
    rbind(govhr::personnel_rules, custom_rules$personnel)
  } else {
    govhr::personnel_rules
  }

  validate_obj <- list(
    contract  = validate_data(contract_dt,  input_rules = contract_rules_merged,  output_format = "report"),
    personnel = validate_data(personnel_dt, input_rules = personnel_rules_merged, output_format = "report")
  )

  # -----------------------------------
  # 4. MISSINGNESS
  # Skip grouping columns that are absent from the data (Shiny-safe)
  # -----------------------------------
  miss_candidates <- c("contract_type_code", "contract_type_native",
                       "occupation_isconame", "occupation_native")
  cols <- intersect(miss_candidates, names(contract_dt))

  if (length(cols) > 0) {
    missingness <-
      rbindlist(lapply(cols, \(group_col) {
        num_cols <- names(contract_dt)[vapply(contract_dt, is.numeric, logical(1))]
        mv <- setdiff(num_cols, group_col)
        melt(
          contract_dt,
          id.vars       = group_col,
          measure.vars  = mv,
          variable.name = "target_var",
          value.name    = "val",
          variable.factor = FALSE
        )[
          , .(n_missing = sum(is.na(val)), N = .N, pct_missing = mean(is.na(val))),
          by = c(group_col, "target_var")
        ][, group_var := group_col
        ][, setnames(.SD, group_col, "group_val")
        ][, group_val := as.character(group_val)]
      }))
  } else {
    missingness <- data.table::data.table()
  }

  
  # -----------------------------------
  # 5. VOLATILITY
  # Groups whose column is absent are silently dropped (Shiny-safe)
  # -----------------------------------
  .has <- function(cols_needed) all(cols_needed %in% names(contract_dt))
  .filter_groups <- function(grp_list, data) {
    Filter(\(g) all(g %in% names(data)), grp_list)
  }

  gaps <- length(unique(contract_dt$ref_date))
  window_size <- max(2, floor(gaps / 2))

  ## contract level
  whours_groups <- .filter_groups(list(
    by_contract     = "contract_id",
    by_paygrade     = "paygrade",
    by_seniority    = "seniority",
    by_occ_native   = "occupation_native",
    by_occ_isconame = "occupation_isconame",
    by_occ_iscocode = "occupation_iscocode",
    by_ctype_native = "contract_type_native",
    by_ctype_code   = "contract_type_code"
  ), contract_dt)

  ## groups over which to count unique occupations
  occ_count_groups <- .filter_groups(list(
    by_est        = "est_id",
    by_ctype_code = "contract_type_code"
  ), contract_dt)

  ## groups over which to count unique contract types
  ctype_count_groups <- .filter_groups(list(
    by_est       = "est_id",
    by_paygrade  = "paygrade",
    by_seniority = "seniority"
  ), contract_dt)

  salary_cols <- intersect(
    c("gross_salary_lcu", "base_salary_lcu", "net_salary_lcu", "allowance_lcu"),
    names(contract_dt)
  )

  contract_volatility <- list(

    ## --- salary volatility by contract ---
    salary_vol = if (length(salary_cols) > 0 && .has("contract_id")) {
      compute_volatility(
        data = contract_dt, col = salary_cols,
        agg_fn = "sum", vol_fn = "pct_change",
        time = "ref_date", groups = "contract_id", window_size = NULL
      )
    } else NULL,

    ## --- contract count volatility by establishment ---
    ctrcount_vol = if (.has(c("contract_id", "est_id"))) {
      compute_volatility(
        data = contract_dt,
        col  = "contract_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = "est_id", window_size = NULL
      )
    } else NULL,

    ## --- hours worked volatility by various groups ---
    workhours_vol = if (.has("whours")) lapply(whours_groups, \(grp) {
      compute_volatility(
        data = contract_dt, col = "whours",
        agg_fn = "sum", vol_fn = "pct_change",
        time = "ref_date", groups = grp, window_size = NULL
      )
    }) else NULL,

    ## --- occupation diversity (count of unique occupations) by group ---
    occ_diversity_vol = lapply(occ_count_groups, \(grp) {
      occ_cols_present <- Filter(
        \(x) x %in% names(contract_dt),
        c(occ_native   = "occupation_native",
          occ_isconame = "occupation_isconame",
          occ_iscocode = "occupation_iscocode")
      )
      lapply(
        occ_cols_present,
        \(occ_col) {
          compute_volatility(
            data = contract_dt, col = occ_col,
            agg_fn = "count_unique", vol_fn = "pct_change",
            time = "ref_date", groups = grp, window_size = NULL
          )
        }
      )
    }),

    ## --- contract type diversity (count of unique types) by group ---
    ctype_diversity_vol = lapply(ctype_count_groups, \(grp) {
      ctype_cols_present <- Filter(
        \(x) x %in% names(contract_dt),
        c(ctype_native = "contract_type_native",
          ctype_code   = "contract_type_code")
      )
      lapply(
        ctype_cols_present,
        \(ct_col) {
          compute_volatility(
            data = contract_dt, col = ct_col,
            agg_fn = "count_unique", vol_fn = "pct_change",
            time = "ref_date", groups = grp, window_size = NULL
          )
        }
      )
    })
  )

  ## --- personnel volatility ---
  ## Bring est_id from contract_dt into personnel_dt via (personnel_id, ref_date)
  .has_p <- function(cols_needed) all(cols_needed %in% names(personnel_dt))

  if (.has(c("personnel_id", "ref_date", "est_id"))) {
    contract_keys <- unique(contract_dt[, .(personnel_id, ref_date, est_id)])
    data.table::setkeyv(contract_keys, c("personnel_id", "ref_date"))
    data.table::setkeyv(personnel_dt,  c("personnel_id", "ref_date"))
    personnel_contract_dt <- contract_keys[personnel_dt]
  } else {
    personnel_contract_dt <- data.table::copy(personnel_dt)
  }

  personnel_volatility <- list(

    ## headcount (unique personnel) by establishment
    headcount_vol = if ("est_id" %in% names(personnel_contract_dt)) {
      compute_volatility(
        data = personnel_contract_dt,
        col  = "personnel_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = "est_id", window_size = NULL
      )
    } else NULL,

    ## headcount by gender (compositional drift over time)
    headcount_by_gender = if (.has_p("gender")) {
      compute_volatility(
        data = personnel_contract_dt,
        col  = "personnel_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = "gender", window_size = NULL
      )
    } else NULL,

    ## headcount by education level (compositional drift over time)
    headcount_by_educat = if (.has_p("educat7")) {
      compute_volatility(
        data = personnel_contract_dt,
        col  = "personnel_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = "educat7", window_size = NULL
      )
    } else NULL,

    ## gender composition within each establishment over time
    gender_by_est = if ("est_id" %in% names(personnel_contract_dt) && .has_p("gender")) {
      compute_volatility(
        data = personnel_contract_dt,
        col  = "personnel_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = c("est_id", "gender"), window_size = NULL
      )
    } else NULL,

    ## education composition within each establishment over time
    educat_by_est = if ("est_id" %in% names(personnel_contract_dt) && .has_p("educat7")) {
      compute_volatility(
        data = personnel_contract_dt,
        col  = "personnel_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = c("est_id", "educat7"), window_size = NULL
      )
    } else NULL
  )

  contract_volatility  <- flatten_volatility(Filter(Negate(is.null), contract_volatility))
  personnel_volatility <- flatten_volatility(Filter(Negate(is.null), personnel_volatility))

  # -----------------------------------
  # 6. ASSEMBLE QC OBJECT
  # -----------------------------------
  qc_object <- list(
    n_obs      = nrow(contract_dt),
    n_vars     = ncol(contract_dt),
    structure  = structure_checks,
    orphans    = orphan_checks,
    validation = validate_obj,
    missingness = missingness,
    volatility = list(
      contract  = contract_volatility,
      personnel = personnel_volatility
    )
  )

  return(qc_object)
}


