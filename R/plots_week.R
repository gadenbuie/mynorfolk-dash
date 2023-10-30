plots_week <- function(norfolk, week_this) {
  list(
    top_new_requests =
      norfolk |>
        plotly_top_requests(
          creation_date >= week_this$start
        ),
    top_in_progress =
      norfolk |>
        plotly_top_requests(
          status == "In progress",
          modification_date >= week_this$start
        ),
    top_closed =
      norfolk |>
        plotly_top_requests(
          status == "Closed",
          modification_date >= week_this$start
        )
  )
}
