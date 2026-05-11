
# Make sure data.table knows we know we're using it
#' @noRd
.datatable.aware = TRUE


if (getRversion() >= "2.15.1"){

  utils::globalVariables(c(
    "contract_id", "est_date", "personnel_id", "est_id", "country_code",
    "start_date", "end_date", "base_salary_lcu", "gross_salary_lcu",
    "net_salary_lcu", "whours", "cpi", "year", "ppp", "ppp_2017",
    "REF_AREA", "TIME_PERIOD", "OBS_VALUE", "INDICATOR", "n_records",
    "ref_date", "birth_date", "na.omit", "multisession", "plan",
    "ppp_2021", "occupation_isconame", "occupation_iscocode",
    "occupation_native", "occupation_english", "country_name",
    "govcount", "indicator", "isco", "isco_share", "macro_indicators",
    "macro_value", "macro_var", "num_teachers", "total", "totals",
    "ts_ratio", "value", "wage_value", "wage_var", ".", "sd",
    "summary_value", "summary_var", ".groups", ":=", "val", "N",
    "allowance_ind", "allowance_lcu", "allowshare", "gender", "educat7",
    "paygrade", "seniority", "from", "est_to", "paygrade", "seniority",
    "Module", "VariableID", "dictionary", "..groups", "n_missing",
    "pct_missing", ".contrib", ".e", ".eff_end", ".lag_max_e", ".pid",
    ".s", "current_stock", "exit_rate", "from_group", "from_period", 
    "movement_rate", "n_exits", "n_moves", "n_pop", "period_key",
    "period_prob", "t0_date", "tenure_days", "tenure_years", "to_group", 
    "to_period", ".grp_base", ".ind_base", "group_val", "group_var",
    "stat_type", "variable_id", "variable_name", "vol_fn", ".row_id",
    "group_label", "target_label", "target_var", "module", "variable",
    "name", "items", "passes", "fails", "error"
  ))

}

