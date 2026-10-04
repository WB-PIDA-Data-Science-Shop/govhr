drop_missing <- function(data, cols){
  conditions <- lapply(
    rlang::syms(cols),
    function(col) rlang::expr(!is.na(!!col))
  )

  data |>
    filter(!!!conditions)
}

build_calendar <- function(data) {
  calendar <- data |>
    distinct(ref_date) |>
    mutate(
      prev_date = lag(ref_date, order_by = ref_date),
      next_date = lead(ref_date, order_by = ref_date)
    )

  calendar
}