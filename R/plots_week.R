plots_week <- function(week_stats) {
  list(
    top_new_requests =
      plotly_top_requests(week_stats$opened),
    top_in_progress =
      plotly_top_requests(week_stats$started),
    top_closed =
      plotly_top_requests(week_stats$closed),
    opened_by_hour =
      plotly_by_hour(week_stats$opened),
    resolved_by_hour =
      week_stats$closed |>
      bind_rows(week_stats$cancelled) |>
      plotly_by_hour()
  )
}
