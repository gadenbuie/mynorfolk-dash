
get_my_norfolk_tickets <- function() {
  data_url <- "https://data.norfolk.gov/api/views/nbyu-xjez/rows.csv?accessType=DOWNLOAD&api_foundry=true"

  tmpfile <- tempfile(fileext = ".csv")
  download.file(data_url, tmpfile)

  arrow::read_csv_arrow(tmpfile) |>
    janitor::clean_names() |>
    mutate(
      across(contains("date"), mdy_hms),
      is_resolved = status %in% c("Closed", "Cancelled"),
      status = factor(status, c("Open", "In progress", "Cancelled", "Closed")),
      resolved_date = if_else(is_resolved, modification_date, NA),
      age_days = if_else(is.na(resolved_date), now(), resolved_date) - creation_date,
      age_days = as.numeric(age_days) / 3600 / 24
    )
}
