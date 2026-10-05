#' Compute standard wagebill indicators
#'
#' Produces a standard set of wagebill indicators in one call: how much
#' government spends on pay, where that spending goes, how average pay
#' evolves, what pay is made of, and how pay is distributed. Each indicator
#' comes from an existing govhr function, so the results match what those
#' functions return on their own.
#'
#' @param contracts Data frame or remote database table (`tbl_dbi`) with the
#'   contract data, one row per contract and reference date. Must contain
#'   `personnel_id`, `ref_date`, `est_id`, and the columns named in
#'   `measure_col` and `wage_component_cols`, with pay in nominal local
#'   currency.
#' @param personnel Data frame or remote database table (`tbl_dbi`) with the
#'   personnel data. Must contain `personnel_id`, `ref_date` and
#'   `employment_status` (with `"active"` marking people currently employed).
#'   For database input, it must live in the same database as `contracts`.
#' @param establishment Data frame or remote database table (`tbl_dbi`) with
#'   the establishment data. Must contain `est_id` and `country_code`, used
#'   to pick the consumer price index for each contract. For database input,
#'   it must live in the same database as `contracts`.
#' @param binwidth Positive whole number. Width of the pay bins used for the
#'   wage distribution, in the same currency as `measure_col` (for example
#'   `1e6` for wages in the millions). Default `NULL` picks a width from the
#'   data, as described in [compute_percentile()].
#' @param measure_col Character. Pay column used for totals, averages and the
#'   distribution. Default `"gross_salary_lcu"`.
#' @param wage_component_cols Character vector of pay columns that add up to
#'   total pay, used for the composition of the wagebill. Default
#'   `c("base_salary_lcu", "allowance_lcu")`.
#' @param base_month The month whose prices pay is expressed in, given as its
#'   first day (for example `"2021-12-01"`). Passed to [deflate_to_real()].
#'   Default `"2021-12-01"`.
#'
#' @returns A named list of tables:
#' \describe{
#'   \item{wagebill}{Wagebill and its growth for each `ref_date`, from
#'     [compute_wagebill()].}
#'   \item{wagebill_by_est}{Wagebill, share of the total and growth for each
#'     establishment and `ref_date`, from [compute_wagebill()].}
#'   \item{wage}{Average wage and its growth for each `ref_date`, from
#'     [compute_wage()].}
#'   \item{wage_by_est}{Average wage and its growth for each establishment
#'     and `ref_date`, from [compute_wage()].}
#'   \item{composition}{Wagebill, share and growth of each pay component
#'     (`component`) for each `ref_date`, from [compute_wagebill()].}
#'   \item{distribution}{Share of contracts in each pay bin, from
#'     [compute_percentile()].}
#' }
#' Each table has the class its function returns for `contracts`: data.tables
#' for data frame input, lazy tables for `tbl_dbi` input (use
#' [dplyr::collect()] to bring them into memory).
#'
#' @details
#' Only the pay of active personnel is counted: each contract is matched to
#' `personnel` by `personnel_id` and `ref_date`, and kept only if
#' `employment_status` is `"active"` on that date. Contracts with no matching
#' personnel record are left out.
#'
#' All pay is in real terms, so it can be compared across years: the columns
#' in `measure_col` and `wage_component_cols` are converted to constant prices
#' of `base_month` with [deflate_to_real()], using the country of each
#' contract's establishment. Column names are kept as they are. Contracts in
#' an establishment missing from `establishment` have no country, so their pay
#' becomes `NA`, with a warning.
#'
#' Each indicator function picks the method for the class of the data, so a
#' database table is processed in the database. Only the distinct countries
#' and reference dates are brought into memory, to look up their price index.
#'
#' In `composition`, each component's share is of the sum of
#' `wage_component_cols`, so the shares add up to 1 within each `ref_date`.
#'
#' The `distribution` pools contracts from all reference dates. Filter `data`
#' to one date first to see a single year.
#'
#' @examples
#' contracts <- data.frame(
#'   personnel_id = c(1, 2, 3, 1, 2, 3),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
#'   est_id = c("A", "A", "B", "A", "B", "B"),
#'   base_salary_lcu = c(800, 900, 1000, 850, 950, 1100),
#'   allowance_lcu = c(200, 100, 300, 250, 150, 200)
#' )
#' contracts$gross_salary_lcu <- contracts$base_salary_lcu + contracts$allowance_lcu
#'
#' personnel <- data.frame(
#'   personnel_id = c(1, 2, 3, 1, 2, 3),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
#'   employment_status = c("active", "active", "active", "active", "active", "pensioner")
#' )
#'
#' establishment <- data.frame(est_id = c("A", "B"), country_code = "BRA")
#'
#' compute_wagebill_analytics(contracts, personnel, establishment)
#'
#' @importFrom dplyr all_of mutate select union_all
#' @importFrom purrr map reduce
#' @export
compute_wagebill_analytics <- function(
  contracts,
  personnel,
  establishment,
  binwidth = NULL,
  measure_col = "gross_salary_lcu",
  wage_component_cols = c("base_salary_lcu", "allowance_lcu"),
  base_month = "2021-12-01"
){
  pay_cols <- unique(c(measure_col, wage_component_cols))

  check_required_cols(
    contracts,
    c("personnel_id", "ref_date", "est_id", pay_cols),
    arg = "contracts"
  )
  check_required_cols(
    personnel,
    c("personnel_id", "ref_date", "employment_status"),
    arg = "personnel"
  )
  check_required_cols(
    establishment,
    c("est_id", "country_code"),
    arg = "establishment"
  )

  data <- contracts |>
    keep_active_contracts(personnel) |>
    add_country_code(establishment) |>
    deflate_pay_cols(pay_cols, base_month = base_month)

  # 1. wagebill and its growth: overall and by establishment
  wagebill <- compute_wagebill(data, measure_col = measure_col)
  wagebill_by_est <- compute_wagebill(
    data,
    measure_col = measure_col,
    group_cols = "est_id"
  )

  # 2. average wage and its growth: overall and by establishment
  wage <- compute_wage(data, measure_col = measure_col)
  wage_by_est <- compute_wage(
    data,
    measure_col = measure_col,
    group_cols = "est_id"
  )

  # 3. wage composition: one wagebill per pay component, stacked into a long
  # table. union_all() rather than bind_rows(), which does not accept database
  # tables
  wage_composition <- wage_component_cols |>
    purrr::map(
      \(component_col) compute_wagebill(data, measure_col = component_col) |>
        mutate(component = component_col)
    ) |>
    purrr::reduce(union_all) |>
    mutate(
      share_wagebill = wagebill / sum(wagebill, na.rm = TRUE),
      .by = all_of("ref_date")
    ) |>
    select(
      all_of(c(
        "ref_date", "component", "wagebill", "share_wagebill", "wagebill_growth"
      ))
    )

  # 4. distribution of pay, pooled over all reference dates
  distribution <- compute_percentile(
    data,
    measure_col = measure_col,
    binwidth = binwidth
  )

  list(
    wagebill = wagebill,
    wagebill_by_est = wagebill_by_est,
    wage = wage,
    wage_by_est = wage_by_est,
    composition = wage_composition,
    distribution = distribution
  )
}

# add each contract's country from the establishment module, matched on
# est_id only, so a gap in the establishment's dates does not lose its country
#' @importFrom dplyr across all_of any_of collect count distinct filter
#'   left_join select
#' @importFrom rlang .data
#' @keywords internal
#' @noRd
add_country_code <- function(contracts, establishment){
  countries <- establishment |>
    select(all_of(c("est_id", "country_code"))) |>
    distinct()

  multi_country <- countries |>
    count(across(all_of("est_id"))) |>
    filter(.data[["n"]] > 1) |>
    collect()

  if(nrow(multi_country) > 0){
    stop(
      "`establishment` gives more than one `country_code` for est_id: ",
      paste(utils::head(multi_country$est_id, 10), collapse = ", ")
    )
  }

  # the country comes from the establishment module, so drop any copy in
  # contracts
  with_country <- contracts |>
    select(-any_of("country_code")) |>
    left_join(countries, by = "est_id")

  no_country <- with_country |>
    filter(is.na(.data[["country_code"]])) |>
    distinct(across(all_of("est_id"))) |>
    collect()

  if(nrow(no_country) > 0){
    warning(
      nrow(no_country), " est_id(s) in `contracts` are missing from ",
      "`establishment`, so their pay cannot be deflated and becomes NA: ",
      paste(utils::head(no_country$est_id, 10), collapse = ", "),
      if(nrow(no_country) > 10) ", ..."
    )
  }

  with_country
}

# convert pay columns to constant prices of base_month with deflate_to_real().
# deflate_to_real() runs in R, so it is applied to the distinct countries and
# dates only (a small table), and the resulting deflators are joined back. This
# keeps a database table in the database.
#' @importFrom dplyr across all_of collect distinct filter left_join mutate
#'   select
#' @importFrom rlang .data
#' @keywords internal
#' @noRd
deflate_pay_cols <- function(data, pay_cols, base_month){
  # rows with no country are left NA; add_country_code() already warned
  deflators <- data |>
    filter(!is.na(.data[["country_code"]])) |>
    distinct(across(all_of(c("country_code", "ref_date")))) |>
    collect() |>
    mutate(
      deflator = deflate_to_real(
        1,
        .data[["ref_date"]],
        .data[["country_code"]],
        base_month = base_month
      )
    )

  # copy_inline() sends the deflators as part of the query, so no write access
  # to the database is needed
  if(inherits(data, "tbl_dbi")){
    deflators <- dbplyr::copy_inline(dbplyr::remote_con(data), deflators)
  }

  data |>
    left_join(deflators, by = c("country_code", "ref_date")) |>
    mutate(across(all_of(pay_cols), \(pay) pay * .data[["deflator"]])) |>
    select(-all_of("deflator"))
}
