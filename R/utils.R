drop_missing <- function(data, cols){
  conditions <- lapply(
    rlang::syms(cols),
    function(col) rlang::expr(!is.na(!!col))
  )

  data |>
    filter(!!!conditions)
}

compute_headcount <- function(data, group_cols = NULL){
  if("ref_date" %in% group_cols){
    stop("`ref_date` should not be included in `group_cols`")
  }

  headcount <- data |>
    summarise(
      headcount = n_distinct(personnel_id),
      .by = all_of(
        c(group_cols, "ref_date")
      )
    ) |>
    mutate(
      share_headcount = headcount / sum(headcount, na.rm = TRUE),
      .by = "ref_date"
    )
  
  headcount
}
