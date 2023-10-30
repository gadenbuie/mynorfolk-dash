library(shiny)
library(bslib)
library(plotly)

source(here::here("R", "setup-data.R"))

thematic::thematic_shiny()
theme_set(theme_minimal(18))

change <- new_change_with_caret_formatter(
  caret_more = bsicons::bs_icon("caret-up-fill"),
  caret_less = bsicons::bs_icon("caret-down-fill")
)

value_box_changed <- function(
    title, value, old, new = value,
    ...,
    more = "more than",
    less = "less than",
    when = "yesterday"
) {
  value_box(
    title,
    number(value),
    change(old, new, more = more, less = less, when = when),
    ...
  )
}

ui <- page_navbar(
  theme = bs_bundle(
     bs_theme(preset = "bootstrap"),
    sass::sass_layer_file("custom.scss")
  ),
  title = tagList(
    tags$img(
      src = "https://www.norfolk.gov/ImageRepository/Document?documentID=49561",
      height = "30px",
      class = "me-3"
    ),
    "MyNorfolk Requests"
  ),
  underline = FALSE,
  nav_spacer(),
  nav_panel(
    "Today",
    layout_column_wrap(
      width = "250px",
      value_box_changed(
        "In Progress",
        in_progress_today_total,
        old = 0,
        new = in_progress_today_new,
        when = "today",
        showcase = bsicons::bs_icon("arrow-repeat"),
        theme = "vb-warning"
      ),
      value_box_changed(
        "Opened",
        opened_today,
        old = opened_yesterday,
        showcase = bsicons::bs_icon("plus-circle"),
        theme = "vb-info"
      ),
      value_box_changed(
        "Closed",
        closed_today,
        old = closed_yesterday,
        showcase = bsicons::bs_icon("check-circle"),
        theme = "vb-success"
      ),
      value_box_changed(
        "Cancelled",
        cancelled_today,
        old = cancelled_yesterday,
        showcase = bsicons::bs_icon("x-circle"),
        theme = "vb-danger"
      )
    ),
    navset_card_tab(
      title= "Top",
      nav_panel("New Requests", plotlyOutput("today_top_new_requests")),
      nav_panel("In Progress", plotlyOutput("today_top_in_progress")),
      nav_panel("Closed", plotlyOutput("today_top_closed"))
    )
  ),
  nav_panel("Week", "Weekly stats here at some point."),
  nav_panel("Month", "Monthly stats here at some point."),
  nav_panel("Year", "Yearly stats here at some point.")
)

server <- function(input, output, session) {
  output$today_top_new_requests <- renderPlotly({
    plotly_top_requests(norfolk, creation_date >= today)
  })

  output$today_top_in_progress <- renderPlotly({
    plotly_top_requests(norfolk, status == "In progress")
  })

  output$today_top_closed <- renderPlotly({
    plotly_top_requests(norfolk, status == "Closed", modification_date > today)
  })
}

shinyApp(ui, server)
