#' Build a panel of career intervals for survival and pay models
#'
#' @description
#' Turns the personnel and contract modules into the table that models of
#' careers need: for each employee and each snapshot they are active in,
#' **what happened by the next snapshot** (did they stay, retire or leave
#' otherwise, and for how long were they at risk) and **how their real pay
#' changed over the following year**. Neither module records these: they
#' come from comparing each person's record with their own later records.
#'
#' It works at any snapshot frequency (monthly, quarterly, annual or
#' irregular), measuring time from the dates themselves, and reports every
#' rate per year:
#'
#' 1. **One row per person and snapshot.** Each personnel record gets that
#'    snapshot's total pay across all of the person's contracts, and its
#'    covariates.
#' 2. **At risk.** Every row that is `"active"` and has a later snapshot in
#'    the panel is an interval at risk, from `ref_date` to the next
#'    snapshot (`next_ref_date`).
#' 3. **How it ended.** `exit_type` says whether the person was still
#'    active at the next snapshot, had retired, or had left otherwise, and
#'    `exposure` is the time at risk, in years.
#' 4. **Pay growth.** `pay_growth` compares pay with the same person's pay
#'    a year later.
#'
#' Each row is one observation for a model of exits (with `exit_type` as
#' the outcome and `exposure` as the time at risk) or of pay growth.
#'
#' @param personnel A data frame (data.table, data.frame or tibble) or a
#'   remote database table (`tbl_dbi`, e.g. DuckDB) of the personnel panel:
#'   one row per person and snapshot, with `personnel_id_col`,
#'   `ref_date_col`, `status_col` and `clock_col`.
#' @param contracts The contract panel for the same people and snapshots,
#'   with `personnel_id_col`, `ref_date_col`, `contract_id_col` and
#'   `salary_col`: a data frame, or, when `personnel` is a database table, a
#'   table on the same connection. A person may hold several contracts in a
#'   snapshot.
#' @param clock_col A single string: the column of `personnel` that careers
#'   are timed on, in years. There is no default. Usually one of:
#'   * years of service, for careers by tenure. Build it with
#'     [compute_tenure_panel()] from contract history, or as the years
#'     since `first_employment_date`.
#'   * age, for careers by age (as in [compute_service_table()]).
#'
#'   It is kept as it is, not rounded: models choose their own bands.
#' @param salary_col A single string: the pay column of `contracts`. There is
#'   no default. It must already be in real terms (constant prices). Convert
#'   it with [deflate_to_real()] first, or pay rises caused only by inflation
#'   are read as career progression.
#' @param covariate_cols A character vector of columns to carry into the
#'   panel as covariates (e.g. `c("gender", "occupation")`), or `NULL` (the
#'   default) for none. Each can come from `personnel` or from `contracts`,
#'   but not from both. To use age as a covariate on a panel timed by
#'   tenure, include the age column here.
#' @param select_contract Which of a person's contracts gives their
#'   contract-level covariates (e.g. occupation) when they hold several in a
#'   snapshot: `"highest_paid"` (the default) or `"lowest_paid"`. Ties go to
#'   the lowest `contract_id_col`. Pay is always the total of all their
#'   contracts, whichever one gives the covariates.
#' @param status_col A single string: the employment status column of
#'   `personnel`. `"active"` means in service and `"pensioner"` retired; any
#'   other value (e.g. `"inactive"`) is another way of leaving. Default
#'   `"employment_status"`.
#' @param personnel_id_col A single string: the personnel identifier column,
#'   in both tables. Default `"personnel_id"`.
#' @param ref_date_col A single string: the snapshot date column, in both
#'   tables. Default `"ref_date"`.
#' @param contract_id_col A single string: the contract identifier column of
#'   `contracts`. Default `"contract_id"`.
#' @param ... Not used; must be empty.
#'
#' @returns A data.table with one row per interval at risk: a person active
#'   at a snapshot that has a later one, sorted by person and
#'   `ref_date_col`. For database tables, the same columns as a lazy table
#'   that stays in the database, unsorted (database rows have no order): use
#'   `dplyr::collect()` to bring it into R, and sort it there.
#'   \describe{
#'     \item{personnel_id_col, ref_date_col}{The person, and the snapshot the
#'       interval starts at.}
#'     \item{next_ref_date}{Date. The panel's next snapshot, where the
#'       interval ends (whether or not the person has a record there).}
#'     \item{spell}{Integer. The person's spell of service: 1, then one
#'       more each time they come back after leaving.}
#'     \item{clock_col}{The clock at the start of the interval, as given.}
#'     \item{covariate_cols}{The covariates at the start of the interval.}
#'     \item{pay}{Numeric. Total pay across the person's contracts at
#'       `ref_date`, in the units of `salary_col`. `NA` if they have no
#'       contract with pay.}
#'     \item{exposure}{Numeric. Years at risk: the length of the interval,
#'       or half of it for someone who left during it.}
#'     \item{exit_type}{Character. How the interval ended: `"none"` (still
#'       active at the next snapshot), `"retirement"` (`"pensioner"` there)
#'       or `"other"` (no record there, or any other status).}
#'     \item{pay_growth}{Numeric. Yearly growth in pay to a year later, as a
#'       log change per year (`0.05` is about 5%). `NA` when there is no
#'       snapshot a year later, the person is not active then, or pay is
#'       missing or zero at either end.}
#'   }
#'
#' @details
#' **Time is counted in calendar months.** A month is 1/12 of a year,
#' whatever its number of days, so a year of monthly snapshots adds up to
#' exactly the same exposure as one annual interval.
#'
#' **Leavers count half the interval.** Someone who leaves is assumed to
#' leave halfway through, as in a life table. Someone missing for a while
#' and back later left (`"other"`), and starts a new `spell` when they come
#' back: some people, such as seasonal workers, leave and return often.
#'
#' **What "a year later" means.** The snapshot closest to one year after
#' `ref_date`, if it is within half the panel's usual spacing of snapshots
#' (the median gap): the same month a year later in a monthly panel, and
#' the next snapshot in an annual one. Pay over a shorter or longer span
#' would mix in the timing of payments (a 13th salary, back pay), so with
#' no snapshot that close (the panel's last year, or a snapshot missing),
#' `pay_growth` is `NA`. The person must be active a year later, but need
#' not have stayed throughout: a seasonal worker's pay growth counts.
#'
#' **Not at risk.** Rows with another status (e.g. pensioners) and rows at
#' the panel's last snapshot, since nothing is known about what came next.
#'
#' **Missing or zero pay.** A contract with missing pay is left out of the
#' person's total, which is `NA` only if all of them are missing. A person
#' with no pay, or zero pay, is still at risk; only their `pay_growth` is
#' `NA`.
#'
#' **Covariates that change over time** are taken at the start of each
#' interval: someone who changes occupation has rows in one occupation,
#' then the other.
#'
#' **Missing clock or date.** An active row with no `clock_col` is left out,
#' with a warning, but still counts as the person's next record for their
#' row before (and its exit still starts a new spell). A personnel row with
#' no `ref_date_col` is dropped. A contract with no matching personnel row is
#' ignored.
#'
#' **Duplicates.** A person with more than one personnel row in a snapshot
#' keeps one of them, with a warning: the last one in a data frame and, in
#' a database (where rows have no order), the first by status. The two are
#' the same when duplicates are exact copies.
#'
#' **Matches Level 1 on annual data.** Summing the rows by whole years of
#' tenure gives the exposed, stayers and pay growth of
#' [estimate_progression_rates()].
#'
#' **On a database.** For database tables, the same steps run inside the
#' database as SQL, giving the same panel, and the result is returned
#' lazily. A few small queries run straight away: the snapshot dates (whose
#' calendar is worked out in R and sent back inline, so no write access is
#' needed), and counts for the warnings about duplicates and missing clock
#' values.
#'
#' Errors if `clock_col` is not in `personnel`; if a required column is
#' missing from either table; if a covariate is in both tables or in
#' neither; if `personnel` has fewer than 2 snapshots; if `personnel` is a
#' database table and `contracts` is not a table on the same connection; or
#' if `personnel` is neither a data frame nor a database table.
#'
#' @examples
#' library(data.table)
#' contracts <- as.data.table(bra_hrmis_contract)
#' personnel <- as.data.table(bra_hrmis_personnel)
#'
#' # real pay: gross pay in December 2021 prices
#' contracts[, gross_salary_real := deflate_to_real(gross_salary_lcu, ref_date, "BRA")]
#'
#' # years of service at each snapshot, from contract history
#' tenure <- compute_tenure_panel(contracts)
#' personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)
#'
#' # warns that a few person-years have no contract history, so no tenure
#' panel <- build_career_panel(
#'   personnel, contracts,
#'   clock_col = "tenure_years", salary_col = "gross_salary_real",
#'   covariate_cols = c("gender", "occupation_english")
#' )
#'
#' # one row per person and year at risk
#' panel[1:5]
#'
#' # how the intervals ended, and the years at risk
#' panel[, .(intervals = .N, years_at_risk = sum(exposure)), by = exit_type]
#'
#' @examplesIf requireNamespace("duckdb", quietly = TRUE) && requireNamespace("dbplyr", quietly = TRUE)
#' # the same panel, built inside a database (here DuckDB): only what you
#' # collect() comes into R
#' con <- DBI::dbConnect(duckdb::duckdb())
#' DBI::dbWriteTable(con, "personnel", personnel[, .(
#'   personnel_id, ref_date, employment_status, tenure_years, gender
#' )])
#' DBI::dbWriteTable(con, "contracts", contracts[, .(
#'   contract_id, personnel_id, ref_date, gross_salary_real, occupation_english
#' )])
#'
#' panel_db <- build_career_panel(
#'   dplyr::tbl(con, "personnel"), dplyr::tbl(con, "contracts"),
#'   clock_col = "tenure_years", salary_col = "gross_salary_real",
#'   covariate_cols = c("gender", "occupation_english")
#' )
#'
#' # counted in the database: the same intervals as above
#' dplyr::count(panel_db, exit_type)
#'
#' DBI::dbDisconnect(con, shutdown = TRUE)
#'
#' @seealso [estimate_progression_rates()] and [compute_career_table()] for
#'   the annual career table by group, [compute_tenure_panel()] and
#'   [deflate_to_real()] to prepare the clock and pay columns.
#' @export
build_career_panel <- function(personnel, ...) {
  UseMethod("build_career_panel")
}

#' @rdname build_career_panel
#' @importFrom data.table := as.data.table setnames setorderv shift
#' @export
build_career_panel.data.frame <- function(personnel,
                                          contracts,
                                          clock_col,
                                          salary_col,
                                          covariate_cols = NULL,
                                          select_contract = c(
                                            "highest_paid", "lowest_paid"
                                          ),
                                          status_col = "employment_status",
                                          personnel_id_col = "personnel_id",
                                          ref_date_col = "ref_date",
                                          contract_id_col = "contract_id",
                                          ...) {
  rlang::check_dots_empty()
  select_contract <- match.arg(select_contract)
  .check_career_panel_args(
    personnel, contracts, clock_col, salary_col, covariate_cols,
    status_col, personnel_id_col, ref_date_col, contract_id_col
  )

  ### covariates can come from either table: a person's own columns (e.g.
  ### gender) or their contract's (e.g. occupation)
  person_covariate_cols <- intersect(covariate_cols, colnames(personnel))
  contract_covariate_cols <- intersect(covariate_cols, colnames(contracts))
  person_year <- c(personnel_id_col, ref_date_col)

  ### one row per person and snapshot: total pay across their contracts,
  ### and the contract covariates of one of them
  pay_dt <- .pay_by_person_snapshot(
    contracts, person_year, contract_id_col, salary_col,
    contract_covariate_cols, select_contract
  )

  ### the person-snapshot panel: each personnel record with that snapshot's
  ### pay and covariates (NA for a record with no contract)
  panel <- pay_dt[
    as.data.table(personnel)[,
      c(person_year, status_col, clock_col, person_covariate_cols),
      with = FALSE
    ],
    on = person_year
  ]

  ### personnel should have one row per person and snapshot (enforced by QC
  ### upstream); keep the last of any duplicates, as Level 1 does
  n_dup <- nrow(panel) - data.table::uniqueN(panel, by = person_year)
  if (n_dup > 0L) {
    .warn_panel_duplicates(n_dup, personnel_id_col, ref_date_col)
    panel <- unique(panel, by = person_year, fromLast = TRUE)
  }

  setnames(
    panel,
    c(personnel_id_col, ref_date_col, status_col),
    c(".pid", ".date", ".status")
  )

  ### the snapshot calendar: each snapshot's number, its next snapshot and
  ### its snapshot a year later, and the years to each
  panel <- panel[!is.na(.date)]
  all_dates <- sort(unique(panel$.date))
  .check_panel_snapshots(
    length(all_dates), arg = "personnel", ref_date_col = ref_date_col
  )
  calendar <- .career_snapshot_calendar(all_dates)

  ### number the snapshots 1, 2, 3, ... and sort by person and snapshot, so
  ### each person's later records sit in the rows below (as in
  ### estimate_decrement_rates()): reading them with shift() is several
  ### times faster than joining the panel to itself
  panel[, .status := as.character(.status)]
  panel[, .snap := match(.date, all_dates)]
  panel[, `:=`(
    next_ref_date = calendar$next_ref_date[.snap],
    .ahead_snap = calendar$.ahead_snap[.snap]
  )]
  setorderv(panel, c(".pid", ".snap"))

  ### status at the next snapshot: the row below, if it is the same person
  ### at that snapshot; NA if they have no record there
  panel[, .next_status := data.table::fifelse(
    shift(.pid, type = "lead") == .pid & shift(.snap, type = "lead") == .snap + 1L,
    shift(.status, type = "lead"),
    NA_character_
  )]

  ### status and pay a year later: the row of the same person at the year-
  ### later snapshot, if they have one. each row gets a number unique to its
  ### person and snapshot (people numbered 1, 2, ... in sorted order), and
  ### one hashed lookup of the year-later number finds that row, however
  ### many snapshots lie between (1 in an annual panel, 12 in a monthly
  ### one) and whatever gaps the person has
  person_base <- data.table::rleid(panel$.pid) * (length(all_dates) + 1)
  panel[, .ahead_row := collapse::fmatch(person_base + .ahead_snap, person_base + .snap)]
  panel[, `:=`(.ahead_status = .status[.ahead_row], .ahead_pay = .pay[.ahead_row])]

  ### at risk: active, with a later snapshot to see what happened by then
  ### (a subset, so still sorted by person and snapshot)
  panel <- panel[.status == "active" & !is.na(next_ref_date)]

  ### how the interval ended: still active, retired, or gone (no record, or
  ### any other status)
  panel[, exit_type := data.table::fifelse(
    !is.na(.next_status) & .next_status == "active",
    "none",
    data.table::fifelse(
      !is.na(.next_status) & .next_status == "pensioner",
      "retirement",
      "other"
    )
  )]

  ### years at risk: the whole interval for someone who stays, half of it
  ### for someone who leaves at some point during it
  panel[, exposure := calendar$.interval_years[.snap] *
    data.table::fifelse(exit_type == "none", 1, 0.5)]

  ### yearly growth in pay of those active a year later, with pay at both
  ### ends -- whether or not they left and came back in between (seasonal
  ### work) -- as a log change per year
  panel[, pay_growth := NA_real_]
  panel[
    .ahead_status == "active" & .pay > 0 & .ahead_pay > 0,
    pay_growth := log(.ahead_pay / .pay) / calendar$.ahead_years[.snap]
  ]

  ### a person's spells of service: the first starts at 1, and each later
  ### one after an interval they left in (and came back from)
  panel[,
    spell := 1L + cumsum(shift(exit_type != "none", fill = FALSE)),
    by = .pid
  ]

  ### a row with no clock value belongs nowhere on the clock, so it is left
  ### out (with a warning) -- only now, so that it still counted as "next"
  ### for the person's row before, and its exit still started a new spell
  n_no_clock <- panel[, sum(is.na(get(clock_col)))]
  if (n_no_clock > 0L) {
    .warn_panel_no_clock(n_no_clock, clock_col)
    panel <- panel[!is.na(get(clock_col))]
  }

  setnames(
    panel, c(".pid", ".date", ".pay"), c(personnel_id_col, ref_date_col, "pay")
  )
  panel[, c(
    person_year, "next_ref_date", "spell", clock_col, covariate_cols, "pay",
    "exposure", "exit_type", "pay_growth"
  ), with = FALSE]
}

#' Check the inputs of build_career_panel()
#'
#' Stops with an error if:
#' * `clock_col` is not in `personnel` (pointing to the ways to build one),
#' * a required column is missing from `personnel` or `contracts`,
#' * a covariate is in both tables (ambiguous) or in neither.
#'
#' @returns `NULL`, invisibly.
#' @noRd
.check_career_panel_args <- function(personnel, contracts, clock_col,
                                     salary_col, covariate_cols, status_col,
                                     personnel_id_col, ref_date_col,
                                     contract_id_col) {
  if (!clock_col %in% colnames(personnel)) {
    stop(
      "`personnel` has no clock column `", clock_col, "`. Add the clock the ",
      "careers run on first: years of service, from contract history with ",
      "compute_tenure_panel() or as the years since `first_employment_date`; ",
      "or age.",
      call. = FALSE
    )
  }

  check_required_cols(
    personnel, c(personnel_id_col, ref_date_col, status_col), "personnel"
  )
  check_required_cols(
    contracts, c(personnel_id_col, ref_date_col, contract_id_col, salary_col),
    "contracts"
  )

  .check_column_sources(covariate_cols, personnel, contracts, "covariate")

  invisible(NULL)
}

#' Years between two dates, counted in calendar months
#'
#' Every calendar month is 1/12 of a year, whatever its number of days, so
#' twelve monthly intervals add up to exactly the one-year interval they
#' span, and annual snapshots on the same date are exactly 1 apart. (A
#' count of days is not both: by days, a month is 28 to 31 / 365 or 366 of
#' a year.)
#'
#' @param from,to Date vectors.
#' @returns A numeric vector of years.
#' @noRd
.years_between <- function(from, to) {
  lubridate::time_length(lubridate::interval(from, to), "month") / 12
}

#' @rdname build_career_panel
#' @importFrom dplyr across all_of case_when collect count desc filter
#'   group_by inner_join lag lead left_join mutate pull rename row_number
#'   select summarise ungroup
#' @export
build_career_panel.tbl_dbi <- function(personnel,
                                       contracts,
                                       clock_col,
                                       salary_col,
                                       covariate_cols = NULL,
                                       select_contract = c(
                                         "highest_paid", "lowest_paid"
                                       ),
                                       status_col = "employment_status",
                                       personnel_id_col = "personnel_id",
                                       ref_date_col = "ref_date",
                                       contract_id_col = "contract_id",
                                       ...) {
  rlang::check_dots_empty()
  select_contract <- match.arg(select_contract)

  ### both tables must live in the same database, so they can be joined
  ### there
  if (!inherits(contracts, "tbl_dbi") ||
    !identical(dbplyr::remote_con(personnel), dbplyr::remote_con(contracts))) {
    stop(
      "`personnel` and `contracts` must be tables on the same database ",
      "connection.",
      call. = FALSE
    )
  }
  .check_career_panel_args(
    personnel, contracts, clock_col, salary_col, covariate_cols,
    status_col, personnel_id_col, ref_date_col, contract_id_col
  )

  ### the same steps as the data.frame method, written as dplyr verbs that
  ### dbplyr turns into SQL -- the panel itself never leaves the database
  person_covariate_cols <- intersect(covariate_cols, colnames(personnel))
  contract_covariate_cols <- intersect(covariate_cols, colnames(contracts))
  person_year <- c(personnel_id_col, ref_date_col)
  salary <- rlang::sym(salary_col)

  ### one row per person and snapshot: total pay across their contracts. a
  ### SQL SUM() leaves out missing pay and is NULL only if all of it is
  contract_tbl <- contracts |>
    select(all_of(c(person_year, contract_id_col, salary_col, contract_covariate_cols)))
  pay_tbl <- contract_tbl |>
    group_by(across(all_of(person_year))) |>
    summarise(.pay = sum(!!salary, na.rm = TRUE), .groups = "drop")

  ### contract covariates from one contract per person and snapshot: the
  ### highest (or lowest) paid, ties to the lowest contract id, and missing
  ### pay last (databases differ on where they sort NULLs, so it is said
  ### explicitly)
  if (length(contract_covariate_cols) > 0L) {
    pay_order <- if (select_contract == "highest_paid") {
      rlang::expr(desc(!!salary))
    } else {
      salary
    }
    chosen_tbl <- contract_tbl |>
      mutate(.no_pay = case_when(is.na(!!salary) ~ 1L, TRUE ~ 0L)) |>
      group_by(across(all_of(person_year))) |>
      dbplyr::window_order(.no_pay, !!pay_order, !!rlang::sym(contract_id_col)) |>
      filter(row_number() == 1L) |>
      ungroup() |>
      select(all_of(c(person_year, contract_covariate_cols)))
    pay_tbl <- left_join(pay_tbl, chosen_tbl, by = person_year)
  }

  ### the person-snapshot panel: each personnel record with that snapshot's
  ### pay and covariates (NULL for a record with no contract)
  panel <- personnel |>
    select(all_of(c(person_year, status_col, clock_col, person_covariate_cols))) |>
    left_join(pay_tbl, by = person_year) |>
    rename(all_of(c(.pid = personnel_id_col, .date = ref_date_col, .status = status_col))) |>
    filter(!is.na(.date))

  ### the snapshot dates: a small table, brought into R for the calendar
  all_dates <- sort(pull(collect(dplyr::distinct(panel, .date)), .date))
  .check_panel_snapshots(
    length(all_dates), arg = "personnel", ref_date_col = ref_date_col
  )

  ### duplicates at the person/snapshot level: count the surplus rows, then
  ### keep one row per person and snapshot. rows in a database have no
  ### order, so "the last one" has no meaning: keep the first by status
  n_dup <- panel |>
    count(.pid, .date, name = ".n") |>
    filter(.n > 1L) |>
    summarise(.n_dup = sum(.n - 1L, na.rm = TRUE)) |>
    pull(.n_dup)
  if (isTRUE(n_dup > 0)) {
    .warn_panel_duplicates(n_dup, personnel_id_col, ref_date_col)
    panel <- panel |>
      group_by(.pid, .date) |>
      dbplyr::window_order(.status) |>
      filter(row_number() == 1L) |>
      ungroup()
  }

  ### the snapshot calendar, worked out in R (where dates are counted in
  ### calendar months, exactly as in the data.frame method) and sent to the
  ### database inline, so no write access is needed
  calendar <- dbplyr::copy_inline(
    dbplyr::remote_con(personnel), .career_snapshot_calendar(all_dates)
  )
  panel <- inner_join(panel, calendar, by = ".date")

  ### status and pay a year later: the same person's record at the
  ### year-later snapshot, if they have one (a join, which databases are
  ### built for)
  ahead_tbl <- panel |>
    select(.pid, .ahead_snap = .snap, .ahead_status = .status, .ahead_pay = .pay)

  ### status at the next snapshot, read with a LEAD() window ordered by
  ### snapshot -- the SQL counterpart of looking at the row below -- if it
  ### is the very next snapshot. then keep the rows at risk: active, with a
  ### later snapshot to see what happened by then
  panel <- panel |>
    left_join(ahead_tbl, by = c(".pid", ".ahead_snap")) |>
    group_by(.pid) |>
    dbplyr::window_order(.snap) |>
    mutate(.lead_snap = lead(.snap), .lead_status = lead(.status)) |>
    ungroup() |>
    filter(.status == "active", !is.na(next_ref_date)) |>
    mutate(
      .next_status = case_when(.lead_snap == .snap + 1L ~ .lead_status),
      ### how the interval ended: still active, retired, or gone
      exit_type = case_when(
        .next_status == "active" ~ "none",
        .next_status == "pensioner" ~ "retirement",
        TRUE ~ "other"
      ),
      ### years at risk, half the interval for someone who leaves
      exposure = .interval_years * case_when(exit_type == "none" ~ 1, TRUE ~ 0.5),
      ### yearly growth in pay of those active a year later
      pay_growth = case_when(
        .ahead_status == "active" & .pay > 0 & .ahead_pay > 0 ~
          log(.ahead_pay / .pay) / .ahead_years
      )
    ) |>
    ### a person's spells of service: 1, then one more after each interval
    ### they left in (two steps, since SQL cannot nest one window function
    ### in another)
    group_by(.pid) |>
    dbplyr::window_order(.snap) |>
    mutate(.left_before = lag(case_when(exit_type == "none" ~ 0L, TRUE ~ 1L), default = 0L)) |>
    mutate(spell = as.integer(1L + cumsum(.left_before))) |>
    ungroup()

  ### a row with no clock value is left out, with a warning -- only now, so
  ### that it still counted as "next" for the row before, and its exit
  ### still started a new spell
  clock <- rlang::sym(clock_col)
  n_no_clock <- panel |>
    filter(is.na(!!clock)) |>
    count(name = ".n") |>
    pull(.n)
  if (isTRUE(n_no_clock > 0)) {
    .warn_panel_no_clock(n_no_clock, clock_col)
    panel <- filter(panel, !is.na(!!clock))
  }

  new_names <- stats::setNames(
    c(".pid", ".date", ".pay"), c(personnel_id_col, ref_date_col, "pay")
  )
  ### not sorted: rows in a database have no order, and an ORDER BY here
  ### would be dropped (with a warning) by any summary built on the panel
  panel |>
    rename(all_of(new_names)) |>
    select(all_of(c(
      person_year, "next_ref_date", "spell", clock_col, covariate_cols, "pay",
      "exposure", "exit_type", "pay_growth"
    )))
}

#' @rdname build_career_panel
#' @export
build_career_panel.default <- function(personnel, ...) {
  stop_unsupported_data(personnel, "personnel")
}

#' The snapshot calendar of a career panel
#'
#' Shared by both methods of `build_career_panel()`, so they time intervals
#' identically. For each snapshot date: its number, the panel's next
#' snapshot, the snapshot a year later (the one closest to one year on, if
#' within half the median spacing of snapshots; `NA` otherwise), and the
#' years to each, counted in calendar months.
#'
#' @param all_dates Sorted, unique, non-missing snapshot dates (at least 2).
#'
#' @returns A data frame with one row per date: `.date`, `.snap` (1, 2, ...),
#'   `next_ref_date`, `.ahead_snap`, `.interval_years` and `.ahead_years`
#'   (`NA` where there is no next or year-later snapshot).
#' @noRd
.career_snapshot_calendar <- function(all_dates) {
  n_snaps <- length(all_dates)

  ### the snapshot a year later: the one closest to one year on, if within
  ### half the usual spacing of snapshots -- the same month a year later in
  ### a monthly panel, the next snapshot in an annual one. pay over a
  ### shorter or longer span mixes in the timing of payments (a 13th
  ### salary, back pay), so with none that close there is none
  spacing <- stats::median(as.numeric(diff(all_dates)))
  one_year_on <- lubridate::add_with_rollback(all_dates, lubridate::years(1))
  closest <- vapply(
    seq_len(n_snaps),
    function(i) which.min(abs(as.numeric(all_dates - one_year_on[i]))),
    integer(1)
  )
  ahead_snap <- closest
  ahead_snap[abs(as.numeric(all_dates[closest] - one_year_on)) > spacing / 2] <- NA

  next_ref_date <- all_dates[seq_len(n_snaps) + 1L]
  data.frame(
    .date = all_dates,
    .snap = seq_len(n_snaps),
    next_ref_date = next_ref_date,
    .ahead_snap = ahead_snap,
    .interval_years = .years_between(all_dates, next_ref_date),
    .ahead_years = .years_between(all_dates, all_dates[ahead_snap])
  )
}

### warnings shared by both methods, so they say the same thing

#' @noRd
.warn_panel_duplicates <- function(n_dup, personnel_id_col, ref_date_col) {
  warning(
    "`personnel` has ", n_dup, " duplicate rows at the ", personnel_id_col,
    "/", ref_date_col, " level, which should be unique. Keeping one row for ",
    "each person and snapshot.",
    call. = FALSE
  )
}

#' @noRd
.warn_panel_no_clock <- function(n_no_clock, clock_col) {
  warning(
    n_no_clock, " active person-snapshot(s) have no `", clock_col, "` and ",
    "are left out of the panel.",
    call. = FALSE
  )
}
