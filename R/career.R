#' Estimate attrition and pay growth by years of service
#'
#' @description
#' For each year of service (tenure), and each group you choose, estimates
#' how many employees stay another year and how their real pay changes when
#' they do. These are the yearly rates that [compute_career_table()] chains
#' into a whole career.
#'
#' A panel of a few years shows each person for only part of their career,
#' but it shows *someone* at every stage. The rates are pooled over every
#' pair of consecutive snapshots, so each person adds to the rates of
#' whichever years of service they were seen in:
#'
#' 1. **One row per person and snapshot.** Each personnel record gets that
#'    snapshot's total pay across all of the person's contracts.
#' 2. **Staying.** Everyone `"active"` in a snapshot other than the last is
#'    exposed, at their whole years of tenure. `px` is the share still
#'    active at the next snapshot, from [estimate_decrement_rates()] with
#'    tenure in place of age.
#' 3. **Pay growth.** Among those who stayed and had pay in both years, the
#'    change in pay from one year to the next: `pay_growth`, with
#'    `median_pay_growth` and `share_pay_cut` beside it.
#'
#' Next, pass the same data to [compute_career_table()] to chain these rates
#' into expected years of service and a pay path over a career.
#'
#' @param personnel A data frame (data.table, data.frame or tibble) of the
#'   personnel panel: one row per person and snapshot, with
#'   `personnel_id_col`, `ref_date_col`, `status_col` and `tenure_col`.
#' @param contracts A data frame of the contract panel for the same people
#'   and snapshots, with `personnel_id_col`, `ref_date_col`,
#'   `contract_id_col` and `salary_col`. A person may hold several contracts
#'   in a snapshot.
#' @param tenure_col A single string: the column of `personnel` holding years
#'   of service at each snapshot. There is no default, because the
#'   personnel module does not usually include one. Build it first, in one of
#'   two ways:
#'   * with [compute_tenure_panel()], from contract history. Gaps between
#'     contracts are not counted, and neither is any service before the
#'     contract data starts.
#'   * as the years between `ref_date` and `first_employment_date`. Gaps
#'     count as service.
#'
#'   Fractional years are cut to whole years served (2.9 counts as 2).
#' @param salary_col A single string: the pay column of `contracts`. There is
#'   no default. It must already be in real terms (constant prices). Convert
#'   it with [deflate_to_real()] first, or pay rises caused only by inflation
#'   are read as career progression.
#' @param group_cols A character vector of columns to estimate separate rates
#'   for, or `NULL` (the default) for one set of rates over everyone. Each
#'   column can come from `personnel` (e.g. gender) or from `contracts`
#'   (e.g. occupation), but not from both.
#' @param select_contract Which of a person's contracts gives their
#'   contract-level groups (e.g. occupation) when they hold several in a
#'   snapshot: `"highest_paid"` (the default) or `"lowest_paid"`. Ties go to
#'   the lowest `contract_id_col`. Pay is always the total of all their
#'   contracts, whichever one gives the group.
#' @param status_col A single string: the employment status column of
#'   `personnel`. The value `"active"` means in service; any other value
#'   (e.g. `"pensioner"`) is a way of leaving. Default
#'   `"employment_status"`.
#' @param personnel_id_col A single string: the personnel identifier column,
#'   in both tables. Default `"personnel_id"`.
#' @param ref_date_col A single string: the snapshot date column, in both
#'   tables. Default `"ref_date"`.
#' @param contract_id_col A single string: the contract identifier column of
#'   `contracts`. Default `"contract_id"`.
#' @param ... Not used; must be empty.
#'
#' @returns A data.table with one row per `group_cols` combination and whole
#'   year of tenure, sorted by group and tenure:
#'   \describe{
#'     \item{group_cols, tenure_col}{The group and the whole years of
#'       service at the start of the year (integer).}
#'     \item{pop}{Integer. People exposed: active at that tenure in a
#'       snapshot other than the last, summed over all snapshot pairs.}
#'     \item{stayers}{Integer. How many of them were active at the next
#'       snapshot.}
#'     \item{px}{Numeric. The share who stayed, `stayers / pop`.}
#'     \item{n_pay}{Integer. Stayers with positive pay in both years, whom
#'       the pay growth is measured on. `0` if there were none.}
#'     \item{pay_growth}{Numeric. The typical yearly real pay growth of
#'       stayers, as a proportion (`0.05` is 5%): the geometric mean of
#'       their pay ratios, minus 1. `NA` when `n_pay` is 0.}
#'     \item{median_pay_growth}{Numeric. The median of the stayers' pay
#'       ratios, minus 1.}
#'     \item{share_pay_cut}{Numeric. The share of stayers whose real pay
#'       fell.}
#'     \item{mean_pay, median_pay}{Numeric. The average and median pay of
#'       everyone exposed with positive pay: a snapshot of pay levels at that
#'       tenure, not a career path.}
#'     \item{n_periods}{Integer. Number of snapshot pairs with anyone
#'       exposed at that tenure.}
#'   }
#'
#' @details
#' **Pooling.** Counts and pay changes are pooled over all snapshot pairs
#' before any rate is taken, so a pair with many people at a tenure weighs
#' more than a pair with few. `pay_growth` is
#' `exp(mean(log(pay next year / pay this year))) - 1` over all stayers at
#' that tenure.
#'
#' **Who counts as staying.** Only someone `"active"` at the very next
#' snapshot. Someone missing for a year and back later counted as leaving,
#' and adds no pay growth across the gap. So does someone who moves to
#' another status, even with pay in it (e.g. a pension contract).
#'
#' **Missing or zero pay.** A contract with missing pay is left out of the
#' person's total, which is missing only if all their contracts are. A
#' person with missing or zero pay in either year still counts in `pop` and
#' `px`, but not in the pay columns.
#'
#' **Groups that change over time.** A person's groups are those of the
#' start of each year. Someone who changes occupation adds to one
#' occupation's rates, then to another's.
#'
#' **Missing tenure.** An active person-year with no tenure belongs to no
#' year of the table. It is left out of the rates, with a warning, but still
#' counts as staying for the person's year before.
#'
#' **Duplicates.** A person with more than one personnel row in a snapshot
#' is counted once, with a warning (from [estimate_decrement_rates()]).
#'
#' **Not your workforce's future.** The rates describe what happened in the
#' panel's years. A pay reform or hiring freeze in those years shows up in
#' them.
#'
#' Errors if `tenure_col` is not in `personnel`; if a required column is
#' missing from either table; if a group column is in both tables or in
#' neither; or if `personnel` has fewer than 2 snapshots.
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
#' rates <- estimate_progression_rates(
#'   personnel, contracts,
#'   tenure_col = "tenure_years", salary_col = "gross_salary_real"
#' )
#'
#' # one row per year of service: how many stay, and how fast pay grows
#' rates[tenure_years %in% c(0, 10, 20, 30), .(tenure_years, pop, px, pay_growth)]
#'
#' @seealso [compute_career_table()] to chain these rates into a career,
#'   [estimate_decrement_rates()] for exits by type, [deflate_to_real()] and
#'   [compute_tenure_panel()] to prepare the pay and tenure columns.
#' @export
estimate_progression_rates <- function(personnel, ...) {
  UseMethod("estimate_progression_rates")
}

#' @rdname estimate_progression_rates
#' @importFrom data.table := as.data.table setnames setorderv shift
#' @export
estimate_progression_rates.data.frame <- function(personnel,
                                                  contracts,
                                                  tenure_col,
                                                  salary_col,
                                                  group_cols = NULL,
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
  .check_progression_args(
    personnel, contracts, tenure_col, salary_col, group_cols,
    status_col, personnel_id_col, ref_date_col, contract_id_col
  )

  ### groups can come from either table: a person's own columns (e.g.
  ### gender) or their contract's (e.g. occupation)
  person_group_cols <- intersect(group_cols, colnames(personnel))
  contract_group_cols <- intersect(group_cols, colnames(contracts))
  person_year <- c(personnel_id_col, ref_date_col)

  ### one row per person and snapshot: total pay across their contracts,
  ### and the contract-level groups of one of them
  pay_dt <- .pay_by_person_snapshot(
    contracts, person_year, contract_id_col, salary_col,
    contract_group_cols, select_contract
  )

  ### the person-year panel: each personnel record with that year's pay
  ### using a data.table join
  # panel <- merge(
  #   as.data.table(personnel)[,
  #     c(person_year, status_col, tenure_col, person_group_cols),
  #     with = FALSE
  #   ],
  #   pay_dt,
  #   by = person_year,
  #   all.x = TRUE
  # )

  panel <- pay_dt[as.data.table(personnel)[,
    c(person_year, status_col, tenure_col, person_group_cols),
    with = FALSE
  ], on = person_year]
  

  ### attrition: exposure and the share still active a year later, by
  ### group and tenure, from estimate_decrement_rates() with tenure as the
  ### clock
  stay_dt <- estimate_decrement_rates(
    panel,
    duration_col = tenure_col,
    status_col = status_col,
    personnel_id_col = personnel_id_col,
    ref_date_col = ref_date_col,
    group_cols = group_cols
  )[get(status_col) == "active",
    c(tenure_col, group_cols, "pop", "exits", "n_periods", "decrement_rate"),
    with = FALSE
  ]
  setnames(stay_dt, c("exits", "decrement_rate"), c("stayers", "px"))

  ### estimate_decrement_rates() has already warned about duplicated person
  ### and snapshot rows; keep the same (last) row it keeps, so the pay
  ### figures below count each person-year once too
  panel <- unique(panel, by = person_year, fromLast = TRUE)

  ### number the snapshots and sort by person and snapshot, so each
  ### person's next year is the row below (as in estimate_decrement_rates())
  all_dates <- sort(unique(panel[[ref_date_col]]))
  setnames(
    panel,
    c(personnel_id_col, status_col, tenure_col),
    c(".pid", ".status", ".tenure")
  )
  panel[, .snap := match(get(ref_date_col), all_dates)]
  setorderv(panel, c(".pid", ".snap"))
  panel[, `:=`(
    .next_pid = shift(.pid, type = "lead"),
    .next_snap = shift(.snap, type = "lead"),
    .next_status = shift(.status, type = "lead"),
    .next_pay = shift(.pay, type = "lead")
  )]

  ### the exposed: active in any snapshot but the last, by whole years of
  ### tenure at the start of the year. a person-year with no tenure belongs
  ### to no year of the table, so it is left out (with a warning) -- it
  ### still counts as "next year" for the person's year before
  exposed <- panel[.status == "active" & .snap < length(all_dates)]
  n_no_tenure <- exposed[, sum(is.na(.tenure))]
  if (n_no_tenure > 0L) {
    warning(
      n_no_tenure, " active person-year(s) have no `", tenure_col, "` and ",
      "are left out of the rates.",
      call. = FALSE
    )
    exposed <- exposed[!is.na(.tenure)]
    stay_dt <- stay_dt[!is.na(get(tenure_col))]
  }
  exposed[, .tenure := as.integer(.tenure)]

  ### pay growth among stayers: active again at the very next snapshot,
  ### with pay in both years
  stayed <- exposed[
    .next_pid == .pid & .next_snap == .snap + 1L & .next_status == "active" &
      .pay > 0 & .next_pay > 0
  ]
  growth_dt <- stayed[,
    .(
      n_pay = .N,
      pay_growth = expm1(mean(log(.next_pay / .pay))),
      median_pay_growth = stats::median(.next_pay / .pay) - 1,
      share_pay_cut = mean(.next_pay < .pay)
    ),
    by = c(".tenure", group_cols)
  ]

  ### the average and median pay of everyone exposed with positive pay, for
  ### comparison with the chained pay path (and, at the start of the career,
  ### as its starting pay)
  pay_level_dt <- exposed[,
    .(
      mean_pay = mean(.pay[.pay > 0], na.rm = TRUE),
      median_pay = stats::median(.pay[.pay > 0], na.rm = TRUE)
    ),
    by = c(".tenure", group_cols)
  ]

  ### one row per group and tenure; a cell where nobody stayed with pay in
  ### both years has n_pay 0 and no growth
  setnames(growth_dt, ".tenure", tenure_col)
  setnames(pay_level_dt, ".tenure", tenure_col)
  out <- merge(stay_dt, growth_dt, by = c(tenure_col, group_cols), all.x = TRUE)
  out <- merge(out, pay_level_dt, by = c(tenure_col, group_cols), all.x = TRUE)
  out[is.na(n_pay), n_pay := 0L]
  data.table::setcolorder(out, c(
    group_cols, tenure_col, "pop", "stayers", "px", "n_pay", "pay_growth",
    "median_pay_growth", "share_pay_cut", "mean_pay", "median_pay", "n_periods"
  ))
  setorderv(out, c(group_cols, tenure_col))

  out[]
}

#' Check the inputs of estimate_progression_rates()
#'
#' Shared by every method, so the checks cannot drift apart. Uses
#' `colnames()`, which also lists a lazy database table's columns.
#'
#' Stops with an error if:
#' * `tenure_col` is not in `personnel` (pointing to the two ways to build it),
#' * a required column is missing from `personnel` or `contracts`,
#' * a group column is in both tables (ambiguous) or in neither.
#'
#' @returns `NULL`, invisibly.
#' @noRd
.check_progression_args <- function(personnel, contracts, tenure_col,
                                    salary_col, group_cols, status_col,
                                    personnel_id_col, ref_date_col,
                                    contract_id_col) {
  if (!tenure_col %in% colnames(personnel)) {
    stop(
      "`personnel` has no tenure column `", tenure_col, "`. Add years of ",
      "service at each snapshot first: from contract history with ",
      "compute_tenure_panel(), or as the years between `ref_date` and ",
      "`first_employment_date`.",
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

  .check_column_sources(group_cols, personnel, contracts, "group column")

  invisible(NULL)
}

#' Check that each column comes from exactly one of personnel and contracts
#'
#' Shared by Level 1's group columns and the career panel's covariates.
#' Stops with an error if a column is in both tables (ambiguous) or in
#' neither.
#'
#' @param cols Character vector of column names, or `NULL`.
#' @param personnel,contracts The two tables.
#' @param noun What the columns are called in the error, e.g.
#'   `"group column"`.
#'
#' @returns `NULL`, invisibly.
#' @noRd
.check_column_sources <- function(cols, personnel, contracts, noun) {
  in_personnel <- cols %in% colnames(personnel)
  in_contracts <- cols %in% colnames(contracts)

  if (any(in_personnel & in_contracts)) {
    stop(
      paste0("`", cols[in_personnel & in_contracts], "`", collapse = ", "),
      " is in both `personnel` and `contracts`; rename one copy so each ",
      noun, " comes from one table.",
      call. = FALSE
    )
  }

  if (any(!in_personnel & !in_contracts)) {
    stop(
      paste0("`", cols[!in_personnel & !in_contracts], "`", collapse = ", "),
      " is in neither `personnel` nor `contracts`.",
      call. = FALSE
    )
  }

  invisible(NULL)
}

#' Total pay per person and snapshot, with contract columns from one contract
#'
#' Used by `estimate_progression_rates()` to turn contracts into one row per
#' person and snapshot:
#' * `.pay` is the total across the person's contracts, leaving out a
#'   contract with missing pay (`NA` only if all of them are missing);
#' * `contract_cols` (e.g. occupation) come from the one contract that
#'   `.choose_contract()` picks.
#'
#' @param contracts The contract table (any data frame).
#' @param person_year The person and snapshot columns.
#' @param contract_id_col,salary_col The contract id and pay columns.
#' @param contract_cols Columns to take from the chosen contract, or empty.
#' @param select_contract `"highest_paid"` or `"lowest_paid"`.
#'
#' @returns A data.table with one row per person and snapshot: `person_year`,
#'   `contract_cols` and `.pay`.
#' @noRd
.pay_by_person_snapshot <- function(contracts, person_year, contract_id_col,
                                    salary_col, contract_cols,
                                    select_contract) {
  contract_dt <- as.data.table(contracts)[,
    c(person_year, contract_id_col, salary_col, contract_cols),
    with = FALSE
  ]

  pay_dt <- contract_dt[,
    .(.pay = if (all(is.na(get(salary_col)))) {
      NA_real_
    } else {
      sum(get(salary_col), na.rm = TRUE)
    }),
    by = person_year
  ]

  if (length(contract_cols) > 0L) {
    chosen_dt <- .choose_contract(
      contract_dt, person_year, salary_col, contract_id_col, select_contract
    )[, c(person_year, contract_cols), with = FALSE]
    pay_dt <- chosen_dt[pay_dt, on = person_year]
  }

  pay_dt
}

#' Pick one contract per person and snapshot
#'
#' The highest-paid (or lowest-paid) contract, ties going to the lowest
#' contract id, and a contract with missing pay only if all of them are
#' missing. One sort and a pass keeping each group's first row, both in C,
#' which is several times faster than a grouped `max()` filter on large
#' panels (and needs no separate tie-break).
#'
#' @param contract_dt A data.table of contracts. **Sorted by reference.**
#' @param person_year The person and snapshot columns.
#' @param salary_col,contract_id_col The pay and contract id columns.
#' @param select_contract `"highest_paid"` or `"lowest_paid"`.
#'
#' @returns The chosen rows of `contract_dt`, one per person and snapshot.
#' @noRd
.choose_contract <- function(contract_dt, person_year, salary_col,
                             contract_id_col, select_contract) {
  pay_order <- if (select_contract == "highest_paid") -1L else 1L
  setorderv(
    contract_dt,
    c(person_year, salary_col, contract_id_col),
    order = c(1L, 1L, pay_order, 1L),
    na.last = TRUE
  )

  contract_dt[!duplicated(contract_dt, by = person_year)]
}

#' Compute a career table of service and pay by years of service
#'
#' @description
#' Answers two questions about a career in the public service: how many more
#' years does an employee stay, and how does their real pay grow, from
#' hiring onward? It builds a whole career out of a panel that covers only a
#' few years, by joining up people seen at different stages of theirs.
#'
#' Like [compute_service_table()], it follows an imaginary group of `radix`
#' new hires through the years, using the rates from
#' [estimate_progression_rates()]:
#'
#' 1. **Service.** Each year, a share `px` of the group stays. That gives
#'    how many are still in service at each tenure (`lx`) and the expected
#'    remaining years of service (`ex`).
#' 2. **Pay.** Starting from `entry_pay`, each year's `pay_growth` is
#'    compounded into `projected_pay`: the pay of someone who stays, at each
#'    year of service. `pay_index` is the same path with entry pay set to
#'    100.
#' 3. **Earnings.** Years in service times pay, added up over the rest of the
#'    career: `expected_earnings`.
#'
#' **The result is an imaginary career, not a forecast.** See Details.
#'
#' @inheritParams estimate_progression_rates
#' @param group_cols A character vector of columns to build a separate career
#'   for each combination of, or `NULL` (the default) for one career over
#'   everyone. Each column can come from `personnel` (e.g. gender) or
#'   `contracts` (e.g. occupation).
#' @param radix Number. The size of the imaginary group of new hires. It
#'   sets the scale of `lx`, `Lx` and `Tx` but does not affect any other
#'   column. Default `100000`.
#' @param entry_pay Number or `NULL`. The pay the career starts on, in the
#'   units of `salary_col`.
#'   * `NULL` (the default): the median pay of each group's people at its
#'     first tenure, usually new hires: "a career for a typical new hire".
#'   * `100`: `projected_pay` becomes an index, so careers can be compared
#'     between groups or countries by how fast pay grows.
#'   * Any other number, e.g. one grade's starting salary: "the career of
#'     someone starting on this pay".
#' @param smooth Logical. If `TRUE`, `px` and `pay_growth` are smoothed
#'   across tenure before chaining, which evens out years with few people.
#'   If `FALSE` (the default), the observed rates are used, unless a group
#'   has a gap, in which case they are smoothed anyway, with a warning (see
#'   Details).
#' @param span Number. How strongly to smooth: larger values give smoother
#'   rates. Passed to `loess()`. Only used when the rates are smoothed.
#'   Default `0.75`.
#' @param include_all Logical. If `TRUE` (the default), return every column;
#'   if `FALSE`, keep only `group_cols`, `tenure_col`, `px`, `ex`,
#'   `pay_growth` and `projected_pay`.
#' @param ... Passed to [estimate_progression_rates()]: `select_contract`,
#'   `status_col`, `personnel_id_col`, `ref_date_col`, `contract_id_col`.
#'
#' @returns A `career_table`: a data.table with one row per `group_cols`
#'   combination and whole year of tenure, from each group's first tenure to
#'   its last with no gaps, which [plot()][plot.career_table()] draws. Column
#'   names follow actuarial notation: `l` is a number of people, `L` and `T`
#'   person-years, `e` an expected number of years. With
#'   `include_all = FALSE`, only the columns marked * are kept.
#'   \describe{
#'     \item{group_cols*, tenure_col*}{The group and whole years of service.}
#'     \item{start_tenure}{Integer. The tenure the group's career starts at:
#'       0, unless no one in the group was seen at tenure 0.}
#'     \item{pop*, n_pay*}{As in [estimate_progression_rates()]: the people
#'       behind `px` and `pay_growth`, to judge how reliable they are. `NA`
#'       on a tenure filled in by smoothing.}
#'     \item{stayers, median_pay_growth, share_pay_cut, mean_pay, median_pay,
#'       n_periods}{As in [estimate_progression_rates()]. `NA` on a tenure
#'       filled in by smoothing.}
#'     \item{px*}{Share of those in service at this tenure still in service a
#'       year later (smoothed if the rates were).}
#'     \item{px_obs, pay_growth_obs}{`px` and `pay_growth` as observed, before
#'       smoothing; `NA` on a tenure filled in by smoothing. Equal to `px`
#'       and `pay_growth` when nothing was smoothed.}
#'     \item{lx}{Number of the imaginary group still in service at this
#'       tenure, starting from `radix`: \eqn{l(t) = radix \prod_{u<t} p(u)}.}
#'     \item{lx_next}{Number still in service a year later:
#'       \eqn{l(t) \cdot p(t)}.}
#'     \item{Lx}{Years served during this year, counting half a year for each
#'       person who leaves in it: \eqn{(l(t) + l_{next}(t)) / 2}.}
#'     \item{Tx}{Years served from this tenure to the end of the table:
#'       \eqn{\sum_{u \ge t} L(u)}.}
#'     \item{ex*}{Expected remaining years of service for someone in service
#'       at this tenure: \eqn{T(t) / l(t)}.}
#'     \item{pay_growth*}{Real pay growth from this year to the next, as a
#'       proportion (smoothed if the rates were).}
#'     \item{projected_pay*}{Pay at this tenure for someone who stays:
#'       `entry_pay` compounded by every earlier year's `pay_growth`.}
#'     \item{pay_index}{`projected_pay` with entry pay set to 100.}
#'     \item{expected_earnings}{Expected pay over the rest of the career for
#'       someone in service at this tenure:
#'       \eqn{\sum_{u \ge t} L(u) \cdot pay(u) / l(t)}. At the first tenure,
#'       the career earnings of a new hire.}
#'   }
#'
#' @details
#' **Imaginary career, not a forecast.** The table assumes a new hire meets,
#' at every future year of service, the stay rates and pay growth seen at
#' that tenure in your panel. It describes the careers the panel's years
#' imply, not what will happen to anyone. A pay reform or hiring freeze in
#' those years shapes the whole table.
#'
#' **Why chain pay growth instead of averaging pay by tenure.** `mean_pay`
#' compares different people at each tenure: those at tenure 25 were hired
#' 25 years ago, under other pay scales, and are the ones who stayed. The
#' chained `projected_pay` follows the pay changes of the same people from
#' one year to the next, so it is not distorted by who was hired when or who
#' left. The gap between the two shows how much that matters.
#'
#' **Where a career starts.** Each group's career starts at the first tenure
#' it was seen at (`start_tenure`). If no one in a group was seen at tenure
#' 0, for example an occupation people are promoted into rather than hired
#' into, its career starts later, with a warning naming the group. With
#' `entry_pay = NULL` the starting pay is the median at that tenure.
#'
#' **Gaps.** Both chains need a stay rate and a pay growth for every year
#' from a group's first tenure to its last. A year with no one in it, or no
#' one who stayed on pay, is a gap, and the rates are smoothed to fill it,
#' with a warning. Missing pay growth in a group's last year is not a gap,
#' since it is never used.
#'
#' **The table ends at the highest tenure in the data.** `ex` and
#' `expected_earnings` count nothing beyond it.
#'
#' **Units of `expected_earnings`.** It is in the units of `salary_col` per
#' year of service. If pay is monthly, multiply by 12 for yearly earnings.
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
#' # a career for a typical new hire (warns that a few person-years have no
#' # tenure); one row per year of service
#' career <- compute_career_table(
#'   personnel, contracts,
#'   tenure_col = "tenure_years", salary_col = "gross_salary_real",
#'   smooth = TRUE, include_all = FALSE
#' )
#' career[tenure_years %in% c(0, 10, 20, 30)]
#'
#' # how fast pay grows over a career, by gender: an index, 100 at entry
#' by_gender <- compute_career_table(
#'   personnel, contracts,
#'   tenure_col = "tenure_years", salary_col = "gross_salary_real",
#'   group_cols = "gender", entry_pay = 100, smooth = TRUE, include_all = FALSE
#' )
#' by_gender[tenure_years %in% c(0, 10, 20, 30)]
#'
#' @seealso [estimate_progression_rates()] for the yearly rates this table
#'   chains, and [compute_service_table()] for years of service by age.
#' @importFrom data.table setattr
#' @export
compute_career_table <- function(personnel,
                                 contracts,
                                 tenure_col,
                                 salary_col,
                                 group_cols = NULL,
                                 radix = 100000,
                                 entry_pay = NULL,
                                 smooth = FALSE,
                                 span = 0.75,
                                 include_all = TRUE,
                                 ...) {
  ### attrition and pay growth by group and tenure
  career_dt <- estimate_progression_rates(
    personnel, contracts,
    tenure_col = tenure_col,
    salary_col = salary_col,
    group_cols = group_cols,
    ...
  )

  ### both chains need every year from a group's first tenure to its last,
  ### each with a stay rate and (except the last, whose growth is never
  ### used) a pay growth. a missing year, or a year with no stayers on pay,
  ### is a gap: smooth it over, warning unless smoothing was asked for
  gap_dt <- career_dt[,
    .(gap = any(diff(get(tenure_col)) != 1L) ||
      anyNA(utils::head(pay_growth, -1L))),
    by = group_cols
  ]
  if (any(gap_dt$gap) && !isTRUE(smooth)) {
    warning(
      "compute_career_table() needs a stay rate and a pay growth for every ",
      "year of tenure in each group, but some years have a gap (no one at ",
      "that tenure, or no one staying on pay). The rates have been smoothed ",
      "to fill it; set smooth = TRUE to smooth them up front.",
      call. = FALSE
    )
  }
  ### keep the rates as observed, so smoothing can be judged against them
  career_dt[, `:=`(px_obs = px, pay_growth_obs = pay_growth)]
  if (isTRUE(smooth) || any(gap_dt$gap)) {
    career_dt <- .smooth_career_rates(career_dt, tenure_col, group_cols, span)
  }

  ### each group's career starts at the first tenure it was seen at. a
  ### group no one was seen joining (no tenure 0) describes careers from
  ### that later point on, so say which groups those are
  career_dt[, start_tenure := min(get(tenure_col)), by = group_cols]
  late_dt <- unique(
    career_dt[start_tenure > 0L, c(group_cols, "start_tenure"), with = FALSE]
  )
  if (nrow(late_dt) > 0L) {
    group_labels <- if (length(group_cols) > 0L) {
      do.call(paste, c(
        lapply(group_cols, function(col) paste(col, "=", late_dt[[col]])),
        sep = ", "
      ))
    } else {
      "the table"
    }
    warning(
      "No one was seen at tenure 0 in some groups, so their career path ",
      "starts later, at the first tenure seen: ",
      paste0(group_labels, " (from tenure ", late_dt$start_tenure, ")", collapse = "; "),
      ".",
      call. = FALSE
    )
  }

  ### the service chain, as in compute_service_table(): follow `radix` new
  ### hires through the years, keeping a share px of them each year
  career_dt[,
    lx := radix * cumprod(shift(px, n = 1L, fill = 1)),
    by = group_cols
  ]
  career_dt[, lx_next := lx * px]
  career_dt[, Lx := (lx + lx_next) / 2]
  career_dt[, Tx := rev(cumsum(rev(Lx))), by = group_cols]
  career_dt[, ex := Tx / lx]

  ### the pay chain: compound each year's growth from the start of the
  ### career, so pay at tenure t is entry pay times the growth of every
  ### earlier year (the first year has had no growth yet)
  career_dt[,
    pay_index := 100 * exp(cumsum(shift(log1p(pay_growth), n = 1L, fill = 0))),
    by = group_cols
  ]
  ### starting pay: as given, or else the median pay of each group's people
  ### at the first tenure in its table
  if (is.null(entry_pay)) {
    career_dt[, .entry_pay := median_pay[1L], by = group_cols]
  } else {
    career_dt[, .entry_pay := entry_pay]
  }
  career_dt[, projected_pay := .entry_pay * pay_index / 100]
  career_dt[, .entry_pay := NULL]

  ### expected earnings over the rest of the career for someone in service
  ### at tenure t: years served each later year (Lx) times that year's pay,
  ### summed from t on and divided by the number in service at t (as Tx / lx
  ### gives ex)
  career_dt[,
    expected_earnings := rev(cumsum(rev(Lx * projected_pay))) / lx,
    by = group_cols
  ]

  ### the full table, or only the headline columns
  keep_cols <- if (isTRUE(include_all)) {
    c(
      group_cols, tenure_col, "start_tenure", "pop", "stayers", "px", "px_obs",
      "lx", "lx_next", "Lx", "Tx", "ex", "n_pay", "pay_growth",
      "pay_growth_obs", "median_pay_growth", "share_pay_cut", "mean_pay",
      "median_pay", "projected_pay", "pay_index", "expected_earnings",
      "n_periods"
    )
  } else {
    c(
      group_cols, tenure_col, "pop", "px", "ex", "n_pay", "pay_growth",
      "projected_pay"
    )
  }

  ### a career_table, so plot() knows how to draw it
  career_dt <- career_dt[, keep_cols, with = FALSE]
  setattr(career_dt, "tenure_col", tenure_col)
  setattr(career_dt, "group_cols", group_cols)
  setattr(career_dt, "class", c("career_table", class(career_dt)))

  career_dt[]
}

#' Plot a career table
#'
#' Draws the career a table from [compute_career_table()] describes: pay
#' growth, projected pay and expected years of service left, one panel each,
#' against years of service, with one line per group. Dots show how many
#' people each year's estimate rests on, so thin years stand out.
#'
#' @param x A career table from [compute_career_table()].
#' @param which Character. The panels to draw, in order: any of
#'   `"pay_growth"`, `"projected_pay"` and `"ex"`. Defaults to pay growth and
#'   projected pay.
#' @param show_n Logical. If `TRUE` (the default), add a dot at each year of
#'   service sized by the number of people behind the estimate.
#' @param ... Not used.
#'
#' @return A ggplot object; print it to draw, or add to it (for example
#'   `+ ggplot2::scale_colour_manual()` for your own colours and group names).
#'
#' @details
#' **The line and the dots.** The line is the value in the table, smoothed
#' if the table was. The dot sits at the value observed at that year of
#' service, so on a smoothed table the gap between dot and line shows how
#' much smoothing moved it. A year filled in by smoothing has no dot.
#'
#' **What the dot size counts.**
#' \describe{
#'   \item{Pay growth}{`n_pay`, the people who stayed with pay in both years.}
#'   \item{Projected pay}{`n_pay` of the year before: pay at a year of service
#'     comes from the previous year's raise. Entry pay has no dot.}
#'   \item{Expected years of service left}{`pop`, the people in service at
#'     that year of service, whose stay rate it rests on. The years after it
#'     count too, so read it as a guide.}
#' }
#'
#' Pay growth is drawn in percent. Projected pay is in the units of the
#' table's `projected_pay`, which the plot cannot know; name them with
#' `+ ggplot2::labs(caption = ...)`.
#'
#' @examples
#' library(data.table)
#' contracts <- as.data.table(bra_hrmis_contract)
#' personnel <- as.data.table(bra_hrmis_personnel)
#' contracts[, gross_salary_real := deflate_to_real(gross_salary_lcu, ref_date, "BRA")]
#' tenure <- compute_tenure_panel(contracts)
#' personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)
#'
#' by_gender <- compute_career_table(
#'   personnel, contracts,
#'   tenure_col = "tenure_years", salary_col = "gross_salary_real",
#'   group_cols = "gender", smooth = TRUE
#' )
#' plot(by_gender)
#' plot(by_gender, which = c("pay_growth", "ex"))
#'
#' @seealso [compute_career_table()] for the table.
#' @importFrom data.table data.table rbindlist shift
#' @export
plot.career_table <- function(x,
                              which = c("pay_growth", "projected_pay"),
                              show_n = TRUE,
                              ...) {
  which <- match.arg(which, c("pay_growth", "projected_pay", "ex"), several.ok = TRUE)
  tenure_col <- attr(x, "tenure_col")
  group_cols <- attr(x, "group_cols")

  measure_labels <- c(
    pay_growth = "Pay growth (% per year)",
    projected_pay = "Projected pay",
    ex = "Expected years of service left"
  )
  ### the people each measure rests on
  n_cols <- c(pay_growth = "n_pay", projected_pay = "n_pay", ex = "pop")

  missing_cols <- setdiff(
    c(tenure_col, group_cols, which, n_cols[which]),
    names(x)
  )
  if (length(missing_cols) > 0L) {
    stop(
      "plot() needs the column(s) ", paste(missing_cols, collapse = ", "),
      " of the career table; keep them, or use compute_career_table() output ",
      "as it is.",
      call. = FALSE
    )
  }

  ### one line per group, groups in the order of the table
  group <- if (length(group_cols) > 0L) {
    do.call(paste, c(lapply(group_cols, function(col) x[[col]]), sep = " / "))
  } else {
    rep("All", nrow(x))
  }
  group <- factor(group, levels = unique(group))

  ### the observed pay growth, if the table kept it apart from the smoothed
  observed_growth <- if ("pay_growth_obs" %in% names(x)) {
    x$pay_growth_obs
  } else {
    x$pay_growth
  }

  ### long format: one row per group, tenure and measure
  plot_dt <- rbindlist(lapply(which, function(measure_col) {
    measure_dt <- data.table(
      group = group,
      tenure = x[[tenure_col]],
      value = x[[measure_col]],
      observed = x[[measure_col]],
      n = as.numeric(x[[n_cols[[measure_col]]]])
    )
    if (measure_col == "pay_growth") {
      measure_dt[, `:=`(value = 100 * value, observed = 100 * observed_growth)]
    }
    ### pay at a tenure is the result of the previous year's raise
    if (measure_col == "projected_pay") {
      measure_dt[, n := shift(n), by = group]
    }
    ### no one behind it (a year filled in by smoothing, or entry pay): no dot
    measure_dt[is.na(n) | n == 0, observed := NA_real_]
    measure_dt[, measure := measure_labels[[measure_col]]]
  }))
  plot_dt[, measure := factor(measure, levels = measure_labels[which])]

  p <- ggplot2::ggplot(
    plot_dt,
    ggplot2::aes(x = .data$tenure, y = .data$value, colour = .data$group)
  )
  if ("pay_growth" %in% which) {
    zero_dt <- data.table(
      measure = factor(measure_labels[["pay_growth"]], levels = levels(plot_dt$measure))
    )
    p <- p + ggplot2::geom_hline(
      data = zero_dt, ggplot2::aes(yintercept = 0),
      linewidth = 0.25, linetype = "dashed"
    )
  }
  p <- p + ggplot2::geom_line(linewidth = 0.8, na.rm = TRUE)
  if (isTRUE(show_n)) {
    p <- p +
      ggplot2::geom_point(
        ggplot2::aes(y = .data$observed, size = .data$n),
        alpha = 0.6, na.rm = TRUE
      ) +
      ggplot2::scale_size_area(max_size = 4, labels = scales::label_comma())
  }
  if (length(group_cols) == 0L) {
    p <- p + ggplot2::guides(colour = "none")
  }

  ### one panel per measure, its name standing in for the y axis title
  p +
    ggplot2::facet_wrap(~measure, scales = "free_y", strip.position = "left") +
    ggplot2::scale_x_continuous(n.breaks = 7) +
    ggplot2::scale_y_continuous(n.breaks = 7, labels = scales::label_comma()) +
    ggplot2::labs(
      x = "Years of service", y = NULL, colour = NULL,
      size = "People behind\nthe estimate"
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      panel.border = ggplot2::element_rect(colour = "black", linewidth = 0.5, fill = NA),
      axis.ticks = ggplot2::element_line(colour = "black", linewidth = 0.25),
      axis.ticks.length = ggplot2::unit(0.4, "lines"),
      panel.grid.major = ggplot2::element_line(linewidth = 0.25),
      strip.placement = "outside",
      strip.background = ggplot2::element_blank(),
      legend.position = "top"
    )
}

#' Smooth and gap-fill the rates of a career table
#'
#' Puts each group on every whole tenure from its first to its last, and
#' replaces `px` and `pay_growth` with smoothed curves from
#' `.smooth_rate_curve()`: the exit rate `1 - px` weighted by exposure
#' (`pop`), and pay growth weighted by the stayers it was measured on
#' (`n_pay`). Exit rates are clipped to `[0, 1]`. The other columns of
#' `career_dt` are kept as observed, and are `NA` on a filled-in tenure.
#'
#' @param career_dt The output of `estimate_progression_rates()`.
#' @param tenure_col,group_cols As in `compute_career_table()`.
#' @param span The `loess()` span passed to `.smooth_rate_curve()`.
#'
#' @returns A data.table like `career_dt`, sorted by group and tenure, with
#'   no tenure gaps.
#' @noRd
.smooth_career_rates <- function(career_dt, tenure_col, group_cols, span) {
  smoothed_dt <- career_dt[,
    {
      tenure <- get(tenure_col)
      full_tenure <- seq.int(min(tenure), max(tenure))

      ### exit rates, as a probability
      exit_rate <- .smooth_rate_curve(tenure, 1 - px, pop, full_tenure, span)
      smoothed_px <- 1 - pmin(pmax(exit_rate, 0), 1)

      ### pay growth, from the years it was measured in
      has_growth <- !is.na(pay_growth)
      smoothed_growth <- if (any(has_growth)) {
        .smooth_rate_curve(
          tenure[has_growth], pay_growth[has_growth], n_pay[has_growth],
          full_tenure, span
        )
      } else {
        rep(NA_real_, length(full_tenure))
      }

      stats::setNames(
        list(full_tenure, smoothed_px, smoothed_growth),
        c(tenure_col, "px", "pay_growth")
      )
    },
    by = group_cols
  ]

  ### the observed columns, matched back by group and tenure
  observed_dt <- career_dt[, !c("px", "pay_growth")]
  smoothed_dt <- merge(
    smoothed_dt, observed_dt,
    by = c(group_cols, tenure_col), all.x = TRUE
  )
  setorderv(smoothed_dt, c(group_cols, tenure_col))

  smoothed_dt[]
}
