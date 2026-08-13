#' Compute the proportion of consistent records and values in a data frame.
#'
#' @param data A data frame.
#' @param id_col A character string specifying the name of the column that uniquely identifies records.
#' @param value_cols A character vector specifying the name(s) of columns whose values
#'   are to be checked for consistency. Value consistency is computed separately for
#'   each column and averaged across columns before being combined with record consistency.
#' @param digits An integer specifying the number of decimal places to round the result to. Default is 2.
#'
#' @import dplyr
#' @importFrom purrr map_dbl
#'
#' @return A numeric value representing the proportion of consistent records and values in the data frame.
#' @details Consistency is defined as the proportion of records and values that are consistent
#'   across the dataset. A record is considered consistent if it has a unique identifier and all
#'   its associated values are consistent. A value is considered consistent if it does not
#'   contradict other values for the same record.
#'
#' @export
#'
#' @examples
#' govhr::compute_global_consistency(
#'   data = govhr::bra_hrmis_personnel,
#'   id_col = "personnel_id",
#'   value_cols = c("birth_date")
#' )
#'
compute_global_consistency <- function(data, id_col, value_cols, digits = 2) {
  # don't round intermediate results, to avoid compounding rounding error in the average
  record_consistency <- compute_record_consistency(
    data,
    id_col,
    digits = 10
  ) |>
    dplyr::pull(.data[["record_consistency"]])

  value_consistency <- purrr::map_dbl(
    value_cols,
    \(value_col) {
      compute_value_consistency(
        data,
        id_col,
        value_col,
        digits = 10
      ) |>
        dplyr::pull(.data[["value_consistency"]])
    }
  ) |>
    mean(na.rm = TRUE)

  global_consistency <- mean(
    c(record_consistency, value_consistency),
    na.rm = TRUE
  )

  global_consistency |>
    round(digits)
}

#' Compute the proportion of consistent records in a data frame.
#'
#' @param data A data frame.
#' @param id_col A character string specifying the name of the column that uniquely identifies records (e.g., "personnel_id" or "contract_id").
#' @param group_cols A character vector specifying the names of the columns to group by. Default is NULL, which means no grouping.
#' @param digits An integer specifying the number of decimal places to round the result to. Default is 2.
#'
#' @import dplyr
#' @importFrom data.table as.data.table fifelse
#' @importFrom tibble as_tibble
#'
#' @return A data frame with the proportion of consistent records in the data frame, optionally by group.
#'
#' @details A record is considered consistent if it has a unique identifier and all its associated values are consistent.
#' The function computes the proportion of consistent records in the data frame, optionally grouped by specified columns.
#'
#' @export
#'
#' @examples
#' govhr::compute_record_consistency(
#'  data = govhr::bra_hrmis_personnel,
#'  id_col = "personnel_id",
#' )
#'
compute_record_consistency <- function(
  data,
  id_col,
  group_cols = NULL,
  digits = 2
) {
  if (!is.null(group_cols)) {
    group_cols <- as.character(unlist(group_cols))
  }

  group_cols_with_ref_date <- unique(
    c("ref_date", group_cols)
  )

  dt <- data.table::as.data.table(data)

  # count records per id_col + group_cols_with_ref_date combination
  count_cols <- c(id_col, group_cols_with_ref_date)
  record_consistency <- dt[,
    .(n = .N),
    by = count_cols
  ]
  record_consistency[, consistent_record := data.table::fifelse(n == 1, 1, 0)]

  # percentage of consistent records, by group
  if (is.null(group_cols)) {
    result <- record_consistency[,
      .(
        record_consistency = round(
          100 * sum(consistent_record, na.rm = TRUE) / .N,
          digits
        )
      )
    ]
  } else {
    result <- record_consistency[,
      .(
        record_consistency = round(
          100 * sum(consistent_record, na.rm = TRUE) / .N,
          digits
        )
      ),
      by = group_cols
    ]
  }

  tibble::as_tibble(result)
}

#' Compute the proportion of consistent values in a data frame.
#'
#' @param data A data frame.
#' @param id_col A character string specifying the name of the column that uniquely identifies records.
#' @param value_col A character string specifying the name of the column whose values are to be checked for consistency.
#' @param group_cols A character vector specifying the names of the columns to group by. Default is no grouping.
#' @param digits An integer specifying the number of decimal places to round the result to. Default is 2.
#'
#' @importFrom data.table as.data.table
#' @importFrom tibble as_tibble
#'
#' @return A data frame with the proportion of consistent values in the data frame, optionally by group.
#'
#' @details Consistency is broadly defined as the proportion of records and values that are consistent
#'   across the dataset. A value is considered consistent if it does not differ from
#'   other values for the same record. The function computes the proportion of records with consistent values
#'   in the data frame, optionally grouped by specified columns.
#'
#' @export
#'
#' @examples
#' govhr::compute_value_consistency(
#'  data = govhr::bra_hrmis_personnel,
#'  id_col = "personnel_id",
#'  value_col = "birth_date"
#' )
#'
compute_value_consistency <- function(
  data,
  id_col,
  value_col,
  group_cols = NULL,
  digits = 2
) {
  if (!is.null(group_cols)) {
    group_cols <- as.character(unlist(group_cols))
  }

  by_cols <- c(id_col, group_cols)

  dt <- data.table::as.data.table(data)[, c(by_cols, value_col), with = FALSE]

  value_consistency <- unique(dt, by = c(by_cols, value_col))[,
    .N,
    by = by_cols
  ]

  # percentage of records with exactly 1 distinct value, by group
  result <- value_consistency[,
    .(value_consistency = round(100 * mean(N == 1), digits)),
    by = group_cols
  ]

  tibble::as_tibble(result)
}
