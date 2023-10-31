# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

library(targets)
library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("dplyr", "lubridate", "forcats")
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Replace the target list below with your own:
list(
  # MyNorfolk Source Data ----
  tar_age(
    norfolk,
    get_my_norfolk_tickets(),
    age = as.difftime(3, units = "hours"),
    format = "parquet"
  ),

  # Dates ----
  tar_target(today, floor_date(max(norfolk$creation_date), unit = "day")),
  tar_target(yesterday, today - days(1)),

  tar_target(week_this, list(start = today - days(6), end = today() + days(1))),
  tar_target(week_prev, list(start = week_this$start - days(7), end = week_this$start)),

  # Page: Today ----
  tar_target(
    today_stats,
    stats_today(norfolk, today, yesterday)
  ),
  tar_target(
    today_plots,
    plots_today(today_stats)
  ),

  # Page: Week ----
  tar_target(
    week_stats,
    stats_week(norfolk, week_this, week_prev)
  ),
  tar_target(
    week_plots,
    plots_week(week_stats)
  ),

  # Render Quarto Dashboard ----
  tar_quarto(
    quarto_dashboard,
    "index.qmd"
  )
)
