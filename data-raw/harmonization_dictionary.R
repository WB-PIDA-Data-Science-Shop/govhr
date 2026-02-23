## code to prepare `harmonization_dictionary` dataset goes here

library(readxl)

# read in the sheet from file
path_chr <- "data-raw/hrmis_data_dictionary.xlsx"

# Get all sheet names (each corresponds to a module)
modules <- excel_sheets(path_chr)

# Read all sheets into a named list of data frames
dict_df <-
  lapply(modules,
         function(sheet) {

  read_excel(path_chr, sheet = sheet)

}) |>
 bind_rows() |> 
 janitor::clean_names()

harmonization_dict <- dict_df

rm(dict_df)

usethis::use_data(harmonization_dict, overwrite = TRUE)
