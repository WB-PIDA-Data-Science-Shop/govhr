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
#' data <- tibble(
#'   country_code = c("BRA","BRA"),
#'   ref_date = c("2010-01-01", "2021-01-01"),
#'   wage = c(20000, 25000)
#' )
#'
#' convert_constant_ppp(data, "wage")
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

#' Classify free-text items against a user-supplied taxonomy using TF-IDF
#'
#' @param corpus       A data.frame with at minimum an id column and a text column.
#' @param taxonomy     Either:
#'                       - A named character vector: names = class IDs, values = class labels/descriptions
#'                       - A data.frame with columns identified by `class_id_col` and `class_label_col`
#' @param id_col       Name of the id column in `corpus`. Default "id".
#' @param text_col     Name of the text column in `corpus`. Default "text".
#' @param class_id_col Name of the class ID column in `taxonomy` (if data.frame). Default "class_id".
#' @param class_label_col Name of the class label column in `taxonomy` (if data.frame). Default "class_label".
#' @param num_leaves   Number of top-matching classes to return per item. Default 1.
#' @param method       "tfidf_sum" (mirrors labourR) or "cosine" (improved, length-normalised). Default "tfidf_sum".
#' @param max_dist     Maximum string distance for fuzzy token matching (used when `string_dist` is set).
#' @param string_dist  String distance method passed to `stringdist::amatch()`. NULL disables fuzzy matching.
#' @param stopwords    Character vector of stopwords to remove. NULL uses a built-in English set.
#'
#' @return A data.table with columns: <id_col>, class_id, class_label, score
#' 
#' @importFrom rlang .data
#' 
classify_text <- function(corpus,
                          taxonomy,
                          id_col          = "id",
                          text_col        = "text",
                          class_id_col    = "class_id",
                          class_label_col = "class_label",
                          num_leaves      = 1,
                          method          = c("tfidf_sum", "cosine"),
                          max_dist        = 0.1,
                          string_dist     = NULL,
                          stopwords       = NULL) {

  method <- match.arg(method)

  # ── 0. Input validation ────────────────────────────────────────────────────
  if (!inherits(corpus, "data.frame"))
    stop("`corpus` must be a data.frame or data.table.")
  if (!all(c(id_col, text_col) %in% names(corpus)))
    stop(sprintf("`corpus` must contain columns '%s' and '%s'.", id_col, text_col))

  # ── 1. Normalise taxonomy to a data.table ─────────────────────────────────
  if (is.character(taxonomy) && !is.null(names(taxonomy))) {
    taxonomy_dt <- data.table(class_id = names(taxonomy), class_label = unname(taxonomy))
  } else if (inherits(taxonomy, "data.frame")) {
    if (!all(c(class_id_col, class_label_col) %in% names(taxonomy)))
      stop(sprintf("`taxonomy` must contain columns '%s' and '%s'.", class_id_col, class_label_col))
    taxonomy_dt <- as.data.table(taxonomy)
    setnames(taxonomy_dt, c(class_id_col, class_label_col), c("class_id", "class_label"))
  } else {
    stop("`taxonomy` must be a named character vector or a data.frame.")
  }

  # ── 2. Helpers ─────────────────────────────────────────────────────────────
  default_stopwords <- c(
    "a","an","the","and","or","of","in","to","for","with","on","at","by",
    "from","is","are","was","were","be","been","being","have","has","had",
    "do","does","did","will","would","could","should","may","might","shall",
    "can","that","this","it","its","as","not","but","if","so","up","out","into"
  )
  sw <- if (is.null(stopwords)) default_stopwords else stopwords

  cleanse <- function(x) {
    x <- tolower(trimws(x))
    x <- gsub("[^a-z0-9 ]", " ", x)
    gsub("\\s+", " ", x)
  }

  tokenize_dt <- function(texts, ids) {
    tokens <- strsplit(cleanse(texts), " ")
    names(tokens) <- ids
    tokens <- lapply(tokens, function(tk) tk[tk != "" & !tk %in% sw])
    rbindlist(lapply(tokens, data.table), idcol = "id") |>
      setnames(c("id", "term"))
  }

  # ── 3. Build TF-IDF index from taxonomy ───────────────────────────────────
  taxonomy_dt[, label_clean := cleanse(class_label)]

  # Term frequencies per class
  tax_tokens_dt <- tokenize_dt(taxonomy_dt$label_clean, taxonomy_dt$class_id)

  N_classes <- nrow(taxonomy_dt)

  tf_dt <- tax_tokens_dt[
    , .N, by = c("id", "term")
  ][
    , tf := N / sum(N), by = "id"          # within-class relative frequency
  ] |> setnames("id", "class_id")

  # IDF: log(N / document frequency)  — "document" = one taxonomy class
  idf_dt <- tf_dt[, .(df = .N), by = "term"][, idf := log(N_classes / df)]

  tfidf_dt <- merge(tf_dt, idf_dt, by = "term")[, tfidf := tf * idf]

  vocabulary <- sort(unique(tfidf_dt$term))

  # ── 4. Tokenize corpus ────────────────────────────────────────────────────
  corpus_dt <- as.data.table(corpus)
  setnames(corpus_dt, c(id_col, text_col), c("id", "text"))
  corpus_dt[, text := cleanse(text)]

  corpus_tokens_dt <- tokenize_dt(corpus_dt$text, corpus_dt$id)

  # ── 5. Token matching (exact + optional fuzzy) ────────────────────────────
  voca_idx <- match(corpus_tokens_dt$term, vocabulary)

  if (!is.null(string_dist)) {
    na_pos <- is.na(voca_idx)
    if (any(na_pos))
      voca_idx[na_pos] <- stringdist::amatch(
        corpus_tokens_dt$term[na_pos], vocabulary,
        maxDist = max_dist, method = string_dist
      )
  }

  matches_dt <- data.table(
    id   = corpus_tokens_dt$id,
    term = vocabulary[voca_idx]
  )[!is.na(term)]

  # ── 6. Score: TF-IDF sum (labourR-equivalent) or cosine similarity ────────
  if (method == "tfidf_sum") {

    # Sum TF-IDF weights of matching tokens per (corpus item, class) pair
    predictions <- merge(
      matches_dt,
      tfidf_dt[, .(term, class_id, tfidf)],
      by = "term", allow.cartesian = TRUE
    )[, .(score = sum(tfidf)), by = .(id, class_id)
    ][order(id, -score)
    ][, head(.SD, num_leaves), by = "id"]

  } else {  # cosine

    # Build a TF-IDF vector for the corpus side using the same IDF
    corpus_tf <- matches_dt[, .N, by = .(id, term)]
    corpus_tf[, tf := N / sum(N), by = "id"]
    corpus_tfidf <- merge(corpus_tf, idf_dt[, .(term, idf)], by = "term")[, tfidf := tf * idf]

    # Dot product
    dot_dt <- merge(
      corpus_tfidf[, .(id, term, tfidf_c = tfidf)],
      tfidf_dt[, .(term, class_id, tfidf_t = tfidf)],
      by = "term", allow.cartesian = TRUE
    )[, .(dot = sum(tfidf_c * tfidf_t)), by = .(id, class_id)]

    # L2 norms
    corpus_norm <- corpus_tfidf[, .(norm_c = sqrt(sum(tfidf^2))), by = "id"]
    class_norm  <- tfidf_dt[,    .(norm_t = sqrt(sum(tfidf^2))), by = "class_id"]

    predictions <- dot_dt |>
      merge(corpus_norm, by = "id") |>
      merge(class_norm,  by = "class_id")

    predictions[, score := dot / (norm_c * norm_t)
    ][order(id, -score)
    ][, head(.SD, num_leaves), by = "id"
    ][, .(id, class_id, score)]
  }

  # ── 7. Attach taxonomy labels and restore original id column name ──────────
  result <- merge(
    predictions,
    taxonomy_dt[, .(class_id, class_label)],
    by = "class_id"
  )[order(id)
  ] |> setnames("id", id_col)

  result[]
}

#' Sample groups and return all rows for those groups
#'
#' sample_group() randomly samples a specified number of unique values from a
#' grouping column and returns all rows belonging to the sampled groups.
#'
#' @param .data A data.frame, tibble, or data.table.
#' @param group Unquoted column name used to define groups.
#' @param n Integer; number of distinct groups to sample. If greater than the
#'   number of available groups, all groups are returned.
#'
#' @return An object of the same class as `.data` (tibble -> tibble,
#'   data.table -> data.table, data.frame -> data.frame) containing only rows
#'   whose group value was sampled.
#'
#' @examples
#' df <- tibble::tibble(id = 1:8, grp = rep(letters[1:4], each = 2))
#' sample_group(df, grp, 2)
#'
#' @export
#' @importFrom data.table as.data.table is.data.table
#' @importFrom rlang ensym as_string
#' @importFrom tibble is_tibble as_tibble
sample_group <- function(.data, group, n) {
  dt <- data.table::as.data.table(.data)
  group_sym <- rlang::ensym(group)
  group_col <- rlang::as_string(group_sym)

  uniq_vals <- unique(dt[[group_col]])
  if (length(uniq_vals) == 0 || as.integer(n) <= 0) {
    return(dt[0]) # empty result with same cols (data.table)
  }

  n_draw <- min(length(uniq_vals), as.integer(n))
  sampled_vals <- sample(uniq_vals, size = n_draw)

  res_dt <- dt[get(group_col) %in% sampled_vals]

  # return in same "type" the user passed: tibble -> tibble, data.frame -> data.frame, data.table -> data.table
  if (tibble::is_tibble(.data)) {
    tibble::as_tibble(res_dt)
  } else if (data.table::is.data.table(.data)) {
    res_dt
  } else {
    as.data.frame(res_dt)
  }
}

#' Convert Data to Match Original Class
#'
#' Converts a dataset to have the same class as another reference dataset.
#' This is useful for ensuring consistent output formats when performing
#' operations that temporarily convert data structures (e.g., between
#' `data.table`, `data.frame`, or `tibble`).
#'
#' @param data A dataset to be converted. Typically a `data.table` or `data.frame`.
#' @param data_original The original dataset whose class should be matched.
#'
#' @return The input \code{data} converted to the same class as \code{data_original}.
#'
#' @details
#' The function checks the class of \code{data_original} in the following order:
#' \itemize{
#'   \item If it is a tibble (`tbl_df`), \code{data} is converted using
#'     \code{tibble::as_tibble()}.
#'   \item If it is a base data frame but not a data.table, \code{data} is converted
#'     using \code{as.data.frame()}.
#'   \item Otherwise, \code{data} is returned unchanged (e.g., for data.table input).
#' }
#'
#' @examples
#' \dontrun{
#' df <- data.frame(x = 1:3)
#' dt <- data.table::as.data.table(df)
#'
#' # Convert dt back to data.frame to match df
#' convert_data(dt, df)
#'
#' # Convert to tibble if original was tibble
#' convert_data(dt, tibble::as_tibble(df))
#' }
#'
#' @importFrom tibble as_tibble
#'
convert_data <- function(data, data_original) {
  if ("tbl_df" %in% class(data_original)) {
    data <- tibble::as_tibble(data)
  } else if (
    "data.frame" %in%
      class(data_original) &&
      !"data.table" %in% class(data_original)
  ) {
    data <- as.data.frame(data)
  }
  return(data)
}

#' Guess the Reporting Frequency of the Reference Dates
#'
#' Evaluates a vector of reference dates and returns a single
#' string representing the data's reporting interval (e.g., "year", "month").
#' The function calculates the median day difference between consecutive dates.
#'
#' @param .data A dataset containing a column named \code{ref_date} with date values.
#'
#' @return A single character scalar: \code{"year"}, \code{"quarter"},
#'   \code{"month"}, \code{"week"}, or \code{"day"}.
#'
#' @export
#'
#' @examples
#' # Monthly reporting dates
#' data <- data.frame(
#'  ref_date = seq(as.Date("2020-01-01"), as.Date("2020-12-01"), by = "months")
#' )
#'
#' guess_date_frequency(data)
#' #> [1] "month"
#' @importFrom stats median
guess_date_frequency <- function(.data) {
  ref_date <- .data[["ref_date"]] |>
    unique() |>
    sort()

  median_days <- median(diff(as.Date(ref_date)), na.rm = TRUE)

  if (median_days >= 360) {
    return("year")
  }
  if (median_days >= 80) {
    return("quarter")
  }
  if (median_days >= 27) {
    return("month")
  }
  if (median_days >= 6) {
    return("week")
  }
  return("day")
}