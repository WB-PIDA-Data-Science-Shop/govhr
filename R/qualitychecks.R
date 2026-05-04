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
#'   \item{\code{missingness}}{Long-format data.table of missingness by group,
#'     with columns \code{group_var}, \code{group_label}, \code{group_val},
#'     \code{target_var}, \code{target_label}, \code{n_missing}, \code{N},
#'     and \code{pct_missing}.}
#'   \item{\code{volatility}}{Named list: \code{contract} and \code{personnel}
#'     flat data.tables from \code{flatten_volatility()}.}
#'   \item{\code{temporal_coverage}}{Named list: \code{contract},
#'     \code{personnel} (if supplied), and \code{establishment} (if supplied),
#'     each a data.table with columns \code{ref_date} and \code{n_obs} showing
#'     the observation count per snapshot.}
#'   \item{\code{metadata}}{Named list with \code{date_range} (min/max
#'     ref_date across all modules), \code{n_obs} (row counts per module),
#'     and \code{n_vars} (column counts per module).}
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
  contract_dt  <- as.data.table(contract_dt)
  personnel_dt <- as.data.table(personnel_dt)
  est_dt       <- as.data.table(est_dt)

  ## Hoist dictionary once — reused by structure checks, missingness labels, etc.
  dict_dt <- unique(data.table::as.data.table(govhr::dictionary)[
    , .(variable_id, variable_name, module)
  ])

  ## Unified column-presence helper (replaces .has() and .has_p() closures)
  has_cols <- function(data, cols) all(cols %in% names(data))

  # -----------------------------------
  # 1. STRUCTURE CHECKS
  # -----------------------------------
  module_data <- list(
    contract      = contract_dt,
    establishment = est_dt,
    personnel     = personnel_dt
  )
  structure_checks <- lapply(names(module_data), function(m) {
    compare_to_dictionary(
      data         = module_data[[m]],
      dict_names   = dict_dt[module == m, variable_id],
      output_format = "badges"
    )
  })



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
  # Delegate to wrap_compute_missingness() for each module, then join labels.
  # -----------------------------------

  contract_grps <- c("est_id", "ref_date", "adm1_name", "paygrade", "seniority", 
                     "occupation_native", "occupation_english", "occupation_isconame",
                     "contract_type_native", "contract_type_code")
  personnel_grps <- c("ref_date", "gender", "educat7", "tribe", "race", "status")




  miss_list <- list(
    compute_missingness(contract_dt,  
                        module = "contract",
                        group_cols = contract_grps),
    compute_missingness(personnel_dt, 
                        module = "personnel",
                        group_cols = personnel_grps)
  )
  miss_list <- Filter(function(x) nrow(x) > 0, miss_list)

  if (length(miss_list) > 0) {
    missingness <- data.table::rbindlist(miss_list, fill = TRUE)

    ## join dictionary labels for group_var and target_var (reuse hoisted dict_dt)
    grp_lookup <- data.table::setnames(
      unique(dict_dt[, .(variable_id, variable_name)]), c("group_var",  "group_label")
    )
    tgt_lookup <- data.table::setnames(
      unique(dict_dt[, .(variable_id, variable_name)]), c("target_var", "target_label")
    )

    missingness <- grp_lookup[missingness, on = "group_var"]
    missingness <- tgt_lookup[missingness, on = "target_var"]

    keep_cols <- c("module", "group_var", "group_label", "group_val",
                   "target_var", "target_label", "n_missing", "N", "pct_missing")
    data.table::setcolorder(missingness, intersect(keep_cols, names(missingness)))

  } else {
    missingness <- data.table::data.table()
  }

  
  # -----------------------------------
  # 5. VOLATILITY
  # Groups whose column is absent are silently dropped (Shiny-safe)
  # -----------------------------------
  .filter_groups <- function(grp_list, data) {
    Filter(\(g) all(g %in% names(data)), grp_list)
  }

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

  ## hoist column lookups out of nested lapply iterations
  occ_cols_present <- Filter(
    \(x) x %in% names(contract_dt),
    c(occ_native   = "occupation_native",
      occ_isconame = "occupation_isconame",
      occ_iscocode = "occupation_iscocode")
  )
  ctype_cols_present <- Filter(
    \(x) x %in% names(contract_dt),
    c(ctype_native = "contract_type_native",
      ctype_code   = "contract_type_code")
  )

  contract_volatility <- list(

    ## --- salary volatility by contract ---
    salary_vol = if (length(salary_cols) > 0 && has_cols(contract_dt, "contract_id")) {
      compute_volatility(
        data = contract_dt, col = salary_cols,
        agg_fn = "sum", vol_fn = "pct_change",
        time = "ref_date", groups = "contract_id", window_size = NULL
      )
    } else NULL,

    ## --- contract count volatility by establishment ---
    ctrcount_vol = if (has_cols(contract_dt, c("contract_id", "est_id"))) {
      compute_volatility(
        data = contract_dt,
        col  = "contract_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = "est_id", window_size = NULL
      )
    } else NULL,

    ## --- hours worked volatility by various groups ---
    workhours_vol = if (has_cols(contract_dt, "whours")) lapply(whours_groups, \(grp) {
      compute_volatility(
        data = contract_dt, col = "whours",
        agg_fn = "sum", vol_fn = "pct_change",
        time = "ref_date", groups = grp, window_size = NULL
      )
    }) else NULL,

    ## --- occupation diversity (count of unique occupations) by group ---
    occ_diversity_vol = lapply(occ_count_groups, \(grp) {
      lapply(occ_cols_present, \(occ_col) {
        compute_volatility(
          data = contract_dt, col = occ_col,
          agg_fn = "count_unique", vol_fn = "pct_change",
          time = "ref_date", groups = grp, window_size = NULL
        )
      })
    }),

    ## --- contract type diversity (count of unique types) by group ---
    ctype_diversity_vol = lapply(ctype_count_groups, \(grp) {
      lapply(ctype_cols_present, \(ct_col) {
        compute_volatility(
          data = contract_dt, col = ct_col,
          agg_fn = "count_unique", vol_fn = "pct_change",
          time = "ref_date", groups = grp, window_size = NULL
        )
      })
    })
  )

  ## --- personnel volatility ---
  ## Bring est_id from contract_dt into personnel_dt via (personnel_id, ref_date)
  ## Use merge() to avoid mutating personnel_dt in place via setkeyv
  if (has_cols(contract_dt, c("personnel_id", "ref_date", "est_id"))) {
    contract_keys <- unique(contract_dt[, .(personnel_id, ref_date, est_id)])
    personnel_contract_dt <- merge(
      personnel_dt, contract_keys,
      by = c("personnel_id", "ref_date"), all.x = TRUE
    )
  } else {
    personnel_contract_dt <- data.table::copy(personnel_dt)
  }

  personnel_volatility <- list(

    ## headcount (unique personnel) by establishment
    headcount_vol = if (has_cols(personnel_contract_dt, "est_id")) {
      compute_volatility(
        data = personnel_contract_dt,
        col  = "personnel_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = "est_id", window_size = NULL
      )
    } else NULL,

    ## headcount by gender (compositional drift over time)
    headcount_by_gender = if (has_cols(personnel_dt, "gender")) {
      compute_volatility(
        data = personnel_contract_dt,
        col  = "personnel_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = "gender", window_size = NULL
      )
    } else NULL,

    ## headcount by education level (compositional drift over time)
    headcount_by_educat = if (has_cols(personnel_dt, "educat7")) {
      compute_volatility(
        data = personnel_contract_dt,
        col  = "personnel_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = "educat7", window_size = NULL
      )
    } else NULL,

    ## gender composition within each establishment over time
    gender_by_est = if (has_cols(personnel_contract_dt, "est_id") && has_cols(personnel_dt, "gender")) {
      compute_volatility(
        data = personnel_contract_dt,
        col  = "personnel_id", agg_fn = "count_unique", vol_fn = "pct_change",
        time = "ref_date", groups = c("est_id", "gender"), window_size = NULL
      )
    } else NULL,

    ## education composition within each establishment over time
    educat_by_est = if (has_cols(personnel_contract_dt, "est_id") && has_cols(personnel_dt, "educat7")) {
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
  # 6. TEMPORAL COVERAGE
  # Row counts per ref_date snapshot for each module
  # -----------------------------------
  temporal_coverage <- list()

  if (has_cols(contract_dt, "ref_date")) {
    temporal_coverage$contract <- contract_dt[, .(n_obs = .N), by = ref_date][order(ref_date)]
  }
  if (has_cols(personnel_dt, "ref_date")) {
    temporal_coverage$personnel <- personnel_dt[, .(n_obs = .N), by = ref_date][order(ref_date)]
  }
  if (has_cols(est_dt, "ref_date")) {
    temporal_coverage$establishment <- est_dt[, .(n_obs = .N), by = ref_date][order(ref_date)]
  }

  # -----------------------------------
  # 7. METADATA
  # Lightweight summary: date range, row counts, column counts per module
  # -----------------------------------
  ## compute range per module then take the overall range — avoids copying full vectors
  date_ranges <- Filter(Negate(is.null), list(
    if (has_cols(contract_dt,  "ref_date")) range(contract_dt$ref_date,  na.rm = TRUE),
    if (has_cols(personnel_dt, "ref_date")) range(personnel_dt$ref_date, na.rm = TRUE),
    if (has_cols(est_dt,       "ref_date")) range(est_dt$ref_date,       na.rm = TRUE)
  ))

  metadata <- list(
    date_range = if (length(date_ranges) > 0) range(do.call(c, date_ranges), na.rm = TRUE) else as.Date(NA),

    n_obs = list(
      contract      = nrow(contract_dt),
      personnel     = nrow(personnel_dt),
      establishment = nrow(est_dt)
    ),
    n_vars = list(
      contract      = ncol(contract_dt),
      personnel     = ncol(personnel_dt),
      establishment = ncol(est_dt)
    )
  )

  # -----------------------------------
  # 8. ASSEMBLE QC OBJECT
  # -----------------------------------
  qc_object <- list(
    n_obs             = nrow(contract_dt),
    n_vars            = ncol(contract_dt),
    structure         = structure_checks,
    orphans           = orphan_checks,
    validation        = validate_obj,
    missingness       = missingness,
    volatility        = list(
      contract  = contract_volatility,
      personnel = personnel_volatility
    ),
    temporal_coverage = temporal_coverage,
    metadata          = metadata
  )

  return(qc_object)
}


