plots_today <- function(today_stats) {
  list(
    top_new_requests =
      plotly_top_requests(today_stats$opened),
    top_in_progress =
      plotly_top_requests(today_stats$in_progress_new),
    top_closed =
      plotly_top_requests(today_stats$closed),
    opened_by_hour =
      plotly_by_hour(today_stats$opened),
    resolved_by_hour =
      today_stats$closed |>
      bind_rows(today_stats$cancelled) |>
      plotly_by_hour()
  )
}
