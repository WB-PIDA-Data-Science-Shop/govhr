#' Build a person-interval panel for survival (hazard) models
#'
#' @description
#' Turns HRMIS snapshots into the table a model of exits is fitted on: one
#' row per person and interval between two snapshots in which they could
#' leave, with how long they were at risk (`exposure`), whether and how they
#' left by the next snapshot (`exit_type`), and their pay and covariates at
#' the start of the interval.
#'
#' @param personnel Personnel snapshots: one row per person and `ref_date`,
#'   as a data frame or a lazy database table (`tbl_dbi`).
#' @param contracts Contract snapshots: one row per contract and `ref_date`,
#'   of the same kind as `personnel`.
#' @param tenure_col Character. The `personnel` column with years of service,
#'   e.g. from [compute_tenure_panel()]. It must count from hiring, not from
#'   the first snapshot.
#' @param salary_col Character. The `contracts` pay column, summed across a
#'   person's contracts. Deflate it first ([deflate_to_real()]) to compare
#'   years.
#' @param status_col Character or `NULL`. The `personnel` status column:
#'   `"active"` can leave, `"pensioner"` has retired. `NULL` (the default)
#'   treats everyone as active, so every exit is `"other"`.
#' @param covariate_cols Character vector or `NULL`. Columns to carry into
#'   the panel, from `personnel` (e.g. gender) or `contracts` (e.g.
#'   occupation, from the contract chosen by `select_contract`).
#' @param personnel_id_col,ref_date_col,contract_id_col Character. The
#'   person, snapshot date and contract id columns.
#' @param select_contract `"highest_paid"` (the default) or `"lowest_paid"`:
#'   which contract the contract covariates come from when a person has
#'   several. Ties go to the lowest contract id.
#' @param ... Not used.
#'
#' @returns A `survival_panel` for [fit_survival_model()]: a data.table (a
#'   lazy table for a `tbl_dbi`) with one row per person and interval:
#'   \describe{
#'     \item{personnel_id_col, ref_date_col}{The person and the start of the
#'       interval.}
#'     \item{next_date}{The next snapshot, where the interval ends.}
#'     \item{tenure_col}{Years of service at the start (`NA` kept).}
#'     \item{exposure}{Years at risk: the interval's length, or half of it
#'       for someone who left.}
#'     \item{exit_type}{At the next snapshot: `"none"` (still active),
#'       `"retired"` (a pensioner) or `"other"` (gone, or any other status).}
#'     \item{salary_col}{Total pay at the start; `NA` with no contract.}
#'     \item{covariate_cols}{As at the start of the interval.}
#'   }
#'   It remembers the column arguments, so [fit_survival_model()] needs none.
#'
#' @details
#' **Model.** A Poisson regression of exits with a `log(exposure)` offset on
#' this panel is a piecewise-constant proportional hazards model;
#' [fit_survival_model()] fits one per exit type (cause-specific hazards).
#'
#' **Risk set and censoring.** Everyone active at a snapshot that has a next
#' one; pensioners are not at risk. The last snapshot is right-censored: it
#' adds no rows, and someone still in service then never counts as a leaver.
#'
#' **Left truncation.** Someone in service when the panel starts enters at
#' the tenure first seen and adds nothing to earlier tenures, which is right
#' as long as `tenure_col` counts from hiring.
#'
#' **Exits and returns.** Absence at the next snapshot is an exit, counted as
#' half the interval at risk; someone who reappears is at risk again from
#' there.
#'
#' **Intervals.** An interval runs to the next snapshot in the data, so
#' monthly or irregular snapshots work: exposure is always in years (January
#' 2020 is 31/366), and a snapshot missing for everyone makes the interval
#' longer rather than counting as exits.
#'
#' **Duplicates.** A person seen twice at one snapshot is kept once (the
#' first by status), with a warning.
#'
#' @examples
#' library(data.table)
#' contracts <- as.data.table(bra_hrmis_contract)
#' personnel <- as.data.table(bra_hrmis_personnel)
#' contracts[, gross_salary_real := deflate_to_real(gross_salary_lcu, ref_date, "BRA")]
#' tenure <- compute_tenure_panel(contracts)
#' personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)
#'
#' panel <- build_survival_panel(
#'   personnel, contracts,
#'   tenure_col = "tenure_years", salary_col = "gross_salary_real",
#'   status_col = "employment_status", covariate_cols = "gender"
#' )
#' panel[, .N, by = exit_type]
#'
#' @seealso [fit_survival_model()] to model the exits; [compute_career_table()]
#'   for stay rates and pay growth by tenure without covariates.
#' @export
build_survival_panel <- function(personnel, ...) {
  UseMethod("build_survival_panel")
}

#' @rdname build_survival_panel
#' @importFrom data.table := as.data.table fcase fifelse setnames setorderv shift
#' @export
build_survival_panel.data.frame <- function(personnel,
                                            contracts,
                                            tenure_col,
                                            salary_col,
                                            status_col = NULL,
                                            covariate_cols = NULL,
                                            personnel_id_col = "personnel_id",
                                            ref_date_col = "ref_date",
                                            contract_id_col = "contract_id",
                                            select_contract = c("highest_paid", "lowest_paid"),
                                            ...) {
  rlang::check_dots_empty()
  select_contract <- match.arg(select_contract)
  .check_survival_args(
    personnel, contracts, tenure_col, salary_col, status_col, covariate_cols,
    personnel_id_col, ref_date_col, contract_id_col
  )

  ### each covariate comes from the table that has it: a person's own
  ### columns (e.g. gender) or their contract's (e.g. occupation)
  person_covariates <- intersect(covariate_cols, colnames(personnel))
  contract_covariates <- intersect(covariate_cols, colnames(contracts))
  person_year <- c(personnel_id_col, ref_date_col)

  ### one row per person and snapshot: total pay across their contracts,
  ### and the contract covariates of the selected contract
  pay_dt <- .pay_by_person_snapshot(
    contracts, person_year, contract_id_col, salary_col,
    contract_covariates, select_contract
  )
  setnames(pay_dt, ".pay", salary_col)

  ### join pay and contract covariates onto every personnel record
  panel <- pay_dt[as.data.table(personnel)[,
    c(person_year, status_col, tenure_col, person_covariates),
    with = FALSE
  ], on = person_year]
  setnames(panel, person_year, c(".pid", ".ref"))

  ### without a status column, everyone on the payroll is active
  if (is.null(status_col)) {
    panel[, .status := "active"]
  } else {
    setnames(panel, status_col, ".status")
  }

  ### one row per person and snapshot, keeping the first by status (as the
  ### database method does)
  setorderv(panel, c(".pid", ".ref", ".status"))
  n_dup <- sum(duplicated(panel, by = c(".pid", ".ref")))
  if (n_dup > 0L) {
    .warn_survival_duplicates(n_dup, personnel_id_col, ref_date_col)
    panel <- unique(panel, by = c(".pid", ".ref"))
  }

  ### each person's own next record is the row below once sorted
  panel[, `:=`(
    .next_pid = shift(.pid, type = "lead"),
    .next_seen = shift(.ref, type = "lead"),
    .next_status = shift(.status, type = "lead")
  )]

  ### at risk: active at a snapshot that has a next one. joining the
  ### calendar drops the last snapshot, which is censored
  calendar <- as.data.table(.survival_calendar(sort(unique(panel$.ref))))
  panel <- calendar[panel[.status == "active"], on = ".ref", nomatch = NULL]

  ### what happened by the next snapshot: still active, retired, or gone
  panel[, .present := .next_pid == .pid & .next_seen == next_date]
  panel[, exit_type := fcase(
    .present & .next_status == "active", "none",
    .present & .next_status == "pensioner", "retired",
    default = "other"
  )]

  ### years at risk: the interval, or half of it for a leaver, who left at
  ### some point between the two snapshots
  panel[, exposure := fifelse(exit_type == "none", .interval, .interval / 2)]

  setnames(panel, c(".pid", ".ref"), person_year)
  panel <- panel[, c(
    person_year, "next_date", tenure_col, "exposure", "exit_type",
    salary_col, covariate_cols
  ), with = FALSE]

  .new_survival_panel(
    panel, tenure_col, salary_col, covariate_cols, personnel_id_col, ref_date_col
  )
}

#' @rdname build_survival_panel
#' @importFrom dplyr all_of case_when count distinct filter group_by if_else
#'   inner_join lead left_join mutate pull rename row_number select summarise
#'   ungroup
#' @importFrom rlang .data !!
#' @export
build_survival_panel.tbl_dbi <- function(personnel,
                                         contracts,
                                         tenure_col,
                                         salary_col,
                                         status_col = NULL,
                                         covariate_cols = NULL,
                                         personnel_id_col = "personnel_id",
                                         ref_date_col = "ref_date",
                                         contract_id_col = "contract_id",
                                         select_contract = c("highest_paid", "lowest_paid"),
                                         ...) {
  rlang::check_dots_empty()
  select_contract <- match.arg(select_contract)
  .check_survival_args(
    personnel, contracts, tenure_col, salary_col, status_col, covariate_cols,
    personnel_id_col, ref_date_col, contract_id_col
  )

  ### the same steps as the data.frame method, written as dplyr verbs that
  ### dbplyr turns into SQL -- the panel itself never leaves the database
  person_covariates <- intersect(covariate_cols, colnames(personnel))
  contract_covariates <- intersect(covariate_cols, colnames(contracts))
  contracts <- rename(contracts, all_of(c(.pid = personnel_id_col, .ref = ref_date_col)))

  ### total pay per person and snapshot (SUM skips missing pay, and is
  ### missing only if all of it is)
  pay <- contracts |>
    group_by(.pid, .ref) |>
    summarise(!!salary_col := sum(.data[[salary_col]], na.rm = TRUE), .groups = "drop")

  ### contract covariates from the highest (or lowest) paid contract: missing
  ### pay last, ties to the lowest contract id, as .choose_contract()
  if (length(contract_covariates) > 0L) {
    pay_sign <- if (select_contract == "highest_paid") -1 else 1
    chosen <- contracts |>
      mutate(
        .pay_missing = is.na(.data[[salary_col]]),
        .pay_order = !!pay_sign * .data[[salary_col]],
        .cid = .data[[contract_id_col]]
      ) |>
      group_by(.pid, .ref) |>
      dbplyr::window_order(.pay_missing, .pay_order, .cid) |>
      filter(row_number() == 1L) |>
      ungroup() |>
      select(all_of(c(".pid", ".ref", contract_covariates)))
    pay <- left_join(pay, chosen, by = c(".pid", ".ref"))
  }

  panel <- personnel |>
    select(all_of(c(
      .pid = personnel_id_col, .ref = ref_date_col, .status = status_col,
      tenure_col, person_covariates
    )))
  if (is.null(status_col)) {
    panel <- mutate(panel, .status = "active")
  }

  ### one row per person and snapshot, keeping the first by status
  n_dup <- panel |>
    count(.pid, .ref, name = ".n") |>
    filter(.n > 1L) |>
    summarise(.n_dup = sum(.n - 1L, na.rm = TRUE)) |>
    pull(.n_dup)
  if (isTRUE(n_dup > 0)) {
    .warn_survival_duplicates(n_dup, personnel_id_col, ref_date_col)
    panel <- panel |>
      group_by(.pid, .ref) |>
      dbplyr::window_order(.status) |>
      filter(row_number() == 1L) |>
      ungroup()
  }

  ### the calendar is built in R and sent in inline (no write access
  ### needed), so both methods measure intervals the same way
  all_dates <- sort(pull(distinct(panel, .ref), .ref))
  calendar <- dbplyr::copy_inline(
    dbplyr::remote_con(personnel), .survival_calendar(all_dates)
  )

  ### each person's next record with a LEAD() window ordered by snapshot;
  ### joining the calendar drops the last snapshot, which is censored
  panel <- panel |>
    left_join(pay, by = c(".pid", ".ref")) |>
    group_by(.pid) |>
    dbplyr::window_order(.ref) |>
    mutate(.next_seen = lead(.ref), .next_status = lead(.status)) |>
    ungroup() |>
    filter(.status == "active") |>
    inner_join(calendar, by = ".ref") |>
    mutate(
      exit_type = case_when(
        .next_seen == next_date & .next_status == "active" ~ "none",
        .next_seen == next_date & .next_status == "pensioner" ~ "retired",
        TRUE ~ "other"
      ),
      exposure = if_else(exit_type == "none", .interval, .interval / 2)
    ) |>
    rename(all_of(stats::setNames(c(".pid", ".ref"), c(personnel_id_col, ref_date_col)))) |>
    select(all_of(c(
      personnel_id_col, ref_date_col, "next_date", tenure_col, "exposure",
      "exit_type", salary_col, covariate_cols
    )))

  .new_survival_panel(
    panel, tenure_col, salary_col, covariate_cols, personnel_id_col, ref_date_col
  )
}

#' @rdname build_survival_panel
#' @export
build_survival_panel.default <- function(personnel, ...) {
  stop_unsupported_data(personnel, "personnel")
}

#' Fit a survival (hazard) model of leaving the service
#'
#' @description
#' Estimates how covariates such as gender or occupation change the chance of
#' leaving the service in a given year, for people of the same tenure in the
#' same year, separately for retiring and for leaving otherwise.
#'
#' The effects are hazard ratios (see [tidy.survival_model()]): `0.8` for
#' women means a woman is 20% less likely to leave in a given year than a
#' comparable man.
#'
#' @param panel A `survival_panel` from [build_survival_panel()], in memory
#'   or in a database.
#' @param covariate_cols Character vector. The covariates to model. Defaults
#'   to those the panel was built with; `character(0)` for tenure (and year)
#'   effects only. Character columns become categories, numeric ones enter
#'   linearly.
#' @param exit_types Any of `"retired"` and `"other"` (both by default). An
#'   exit type no one had is left out, with a warning.
#' @param band_width Number. The width in years of the tenure bands within
#'   which the chance of leaving is taken as constant. Default `1`.
#' @param period_effects Logical. If `TRUE` (the default), each calendar year
#'   gets its own level of exits, absorbing shocks that hit everyone in a
#'   year.
#' @param make_tidy_output Logical. If `TRUE`, return the hazard ratio table
#'   from [tidy.survival_model()] instead of the model. Default `FALSE`.
#' @param ... Passed to [fixest::fepois()], e.g. `nthreads`. Not `fml`,
#'   `data`, `offset`, `vcov`, `ssc`, `weights` or `cluster` (see Details).
#'
#' @returns A `survival_model`, for [tidy.survival_model()] and
#'   [predict.survival_model()]; fixest's own functions (`summary()`,
#'   `coef()`, `fixest::fixef()`, `fixest::etable()`) work on it too. With
#'   `make_tidy_output = TRUE`, the hazard ratio table instead.
#'
#' @details
#' **Model.** A piecewise-constant proportional hazards model, fitted as a
#' Poisson regression of exits ([fixest::fepois()]) with a `log(exposure)`
#' offset and fixed effects for tenure band (the baseline hazard) and, with
#' `period_effects`, calendar year. One model per exit type gives
#' cause-specific hazards. The result is fixest's output (a `fixest_multi`,
#' or a `fixest` for one exit type) with class `survival_model` added.
#'
#' **Groups, not people.** The panel is first added up into groups of people
#' with the same tenure band, snapshot date and covariate values (in the
#' database, for a database panel). Exit counts and years at risk are
#' sufficient statistics for a Poisson model, so the estimates and standard
#' errors equal those on the person-level panel; fixest's number of
#' observations is the number of groups.
#'
#' **Standard errors** are the model's own (`vcov = "iid"`), with no
#' small-sample adjustment, which would depend on the number of groups. As
#' `fml`, `data`, `offset`, `vcov` and `ssc` are set here, and `weights` or
#' `cluster` would be wrong on grouped data, `...` cannot pass them.
#'
#' **Tenure and year.** Within a person, tenure and year rise together, so
#' with both sets of fixed effects the hire cohort is implied: the model
#' assumes the shape of the hazard over tenure is the same for every cohort.
#'
#' @examples
#' library(data.table)
#' contracts <- as.data.table(bra_hrmis_contract)
#' personnel <- as.data.table(bra_hrmis_personnel)
#' tenure <- compute_tenure_panel(contracts)
#' personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)
#'
#' panel <- build_survival_panel(
#'   personnel, contracts,
#'   tenure_col = "tenure_years", salary_col = "gross_salary_lcu",
#'   status_col = "employment_status", covariate_cols = "gender"
#' )
#' fit <- fit_survival_model(panel, band_width = 5)
#' summary(fit)
#'
#' # hazard ratios
#' broom::tidy(fit)
#'
#' @seealso [build_survival_panel()] for the panel, [tidy.survival_model()]
#'   for the hazard ratios, [predict.survival_model()] for predictions.
#' @export
fit_survival_model <- function(panel, ...) {
  UseMethod("fit_survival_model")
}

#' @rdname fit_survival_model
#' @export
fit_survival_model.data.frame <- function(panel,
                                          covariate_cols = attr(panel, "covariate_cols"),
                                          exit_types = c("retired", "other"),
                                          band_width = 1,
                                          period_effects = TRUE,
                                          make_tidy_output = FALSE,
                                          ...) {
  exit_types <- match.arg(exit_types, several.ok = TRUE)
  .check_survival_model_args(panel, covariate_cols, band_width, ...names())
  tenure_col <- attr(panel, "tenure_col")
  ref_date_col <- attr(panel, "ref_date_col")

  ### sum to cells of tenure band, snapshot and covariates
  cells <- as.data.table(panel)[,
    c(ref_date_col, tenure_col, "exit_type", "exposure", covariate_cols),
    with = FALSE
  ]
  setnames(cells, ref_date_col, ".ref")
  cells[, .band := floor(get(tenure_col) / band_width) * band_width]
  cells <- cells[,
    .(
      exit_retired = sum(exit_type == "retired"),
      exit_other = sum(exit_type == "other"),
      exposure = sum(exposure)
    ),
    by = c(".band", ".ref", covariate_cols)
  ]

  ### fit the model on the cells, which is the same as on the person-intervals
  .fit_survival_cells(
    cells, panel, covariate_cols, exit_types, band_width, period_effects,
    make_tidy_output, ...
  )
}

#' @rdname fit_survival_model
#' @export
fit_survival_model.tbl_dbi <- function(panel,
                                       covariate_cols = attr(panel, "covariate_cols"),
                                       exit_types = c("retired", "other"),
                                       band_width = 1,
                                       period_effects = TRUE,
                                       make_tidy_output = FALSE,
                                       ...) {
  exit_types <- match.arg(exit_types, several.ok = TRUE)
  .check_survival_model_args(panel, covariate_cols, band_width, ...names())
  tenure_col <- attr(panel, "tenure_col")
  ref_date_col <- attr(panel, "ref_date_col")

  ### sum to cells in the database and bring back only the cells
  cells <- panel |>
    rename(all_of(c(.ref = ref_date_col))) |>
    mutate(.band = floor(.data[[tenure_col]] / !!band_width) * !!band_width) |>
    group_by(across(all_of(c(".band", ".ref", covariate_cols)))) |>
    summarise(
      exit_retired = sum(if_else(exit_type == "retired", 1, 0), na.rm = TRUE),
      exit_other = sum(if_else(exit_type == "other", 1, 0), na.rm = TRUE),
      exposure = sum(exposure, na.rm = TRUE),
      .groups = "drop"
    ) |>
    collect()

  ### fit the model on the cells, which is the same as on the person-intervals
  .fit_survival_cells(
    as.data.table(cells), panel, covariate_cols, exit_types, band_width,
    period_effects, make_tidy_output, ...
  )
}

#' @rdname fit_survival_model
#' @export
fit_survival_model.default <- function(panel, ...) {
  stop_unsupported_data(panel, "panel")
}

#' Tidy a survival model into a table of hazard ratios
#'
#' @description
#' One row per exit type and covariate, with its hazard ratio, test and
#' confidence interval. Call it as `broom::tidy(fit)`.
#'
#' @param x A `survival_model` from [fit_survival_model()].
#' @param conf.level Number. The confidence level. Default `0.95`.
#' @param ... Not used.
#'
#' @returns A tibble with one row per exit type and term, and none if the
#'   model has no covariates:
#'   \describe{
#'     \item{exit_type}{`"retired"` or `"other"`.}
#'     \item{term}{The covariate as fixest names it: a category's column and
#'       level (e.g. `genderM`), or a numeric column's name.}
#'     \item{estimate}{The hazard ratio: e.g. `0.8` is a 20% lower chance of
#'       leaving in a given year than the reference category (or per unit of
#'       a numeric covariate).}
#'     \item{std.error, statistic, p.value}{On the log scale (see Details).}
#'     \item{conf.low, conf.high}{The confidence interval of the hazard
#'       ratio.}
#'   }
#'
#' @details
#' `estimate`, `conf.low` and `conf.high` are `exp()` of the coefficient and
#' its Wald interval; `std.error`, `statistic` (z) and `p.value` are for the
#' log coefficient, as `broom::tidy()` gives them for `survival::coxph()`.
#' The tenure band and year fixed effects (the baseline hazard) are left
#' out: see `fixest::fixef()`.
#'
#' @examples
#' library(data.table)
#' contracts <- as.data.table(bra_hrmis_contract)
#' personnel <- as.data.table(bra_hrmis_personnel)
#' tenure <- compute_tenure_panel(contracts)
#' personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)
#'
#' panel <- build_survival_panel(
#'   personnel, contracts,
#'   tenure_col = "tenure_years", salary_col = "gross_salary_lcu",
#'   status_col = "employment_status", covariate_cols = "gender"
#' )
#' fit <- fit_survival_model(panel, band_width = 5)
#' broom::tidy(fit)
#'
#' @seealso [fit_survival_model()] for the model.
#' @importFrom dplyr across all_of bind_rows mutate tibble
#' @export
tidy.survival_model <- function(x, conf.level = 0.95, ...) {
  rlang::check_dots_empty()
  models <- .survival_models(x)

  ### broom's own table for each exit type's model, which leaves out the
  ### fixed effects, tagged with the exit type
  rows <- lapply(names(models), function(type) {
    broom::tidy(models[[type]], conf.int = TRUE, conf.level = conf.level) |>
      mutate(exit_type = type, .before = 1L)
  })

  ### every column of the table, typed, so a model with no covariates (for
  ### which broom gives only conf.low and conf.high) still has all of them
  columns <- tibble(
    exit_type = character(), term = character(), estimate = numeric(),
    std.error = numeric(), statistic = numeric(), p.value = numeric(),
    conf.low = numeric(), conf.high = numeric()
  )

  ### hazard ratios. as.numeric() drops the vcov_type attribute broom leaves
  ### on the columns; std.error, statistic and p.value stay on the log scale
  bind_rows(columns, bind_rows(rows)) |>
    mutate(
      across(all_of(c("estimate", "conf.low", "conf.high")), function(col) exp(as.numeric(col))),
      across(all_of(c("std.error", "statistic", "p.value")), as.numeric)
    )
}

#' Predict exits from a survival model
#'
#' @description
#' * **Without `newdata`:** the groups the model was fitted on (one row per
#'   tenure band, snapshot date and covariate values), with the exits
#'   expected next to the exits seen, to check how well the model fits.
#' * **With `newdata`:** for each row, e.g. each person, the hazard of each
#'   exit type and the chance of retiring, leaving otherwise or staying
#'   within `horizon` years, e.g. for a simulation.
#'
#' @param object A `survival_model` from [fit_survival_model()].
#' @param newdata `NULL` (the default), or a data frame with the panel's
#'   tenure column, covariates and, if the model has year effects, snapshot
#'   date column. A `survival_panel` works; a database table is collected.
#' @param horizon Number. With `newdata`, the years ahead the chances are
#'   for, e.g. `1 / 12` for a month. Default `1`.
#' @param ... Not used.
#'
#' @returns A data.table.
#'
#'   **Without `newdata`:** the snapshot date, `tenure_band` (its lower
#'   bound), the covariates, `exposure` (years at risk) and, for each exit
#'   type modelled, `exit_<type>` (exits seen) and `pred_<type>` (exits
#'   expected).
#'
#'   **With `newdata`:** `newdata` plus `hazard_<type>` (exits per year at
#'   risk) for each exit type modelled and, if both were, `prob_retired`,
#'   `prob_other` and `prob_stay`, which add up to 1.
#'
#' @details
#' **Chances from hazards.** The hazard is constant within a tenure band, so
#' the chance of leaving within `horizon` is `1 - exp(-h * horizon)`, with
#' `h` the sum of the two hazards, split between the exit types in
#' proportion to their hazards. With one exit type not modelled, `h` is
#' unknown, so no chances are given.
#'
#' **Levels with no exits.** fixest drops a tenure band or year in which no
#' one left (its fixed effect is minus infinity) and predicts `NA` there. The
#' maximum likelihood estimate is 0 exits, so a band or year seen in the
#' data but dropped gives 0; one never seen, or a covariate level never seen,
#' gives `NA`.
#'
#' **No intervals.** fixest gives no standard errors for its fixed effects,
#' which carry most of a prediction, so none are given.
#'
#' @examples
#' library(data.table)
#' contracts <- as.data.table(bra_hrmis_contract)
#' personnel <- as.data.table(bra_hrmis_personnel)
#' tenure <- compute_tenure_panel(contracts)
#' personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)
#'
#' panel <- build_survival_panel(
#'   personnel, contracts,
#'   tenure_col = "tenure_years", salary_col = "gross_salary_lcu",
#'   status_col = "employment_status", covariate_cols = "gender"
#' )
#' fit <- fit_survival_model(panel, band_width = 5)
#'
#' # exits seen and expected in each group
#' predict(fit)
#'
#' # each person's chances of retiring, leaving otherwise or staying over the
#' # next month
#' predict(fit, newdata = panel, horizon = 1 / 12)
#'
#' @seealso [fit_survival_model()] for the model.
#' @importFrom data.table copy fifelse set setnames
#' @export
predict.survival_model <- function(object, newdata = NULL, horizon = 1, ...) {
  rlang::check_dots_empty()

  if (is.null(newdata)) {
    .predict_survival_cells(object)
  } else {
    .predict_survival_newdata(object, newdata, horizon)
  }
}
