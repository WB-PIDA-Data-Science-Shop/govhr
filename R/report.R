#' Generate the standard HR report
#'
#' Produces an HTML or Word report with the standard workforce and wagebill
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
#' @param establishment Data frame or remote database table (`tbl_dbi`) with
#'   the establishment data. Must contain `est_id` and `country_code`. For
#'   database input, it must live in the same database as `contracts`.
#' @param binwidth Positive whole number. Width of the pay bins in the wage
#'   distribution, in the same currency as the pay columns. Default `NULL`
#'   picks a width from the data. See [compute_wagebill_analytics()].
#' @param base_month The month whose prices pay is expressed in, given as its
#'   first day. Default `"2021-12-01"`. See [compute_wagebill_analytics()].
#' @param format Character. `"html"` (default) for an HTML report or
#'   `"docx"` for a Word document. In Word, the network of transitions is a
#'   static image rather than an interactive chart.
#' @param output Character. Path of the file to create. Default
#'   `"standard_report.html"` or `"standard_report.docx"`, depending on
#'   `format`, in the working directory.
#'
#' @returns The path to the report, invisibly.
#'
#' @details
#' The indicators are computed by [compute_workforce_analytics()] and
#' [compute_wagebill_analytics()], so the report shows the same numbers those
#' functions return. Database tables are processed in the database, and only
#' the results are brought into memory.
#'
#' Only active personnel are counted: employment status comes from
#' `personnel` and is matched to `contracts` by `personnel_id` and `ref_date`.
#' Pay is converted to constant prices of `base_month` with
#' [deflate_to_real()], using the country of each contract's establishment.
#'
#' @examples
#' \dontrun{
#' generate_standard_report(
#'   contracts = bra_hrmis_contract,
#'   personnel = bra_hrmis_personnel,
#'   establishment = bra_hrmis_est,
#'   output = "brazil_report.html"
#' )
#'
#' # the same report as a Word document
#' generate_standard_report(
#'   contracts = bra_hrmis_contract,
#'   personnel = bra_hrmis_personnel,
#'   establishment = bra_hrmis_est,
#'   format = "docx"
#' )
#' }
#'
#' @export
generate_standard_report <- function(
  contracts,
  personnel,
  establishment,
  binwidth = NULL,
  base_month = "2021-12-01",
  format = c("html", "docx"),
  output = paste0("standard_report.", format)
) {
  format <- match.arg(format)

  workforce <- compute_workforce_analytics(contracts, personnel)

  wagebill <- compute_wagebill_analytics(
    contracts,
    personnel,
    establishment,
    binwidth = binwidth,
    base_month = base_month
  )

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

  output_format <- switch(
    format,
    html = rmarkdown::html_document(toc = TRUE),
    docx = rmarkdown::word_document(toc = TRUE)
  )

  report <- rmarkdown::render(
    input = template,
    output_format = output_format,
    output_file = basename(output),
    output_dir = output_dir,
    params = list(workforce = workforce, wagebill = wagebill),
    envir = new.env(),
    quiet = TRUE
  )

  invisible(report)
}
