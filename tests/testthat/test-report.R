# ---- generate_standard_report ------------------------------------------------
# Renders the report from a small dataset, so a broken template or a change in
# the analytics output is caught here rather than by users.

report_contracts <- data.frame(
  personnel_id = rep(1:3, each = 3),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
  est_id = c("A", "A", "A", "B", "B", "A", "A", "A", "B"),
  base_salary_lcu = c(800, 820, 850, 900, 950, 1000, 700, 720, 760),
  allowance_lcu = c(100, 100, 120, 200, 150, 150, 50, 60, 60)
)
report_contracts$gross_salary_lcu <-
  report_contracts$base_salary_lcu + report_contracts$allowance_lcu

report_personnel <- data.frame(
  personnel_id = rep(1:3, each = 3),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
  employment_status = c(
    "active", "active", "active",
    "inactive", "active", "active",
    "active", "active", "inactive"
  )
)

report_establishment <- data.frame(
  est_id = c("A", "B"),
  country_code = "BRA"
)

test_that("renders an HTML report with every section", {
  skip_if_not(rmarkdown::pandoc_available(), "pandoc is not available")

  output <- tempfile(fileext = ".html")
  on.exit(unlink(output))

  report <- generate_standard_report(
    report_contracts,
    report_personnel,
    report_establishment,
    binwidth = 100,
    output = output
  )

  expect_true(file.exists(output))
  expect_equal(normalizePath(report), normalizePath(output))

  html <- paste(readLines(output, warn = FALSE), collapse = "\n")
  for (section in c("Headcount", "Hires and separations", "Total wagebill", "Pay distribution")) {
    expect_match(html, section, fixed = TRUE)
  }
})

test_that("reports missing columns before rendering", {
  expect_error(
    generate_standard_report(
      report_contracts[c("personnel_id", "ref_date", "est_id")],
      report_personnel,
      report_establishment,
      binwidth = 100,
      output = tempfile(fileext = ".html")
    ),
    "missing required columns"
  )
})

test_that("renders a Word report", {
  skip_if_not(rmarkdown::pandoc_available(), "pandoc is not available")

  output <- tempfile(fileext = ".docx")
  on.exit(unlink(output))

  generate_standard_report(
    report_contracts,
    report_personnel,
    report_establishment,
    binwidth = 100,
    format = "docx",
    output = output
  )

  expect_true(file.exists(output))
})

test_that("names the default output after the format", {
  expect_equal(
    eval(formals(generate_standard_report)$output, list(format = "docx")),
    "standard_report.docx"
  )
})
