################################################################################
## Functions to support harmonization of HRMIS data
################################################################################
#' Identify inconsistent column names across data frames
#'
#' This function checks for consistency in column names across a list of data frames.
#' It returns the symmetric difference between the shared columns (those present in all data frames)
#' and the union of all column names (those present in any data frame).
#'
#' @param data_list A list of data frames to check.
#'
#' @return A character vector of column names that are not shared across all data frames.
#' These are the inconsistent or unique column names that appear in only some of the data frames.
#'
#' @examples
#' df1 <- data.frame(a = 1, b = 2)
#' df2 <- data.frame(a = 3, c = 4)
#' df_list <- list(df1, df2)
#' find_inconsistent_colnames(df_list)
#' # Returns: "b" "c"
#'
#' @importFrom tibble tibble
#' @importFrom dplyr intersect union symdiff
#' @export
find_inconsistent_colnames <- function(data_list) {
  shared_cols <- data_list |>
    purrr::map(\(data) tibble::tibble(colnames = colnames(data))) |>
    purrr::reduce(dplyr::intersect)

  all_cols <- data_list |>
    purrr::map(\(data) tibble::tibble(colnames = colnames(data))) |>
    purrr::reduce(dplyr::union)

  dplyr::symdiff(shared_cols, all_cols)
}

#' Detect Inconsistent Columns in a Data Frame
#'
#' This function checks whether any of the specified column names appear in a given data frame.
#' It is typically used to identify the presence of inconsistent or unexpected column names across multiple data frames.
#'
#' @param data A data frame to inspect.
#' @param inconsistent_cols A character vector of column names considered inconsistent.
#'
#' @return A logical value: `TRUE` if any inconsistent columns are present in the data frame, `FALSE` otherwise.
#'
#' @examples
#' df <- data.frame(a = 1:3, b = 4:6)
#' detect_inconsistent_cols(df, c("c", "d")) # returns FALSE
#' detect_inconsistent_cols(df, c("a", "c")) # returns TRUE
#'
#' @importFrom dplyr select if_else any_of
#' 
#' @export
detect_inconsistent_cols <- function(data, inconsistent_cols) {
  n_inconsistent_cols <- data |>
    dplyr::select(dplyr::any_of(inconsistent_cols)) |>
    ncol()

  dplyr::if_else(n_inconsistent_cols > 0, TRUE, FALSE)
}

#' Harmonize column names based on a dictionary
#'
#' This function standardizes column names in a data frame using a dictionary
#' that maps inconsistent or time-varying column names to a standardized set of column names.
#'
#' @param data A data frame whose columns need to be renamed.
#' @param dictionary Either a named character vector (names are the desired standardized
#'   column names and values are the original column names), or a data frame with
#'   two columns: `from` (original column names) and `to` (standardized names).
#'
#' @return A data frame with harmonized column names.
#'
#' @examples
#' # Using a named character vector
#' dict <- c("age" = "Q1_age", "gender" = "Q2_sex", "income" = "Q3_income")
#' df <- data.frame(Q1_age = 25, Q2_sex = "M", Q3_income = 50000)
#' harmonize_columns(df, dict)
#'
#' # Using a data frame dictionary
#' dict_df <- data.frame(
#'   from = c("Q1_age", "Q2_sex", "Q3_income"),
#'   to = c("age", "gender", "income")
#' )
#' harmonize_columns(df, dict_df)
#'
#' @import dplyr
#' @importFrom purrr set_names
#' @importFrom rlang !!!
#' @export
harmonize_columns <- function(data, dictionary) {
  # If a data frame is supplied as dict, convert to named vector
  if (is.data.frame(dictionary)) {
    dictionary <- set_names(dictionary$from, dictionary$to)
  }

  # Only include dict entries whose values are actual column names
  available_dictionary <- dictionary[dictionary %in% names(data)]

  # Rename using dplyr::rename and !!! unquoting for tidy evaluation
  data_renamed <- data |>
    dplyr::rename(!!!set_names(available_dictionary, names(available_dictionary))) |>
    select(any_of(names(available_dictionary)))

  return(data_renamed)
}

#' Find Duplicate Identifiers in a Data Frame
#'
#' Identifies duplicated values of a specified identifier column in a data frame or tibble.
#' Returns a tibble with the identifier values that appear more than once and their counts.
#'
#' @param data A data frame or tibble.
#' @param identifier The column to check for duplicates. This should be passed as a bare (unquoted) column name using tidy evaluation.
#'
#' @return A tibble with the identifier column and a count column `n` indicating the number of times each duplicate appears.
#'
#' @importFrom dplyr count filter
#'
#' @examples
#' library(dplyr)
#' library(tibble)
#'
#' df <- tibble(id = c(1, 2, 2, 3, 3, 3, 4))
#' find_duplicate_ids(df, id)
#'
#' @export
find_duplicate_ids <- function(data, identifier) {
  data |>
    count({{ identifier }}) |>
    filter(n > 1)
}

#' Deduplicate and disambiguate an attribute using both lag and lead values
#'
#' Handles missing values and cases where the same date has conflicting
#' attribute values by inferring from the closest neighbor (lag first, then lead).
#'
#' @param data A data frame.
#' @param id_col Unique identifier column (unquoted).
#' @param attr_col Attribute to disambiguate (unquoted).
#' @param date_col Date column for ordering (unquoted).
#'
#'
#' @return A deduplicated data frame with attribute filled from neighbors when missing or conflicting.
#' @examples
#' library(tibble)
#'
#' df <- tibble(
#'   personnel_id = c(1, 1, 1, 2, 2, 2, 2),
#'   gender    = c(NA, "M", "F", "F", NA, "M", "F"),
#'   ref_date  = as.Date(c(
#'     "2023-01-01", "2023-01-02", "2023-01-02",
#'     "2023-01-01", "2023-01-02", "2023-01-03", "2023-01-03"
#'   ))
#' )
#'
#' dedup_value_panel(df, gender, personnel_id, ref_date)
#'
#' @import dplyr
#' @export
dedup_value_panel <- function(data, attr_col, id_col, date_col) {
  # extract first value if the values are unique
  data <- data |>
    arrange({{ id_col }}, {{ date_col }}) |>
    group_by({{ id_col }}, {{ date_col }}) |>
    mutate(n_records = n_distinct({{ attr_col }}))

  data_resolved <- data |>
    filter(n_records == 1) |>
    group_by({{ id_col }}, {{ date_col }}) |>
    summarise({{ attr_col }} := first({{ attr_col }}))

  data |>
    arrange({{ id_col }}, {{ date_col }}) |>
    group_by({{ id_col }}) |>
    mutate(lag_val  = lag({{ attr_col }}), lead_val = lead({{ attr_col }})) |>
    filter(n_records > 1) |>
    group_by({{ id_col }}, {{ date_col }}) |>
    summarise({{ attr_col }} := first(
      case_when(
        !is.na(lag_val) ~ lag_val,
        is.na(lag_val) & !is.na(lead_val) ~ lead_val,
        TRUE ~ {{ attr_col }}
      )
    )) |>
    ungroup() |>
    bind_rows(data_resolved) |>
    arrange({{ id_col }}, {{ date_col }})
}

#' Deduplicate values within grouped data
#'
#' This function deduplicates values within groups defined by a combination
#' of identifier and date columns. It provides three strategies:
#' \enumerate{
#'   \item \code{"mode"}: returns the most frequent (modal) value in the group.
#'   \item \code{"first"}: returns the first value in the group, even if \code{NA}.
#'   \item \code{"first_nonmissing"}: returns the first non-missing value in the group.
#' }
#'
#' @param data A data frame or tibble containing the data to deduplicate.
#' @param id_col Column name identifying the grouping unit (e.g., individual, firm).
#' @param date_col Column name identifying the date or time grouping variable.
#' @param value_col Column name containing the values to deduplicate.
#' @param method A string specifying the deduplication method.
#'   Must be one of \code{"mode"}, \code{"first"}, or \code{"first_nonmissing"}.
#'
#' @details
#' For \code{method = "mode"}, ties are broken arbitrarily by selecting the
#' first encountered maximum. Missing values are ignored when computing the mode.
#'
#' @return A tibble with one row per unique combination of \code{id_col} and \code{date_col},
#' containing the deduplicated \code{value_col}.
#'
#' @examples
#' library(dplyr)
#'
#' df <- tibble(
#'   id = c(1,1,1, 2,2,2, 3,3,3),
#'   date = c("2020-01","2020-01","2020-01",
#'            "2020-02","2020-02","2020-02",
#'            "2021-01","2021-01","2021-01"),
#'   gender = c("M","M","F", NA,"F","M", "M","F",NA)
#' )
#'
#' dedup_values(df, id, date, gender, method = "mode")
#' dedup_values(df, id, date, gender, method = "first")
#' dedup_values(df, id, date, gender, method = "first_nonmissing")
#'
#' @import dplyr
#'
#' @export
dedup_values <- function(data,
                         id_col,
                         date_col,
                         value_col,
                         method = c("mode", "first", "first_nonmissing")) {
  method <- match.arg(method)

  if (method == "mode") {
    # Mode-based deduplication using count()
    data |>
      group_by({{id_col}}, {{date_col}}, {{value_col}}) |>
      summarise(n = n(), .groups = "drop_last") |>
      filter(!is.na({{value_col}})) |>
      slice_max(order_by = n, with_ties = FALSE) |>
      select(-n) |>
      ungroup()

  } else if (method == "first") {
    data |>
      group_by({{id_col}}, {{date_col}}) |>
      summarise({{value_col}} := first({{value_col}}), .groups = "drop")

  } else if (method == "first_nonmissing") {
    data |>
      group_by({{id_col}}, {{date_col}}) |>
      summarise({{value_col}} := first(na.omit({{value_col}})), .groups = "drop")
  }
}

#' Complete columns in a dataframe
#'
#' If any column in `cols` is missing from `data`, this function adds it
#' and populates it with NA values.
#'
#' @param data A data frame or tibble.
#' @param cols A character vector of column names to check.
#'
#' @return A tibble with all requested columns, missing ones filled with NA.
#'
#' @examples
#' library(tibble)
#'
#' df <- tibble(a = 1:3, b = letters[1:3])
#' complete_columns(df, c("a", "b", "c"))
#'
#' @importFrom purrr set_names
#' @import dplyr
#' @export
complete_columns <- function(data, cols) {
  missing_cols <- setdiff(cols, names(data))

  if (length(missing_cols) > 0) {
    data <- data |>
      mutate(
        !!!set_names(rep(list(NA), length(missing_cols)), missing_cols)
      )
  }

  # reorder columns
  data <- data |>
    select(
      all_of(cols)
    )

  return(data)
}

#' Convert nominal wages to real PPP-adjusted wages (2021 base year)
#'
#' Convert nominal wages (LCU at survey-year prices) into real wages expressed
#' in 2021 PPP international dollars using:
#' \deqn{Real_{h}^{PPP} = (CPI_t / CPI_{2021}) * (Nominal_{h,t} / PPP_{2021})}
#'
#' #' @details
#' CPI data is sourced from [govhr::macro_indicators], which must contain
#' columns \code{country_code}, \code{year}, and \code{cpi}.
#'
#' @param data Data frame with columns (country_code, year, wage).
#' @param cols A character vector with column name to convert to constant PPP in international 2021 dollars.
#' @return `data_out` augmented with columns converted to international 2021 dollars.
#' @examples
#' library(tibble)
#' hh <- tibble(
#'   country_code = c("A","A"),
#'   year = c("2010", "2021"),
#'   wage = c(20000, 25000)
#' )
#'
#' macro_indicators <- tibble(
#'   country_code = "A", year = "2010", "2021",
#'   cpi = c(85, 100), ppp = c(1.5, 3.5)
#' )
#'
#' convert_constant_ppp(hh, "wage")
#'
#' @importFrom dplyr filter select rename left_join mutate
#' @import glue
#' @export
convert_constant_ppp <- function(data, cols) {

  ## Basic input checks
  required_df  <- c("country_code", "ref_date")

  if (!all(required_df %in% names(data))) {
    stop("`data` must contain columns: country_code, ref_date")
  }

  # extract CPI in base year (2021) by country
  base_cpi <- govhr::macro_indicators |>
    filter(year == 2021) |>
    select(country_code, cpi) |>
    rename(base_cpi = cpi)

  # join and compute using the exact formula
  data_out <- data |>
    mutate(
      year = as.integer(format(as.Date(ref_date), "%Y"))
    ) |>
    left_join(
      govhr::macro_indicators |> 
        select(country_code, year, cpi), 
      by = c("country_code", "year")
    ) |>
    left_join(base_cpi, by = "country_code") |>
    left_join(
      govhr::macro_indicators |>
        filter(year == 2021) |>
        select(country_code, ppp) |>
        rename(ppp_2021 = ppp),
      by = "country_code"
    ) |>
    mutate(
      across(
        all_of({{cols}}),
        ~ round((cpi / base_cpi) * (.x / ppp_2021), 2),
        .names = "{sub('_lcu$', '_ppp', .col)}"
      )
    ) |>
    select(-c(ppp_2021, base_cpi, year))

  return(data_out)
}

#' Deflate a nominal LCU column to real values
#'
#' Convert nominal wages (LCU prices) into real wages expressed in constant LCU prices of a specified base year using:
#' \deqn{\text{real} = \text{nominal} \times \frac{\text{CPI}_{base}}{\text{CPI}_{ref}}}
#'
#' @param col Numeric vector. The nominal LCU values to deflate (a data column).
#' @param ref_date A vector coercible to \code{Date} (or a \code{Date} column).
#'   The reference date for each observation; the year is extracted internally.
#' @param country_code Character. Either a scalar (e.g. \code{"MOZ"}) recycled
#'   across all rows, or a character column of ISO3 country codes.
#' @param base_year Integer scalar. The base year to deflate to. Defaults to
#'   \code{2021}.
#'
#' @return A numeric vector of the same length as \code{col}, expressed in
#'   constant \code{base_year} LCU prices. Returns \code{NA} for any row where
#'   CPI data is missing for the given country/year combination.
#'
#' @details
#' CPI data is sourced from [govhr::macro_indicators], which must contain
#' columns \code{country_code}, \code{year}, and \code{cpi}.
#'
#' @examples
#' library(dplyr)
#'
#' data <- tibble::tibble(
#'   country_code = c("MOZ", "MOZ", "BWA", "BWA"),
#'   survey_date  = as.Date(c("2019-06-01", "2020-03-15", "2021-09-01", "2022-11-30")),
#'   wage_lcu     = c(15000, 18000, 42000, 51000)
#' )
#'
#' # Scalar country code
#' data |>
#'   dplyr::mutate(wage_real = deflate_to_real(wage_lcu, survey_date, "MOZ"))
#'
#' # Country code from a column
#' data |>
#'   dplyr::mutate(wage_real = deflate_to_real(wage_lcu, survey_date, country_code))
#'
#' # Custom base year
#' data |>
#'   dplyr::mutate(wage_real = deflate_to_real(wage_lcu, survey_date, country_code, base_year = 2015))
#' 
#' @importFrom tibble tibble
#' @import dplyr
#' @export
deflate_to_real <- function(col, ref_date, country_code, base_year = 2021) {

  year <- as.integer(format(as.Date(ref_date), "%Y"))

  input_tbl <- tibble(
    country_code = country_code,
    year         = year,
    col          = col
  )

  cpi_lookup <- govhr::macro_indicators |>
    select(country_code, year, cpi)

  base_cpi_lookup <- govhr::macro_indicators |>
    filter(year == base_year) |>
    select(country_code, base_cpi = cpi)

  input_tbl |>
    left_join(cpi_lookup,      by = c("country_code", "year"), relationship = "many-to-one") |>
    left_join(base_cpi_lookup, by = "country_code",            relationship = "many-to-one") |>
    mutate(result = col * (.data[["base_cpi"]] / .data[["cpi"]])) |>
    pull(.data[["result"]])
}

merge_wrapper <- function(...){

  y <- merge(all.x = TRUE, ...)

  return(y)

}

