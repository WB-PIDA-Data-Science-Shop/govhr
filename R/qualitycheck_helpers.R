#' Flag outliers based on the IQR rule
#'
#' This function flags values in a numeric vector as outliers if they
#' fall below Q1 - 1.5 * IQR or above Q3 + 1.5 * IQR.
#'
#' @param x A numeric vector.
#'
#' @return A logical vector of the same length as `x`, where `TRUE`
#'   indicates the observation is an outlier.
#'
#' @examples
#' x <- c(1, 2, 2, 3, 4, 5, 100)
#' flag_outlier(x)
#' # Returns TRUE only for the value 100
#'
#' @export
flag_outlier <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1

  lower <- q1 - (1.5 * iqr)
  upper <- q3 + (1.5 * iqr)

  x < lower | x > upper
}

#' Compare the contents of two character vectors
#'
#' This function compares two vectors and identifies:
#' \itemize{
#'   \item Elements in `x` that are missing in `y`
#'   \item Elements in `y` that are missing in `x`
#' }
#' It returns both the raw differences and formatted HTML output for use
#' in reports, Shiny apps, or pointblank validation messages.
#'
#' Three output formats are supported:
#' \describe{
#'   \item{`"simple"`}{Colored comma-separated strings (HTML).}
#'   \item{`"bullet"`}{HTML unordered lists.}
#'   \item{`"badges"`}{Bootstrap-style colored badges.}
#' }
#'
#' @param x A vector of values to compare.
#' @param y A second vector of values to compare with `x`.
#' @param output_format Character string indicating the output format.
#'   Must be one of `"simple"`, `"bullet"`, or `"badges"`.
#'
#' @return A named list containing:
#' \describe{
#'   \item{`missing`}{Formatted HTML showing values in `x` but not in `y`.}
#'   \item{`extra`}{Formatted HTML showing values in `y` but not in `x`.}
#'   \item{`x_missing_y`}{Raw vector of elements in `x` but not in `y`.}
#'   \item{`y_missing_x`}{Raw vector of elements in `y` but not in `x`.}
#' }
#'
#' @examples
#' x <- c("a", "b", "c")
#' y <- c("b", "c", "d")
#'
#' compare_names_qc(x, y)
#' compare_names_qc(x, y, output_format = "bullet")
#' compare_names_qc(x, y, output_format = "badges")
#'
#' @export



compare_names_qc <- function(x, y, 
                             output_format = c("simple", "bullet", "badges")) {
  
  # match argument for output format
  output_format <- match.arg(output_format)
  
  # find differences
  x_missing_y <- setdiff(x, y) ## x but not y
  y_missing_x <- setdiff(y, x) ## y but not x
  
  # --- formatters -----------------------------------------------------------
  
  format_simple <- function(vec, empty_color = "green", color = "red") {
    if (length(vec) == 0) {
      sprintf("<span style='color:%s; font-weight:bold;'>None</span>", empty_color)
    } else {
      sprintf(
        "<span style='color:%s; font-weight:bold;'>%s</span>",
        color,
        paste(vec, collapse = ", ")
      )
    }
  }
  
  format_bullet <- function(vec) {
    if (length(vec) == 0) {
      "<span style='color:green; font-weight:bold;'>None</span>"
    } else {
      paste0(
        "<ul style='margin-left:0; padding-left:1em;'>",
        paste(sprintf("<li>%s</li>", vec), collapse = ""),
        "</ul>"
      )
    }
  }
  
  format_badges <- function(vec, empty_color = "#4caf50", color = "#d32f2f") {
    if (length(vec) == 0) {
      sprintf(
        "<span style='background:%s;color:white;padding:2px 6px;border-radius:4px;'>None</span>",
        empty_color
      )
    } else {
      sprintf(
        "<span style='background:%s;color:white;padding:2px 6px;border-radius:4px;'>%s</span>",
        color,
        paste(vec, collapse = ", ")
      )
    }
  }
  
  # --- choose output format -------------------------------------------------
  
  if (output_format == "simple") {
    missing_str <- format_simple(x_missing_y)
    extra_str   <- format_simple(y_missing_x, color = "orange")
    
  } else if (output_format == "bullet") {
    missing_str <- format_bullet(x_missing_y)
    extra_str   <- format_bullet(y_missing_x)
    
  } else if (output_format == "badges") {
    missing_str <- format_badges(x_missing_y, empty_color = "#4caf50", color = "#d32f2f")
    extra_str   <- format_badges(y_missing_x, empty_color = "#4caf50", color = "#ff9800")
  }
  
  # return a clean list
  mismatch_list <- list(missing = missing_str,
                        extra   = extra_str,
                        x_missing_y = x_missing_y,
                        y_missing_x = y_missing_x)
  
  return(mismatch_list)
  
}

add_pb_note <- function(agent, label) {
  specially(agent, fn = ~ TRUE, label = label)
}


