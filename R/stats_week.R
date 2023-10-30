stats_week <- function(norfolk, week_this, week_prev) {
  opened_this <-
    norfolk |>
    filter(between(creation_date, week_this$start, week_this$end))

  opened_prev <-
    norfolk |>
    filter(between(creation_date, week_prev$start, week_prev$end))

  started_this <-
    norfolk |>
    filter(
      status == "In progress",
      between(modification_date, week_this$start, week_this$end)
    )

  started_prev <-
    norfolk |>
    filter(
      status == "In progress",
      between(modification_date, week_prev$start, week_prev$end)
    )

  closed_this <-
    norfolk |>
    filter(
      status == "Closed",
      between(modification_date, week_this$start, week_this$end)
    )

  closed_prev <-
    norfolk |>
    filter(
      status == "Closed",
      between(modification_date, week_prev$start, week_prev$end)
    )

  cancelled_this <-
    norfolk |>
    filter(
      status == "Cancelled",
      between(modification_date, week_this$start, week_this$end)
    )

  cancelled_prev <-
    norfolk |>
    filter(
      status == "Cancelled",
      between(modification_date, week_prev$start, week_prev$end)
    )

  data <- list(
    opened = opened_this,
    closed = closed_this,
    started = started_this,
    cancelled = cancelled_this,

    opened_prev = opened_prev,
    closed_prev = closed_prev,
    started_prev = started_prev,
    cancelled_prev = cancelled_prev
  )

  counts <- lapply(data, pull_count)
  names(counts) <- paste0("n_", names(data))

  c(data, counts)
}
