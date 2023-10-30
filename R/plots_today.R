plots_today <- function(norfolk, today) {
  list(
    top_new_requests =
      plotly_top_requests(norfolk, creation_date >= today),
    top_in_progress =
      plotly_top_requests(norfolk, status == "In progress"),
    top_closed =
      plotly_top_requests(norfolk, status == "Closed", modification_date > today)
  )
}
