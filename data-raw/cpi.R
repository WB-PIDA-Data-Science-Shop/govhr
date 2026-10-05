## code to prepare `cpi` dataset goes here
# last updated: 10/4/2026

extract_cpi <- function(country_code = NULL, base_date = "2021-12-01"){
  # series key: country, CPI, all items (_T), index (IX), monthly (M). countries
  # are joined with "+", and "*" matches all of them
  country_key <- if(is.null(country_code)){
    "*"
  } else {
    paste(country_code, collapse = "+")
  }

  url <- paste0(
    "https://api.imf.org/external/sdmx/3.0/data/dataflow/IMF.STA/CPI/+/",
    country_key, ".CPI._T.IX.M"
  )

  cpi_raw <- httr2::request(url) |>
    httr2::req_headers(
      Accept = "application/vnd.sdmx.data+csv;version=2.0.0"
    ) |>
    httr2::req_timeout(300) |>
    httr2::req_retry(max_tries = 5) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    I() |>
    readr::read_csv(
      col_types = readr::cols(.default = readr::col_character())
    )

  missing_countries <- setdiff(country_code, cpi_raw$COUNTRY)
  if(length(missing_countries) > 0){
    warning(
      "No monthly CPI for ", paste(missing_countries, collapse = ", ")
    )
  }

  # series are padded with empty observations back to 1900
  cpi <- cpi_raw |>
    filter(
      !is.na(OBS_VALUE)
    ) |>
    transmute(
      ref_date = lubridate::ym(TIME_PERIOD),
      country_code = COUNTRY,
      cpi_national = as.numeric(OBS_VALUE),
      cpi_national_base_period = REFERENCE_PERIOD
    )

  base_date <- as.Date(base_date)

  # rebase each country to its observation closest to base_date, so that
  # countries with no CPI in base_date itself still get a `cpi`. on a tie,
  # the earlier month wins
  base_cpi <- cpi |>
    mutate(
      distance = abs(as.numeric(ref_date - base_date))
    ) |>
    arrange(country_code, distance, ref_date) |>
    distinct(country_code, .keep_all = TRUE) |>
    select(
      country_code,
      base_ref_date = ref_date,
      base_cpi = cpi_national
    )

  # these countries need to be listed in the `cpi` documentation in R/data.R
  rebased_elsewhere <- base_cpi |>
    filter(
      base_ref_date != base_date
    )
  if(nrow(rebased_elsewhere) > 0){
    message(
      "No CPI in ", format(base_date, "%Y-%m"), ", rebased to the closest month instead: ",
      paste(
        rebased_elsewhere$country_code,
        format(rebased_elsewhere$base_ref_date, "%Y-%m"),
        collapse = ", "
      )
    )
  }

  cpi |>
    left_join(
      base_cpi,
      by = "country_code"
    ) |>
    mutate(
      cpi = cpi_national / base_cpi * 100,
      .after = country_code
    ) |>
    select(-c(base_cpi, base_ref_date)) |>
    arrange(country_code, ref_date)
}

cpi <- extract_cpi()

usethis::use_data(cpi, overwrite = TRUE)
