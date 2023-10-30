library(tidyverse)

data_url <- "https://data.norfolk.gov/api/views/nbyu-xjez/rows.csv?accessType=DOWNLOAD&api_foundry=true"
data_file_raw <- here::here(sprintf("data-raw/my-norfolk.%s.csv", today()))
data_file <- here::here(sprintf("data/my-norfolk.%s.parquet", today()))

if (!fs::file_exists(data_file)) {
  if (!fs::file_exists(data_file_raw)) {
    download.file(data_url, data_file_raw)
  }

  fs::dir_create(fs::path_dir(data_file))

  arrow::read_csv_arrow(data_file_raw) |>
    janitor::clean_names() |>
    mutate(
      across(contains("date"), mdy_hms),
      is_resolved = status %in% c("Closed", "Cancelled"),
      status = factor(status, c("Open", "In progress", "Cancelled", "Closed")),
      resolved_date = if_else(is_resolved, modification_date, NA),
      age_days = if_else(is.na(resolved_date), now(), resolved_date) - creation_date,
      age_days = as.numeric(age_days) / 3600 / 24
    ) |>
    arrow::write_parquet(sink = data_file)
}
