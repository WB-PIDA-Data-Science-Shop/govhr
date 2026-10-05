#' Generate the standard HR report
#'
#' Produces an HTML report with the standard workforce and wagebill
#' indicators: headcount, hires and separations, moves between
#' establishments, the wagebill and its growth, average wages, and the
#' composition and distribution of pay.
#'
#' @param contracts Data frame or remote database table (`tbl_dbi`) with the
#'   contract data, one row per contract and reference date. Must contain
#'   `personnel_id`, `ref_date`, `est_id`, `gross_salary_lcu`,
#'   `base_salary_lcu` and `allowance_lcu`.
#' @param personnel Data frame or remote database table (`tbl_dbi`) with the
#'   personnel data. Must contain `personnel_id`, `ref_date` and
#'   `employment_status`. For database input, it must live in the same
#'   database as `contracts`.
#' @param binwidth Positive whole number. Width of the pay bins in the wage
#'   distribution, in the same currency as the pay columns. See
#'   [compute_wagebill_analytics()].
#' @param output Character. Path of the HTML file to create. Default
#'   `"standard_report.html"`, in the working directory.
#'
#' @returns The path to the report, invisibly.
#'
#' @details
#' The indicators are computed by [compute_workforce_analytics()] and
#' [compute_wagebill_analytics()], so the report shows the same numbers those
#' functions return. Database tables are processed in the database, and only
#' the results are brought into memory.
#'
#' Employment status comes from `personnel` and is matched to `contracts` by
#' `personnel_id` and `ref_date`.
#'
#' Pay is used as given. To compare pay across years, convert it to real
#' terms first, for example with [deflate_to_real()].
#'
#' @examples
#' \dontrun{
#' generate_standard_report(
#'   contracts = bra_hrmis_contract,
#'   personnel = bra_hrmis_personnel,
#'   binwidth = 1000,
#'   output = "brazil_report.html"
#' )
#' }
#'
#' @importFrom dplyr all_of collect distinct left_join select
#' @export
generate_standard_report <- function(
  contracts,
  personnel,
  binwidth,
  output = "standard_report.html"
) {
  # establishments and pay come from the contracts, employment status from
  # the personnel data
  employment_status <- personnel |>
    select(all_of(c("personnel_id", "ref_date", "employment_status"))) |>
    distinct()

  workforce_data <- contracts |>
    left_join(employment_status, by = c("personnel_id", "ref_date"))

  # compute everything here, so the template only draws. collect() brings
  # database results into memory and leaves data frames unchanged
  workforce <- compute_workforce_analytics(workforce_data) |>
    purrr::map(collect)
  wagebill <- compute_wagebill_analytics(contracts, binwidth = binwidth) |>
    purrr::map(collect)

  # render a copy of the template, since the folder of an installed package
  # may be read-only
  render_dir <- tempfile("govhr_report_")
  dir.create(render_dir)
  on.exit(unlink(render_dir, recursive = TRUE), add = TRUE)

  template <- file.path(render_dir, "standard_report.Rmd")
  file.copy(
    system.file("templates", "standard_report.Rmd", package = "govhr"),
    template
  )

  output_dir <- dirname(normalizePath(output, mustWork = FALSE))

  report <- rmarkdown::render(
    input = template,
    output_file = basename(output),
    output_dir = output_dir,
    params = list(workforce = workforce, wagebill = wagebill),
    envir = new.env(),
    quiet = TRUE
  )

  invisible(report)
}
