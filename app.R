# ==============================================================================
# BanglaJobInsight - Shiny dashboard
# Run from the project root:   shiny::runApp("app")
# Prerequisite: run  source("R/run_all.R")  once so data/processed/jobs_scored.csv exists.
# ==============================================================================

library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(scales)

# ---- Locate the project root (works from project root or from app/) ----------------
root <- if (file.exists("data/processed/jobs_scored.csv")) "." else ".."
scored_path <- file.path(root, "data", "processed", "jobs_scored.csv")

if (!file.exists(scored_path)) {
  stop("jobs_scored.csv not found. Run source('R/run_all.R') from the project root first.")
}

RISK_FLAGS <- c("asks_money", "unrealistic_salary", "no_company_info",
                "only_chat_contact", "no_experience_claim")
RISK_LEVELS  <- c("Low", "Medium", "High")
RISK_COLOURS <- c(Low = "#4C9F70", Medium = "#E0A030", High = "#C0392B")

FLAG_LABELS <- c(
  asks_money          = "Asks for money / registration fee up front",
  unrealistic_salary  = "Unrealistically high salary",
  no_company_info     = "No verifiable company name or address",
  only_chat_contact   = "Contact only via WhatsApp / Telegram etc.",
  no_experience_claim = "'No experience needed, earn from home' claim"
)

jobs <- read_csv(scored_path, show_col_types = FALSE) |>
  mutate(risk_level = factor(risk_level, levels = RISK_LEVELS))

theme_app <- function() {
  theme_minimal(base_size = 13) +
    theme(plot.title = element_text(face = "bold"), panel.grid.minor = element_blank())
}

# ---- UI -----------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("BanglaJobInsight: Job Market & Warning-Sign Dashboard"),
  div(
    style = "background:#FFF4E5;border-left:4px solid #E0A030;padding:8px 12px;margin-bottom:12px;",
    strong("Please note: "),
    "The bundled data is synthetic and for demonstration only. A risk score is a heuristic ",
    "warning signal, not proof that an advertisement or company is fraudulent."
  ),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      selectInput("category", "Job category",
                  choices = c("All", sort(unique(jobs$job_category)))),
      selectInput("city", "City",
                  choices = c("All", sort(unique(jobs$city)))),
      selectInput("source", "Source type",
                  choices = c("All", sort(unique(jobs$source_type)))),
      checkboxGroupInput("levels", "Risk level",
                         choices = RISK_LEVELS, selected = RISK_LEVELS),
      sliderInput("score", "Risk score range", min = 0, max = 5,
                  value = c(0, 5), step = 1)
    ),
    mainPanel(
      width = 9,
      tabsetPanel(
        tabPanel("Overview",
                 br(),
                 fluidRow(
                   column(3, h5("Advertisements"), h3(textOutput("kpi_n"))),
                   column(3, h5("Average risk score"), h3(textOutput("kpi_mean"))),
                   column(3, h5("High-risk share"), h3(textOutput("kpi_high"))),
                   column(3, h5("Median salary (BDT)"), h3(textOutput("kpi_salary")))
                 ),
                 hr(),
                 fluidRow(
                   column(6, plotOutput("plot_levels", height = 320)),
                   column(6, plotOutput("plot_signs", height = 320))
                 )),
        tabPanel("By category & source",
                 br(),
                 plotOutput("plot_category", height = 340),
                 plotOutput("plot_source", height = 340)),
        tabPanel("Salary",
                 br(),
                 plotOutput("plot_salary", height = 440)),
        tabPanel("Data table",
                 br(),
                 downloadButton("download", "Download filtered data (CSV)"),
                 br(), br(),
                 tableOutput("table")),
        tabPanel("Check an advertisement",
                 br(),
                 p("Tick every warning sign you notice in an advertisement. ",
                   "The tool counts them using the same rules as the project."),
                 checkboxGroupInput("checker", NULL,
                                    choiceNames = unname(FLAG_LABELS[RISK_FLAGS]),
                                    choiceValues = RISK_FLAGS),
                 h4(textOutput("checker_result")),
                 p(em("This is guidance only. Verify the employer independently ",
                      "(official website, registered address, reviews) before sharing personal ",
                      "details or paying anything.")))
      )
    )
  )
)

# ---- Server -------------------------------------------------------------------------
server <- function(input, output, session) {

  filtered <- reactive({
    d <- jobs |>
      filter(risk_level %in% input$levels,
             risk_score >= input$score[1], risk_score <= input$score[2])
    if (input$category != "All") d <- filter(d, job_category == input$category)
    if (input$city     != "All") d <- filter(d, city == input$city)
    if (input$source   != "All") d <- filter(d, source_type == input$source)
    d
  })

  # Show a friendly message instead of an error when filters return nothing
  has_data <- reactive({
    validate(need(nrow(filtered()) > 0, "No advertisements match the current filters."))
    filtered()
  })

  output$kpi_n      <- renderText(format(nrow(filtered()), big.mark = ","))
  output$kpi_mean   <- renderText({
    d <- filtered(); if (nrow(d) == 0) "-" else sprintf("%.2f / 5", mean(d$risk_score))
  })
  output$kpi_high   <- renderText({
    d <- filtered(); if (nrow(d) == 0) "-" else percent(mean(d$risk_level == "High"), accuracy = 0.1)
  })
  output$kpi_salary <- renderText({
    s <- filtered()$salary_mid_bdt
    if (all(is.na(s))) "-" else format(round(median(s, na.rm = TRUE)), big.mark = ",")
  })

  output$plot_levels <- renderPlot({
    has_data() |>
      count(risk_level, .drop = FALSE) |>
      ggplot(aes(risk_level, n, fill = risk_level)) +
      geom_col(show.legend = FALSE, width = 0.65) +
      geom_text(aes(label = n), vjust = -0.4, fontface = "bold") +
      scale_fill_manual(values = RISK_COLOURS) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
      labs(title = "Advertisements by risk level", x = NULL, y = "Count") +
      theme_app()
  })

  output$plot_signs <- renderPlot({
    has_data() |>
      summarise(across(all_of(RISK_FLAGS), mean)) |>
      pivot_longer(everything(), names_to = "sign", values_to = "share") |>
      mutate(sign = unname(FLAG_LABELS[sign])) |>
      ggplot(aes(reorder(sign, share), share)) +
      geom_col(fill = "#3B6EA5", width = 0.65) +
      geom_text(aes(label = percent(share, accuracy = 1)), hjust = -0.15) +
      coord_flip() +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, 28)) +
      scale_y_continuous(labels = percent, expand = expansion(mult = c(0, 0.18))) +
      labs(title = "Warning-sign prevalence", x = NULL, y = "Share of advertisements") +
      theme_app()
  })

  output$plot_category <- renderPlot({
    has_data() |>
      group_by(job_category) |>
      summarise(mean_risk = mean(risk_score), n = n(), .groups = "drop") |>
      ggplot(aes(reorder(job_category, mean_risk), mean_risk)) +
      geom_col(fill = "#8E5BA8", width = 0.65) +
      geom_text(aes(label = sprintf("%.2f (n=%d)", mean_risk, n)), hjust = -0.1) +
      coord_flip() +
      scale_y_continuous(expand = expansion(mult = c(0, 0.3))) +
      labs(title = "Average risk score by job category", x = NULL, y = "Mean risk score") +
      theme_app()
  })

  output$plot_source <- renderPlot({
    has_data() |>
      count(source_type, risk_level) |>
      group_by(source_type) |>
      mutate(share = n / sum(n)) |>
      ungroup() |>
      ggplot(aes(source_type, share, fill = risk_level)) +
      geom_col(width = 0.7) +
      scale_fill_manual(values = RISK_COLOURS, name = "Risk level") +
      scale_y_continuous(labels = percent) +
      labs(title = "Risk level mix by source", x = NULL, y = "Share") +
      theme_app()
  })

  output$plot_salary <- renderPlot({
    d <- has_data() |> filter(!is.na(salary_mid_bdt))
    validate(need(nrow(d) > 0, "No salary data for the current filters."))
    ggplot(d, aes(reorder(job_category, salary_mid_bdt, median), salary_mid_bdt)) +
      geom_boxplot(fill = "#9CC5E8", outlier.colour = "#C0392B") +
      coord_flip() +
      scale_y_continuous(labels = label_number(big.mark = ",")) +
      labs(title = "Advertised salary by category (BDT, midpoint)", x = NULL, y = "Monthly salary (BDT)") +
      theme_app()
  })

  output$table <- renderTable({
    has_data() |>
      select(ad_id, collection_date, source_type, job_category, city,
             salary_mid_bdt, risk_score, risk_level) |>
      mutate(collection_date = format(collection_date),
             risk_level = as.character(risk_level)) |>
      head(200)
  })

  output$download <- downloadHandler(
    filename = function() paste0("banglajobinsight_filtered_", Sys.Date(), ".csv"),
    content  = function(file) write_csv(filtered(), file)
  )

  output$checker_result <- renderText({
    score <- length(input$checker)
    level <- if (score >= 4) "High" else if (score >= 2) "Medium" else "Low"
    paste0("Warning signs ticked: ", score, " / 5  ->  Risk level: ", level)
  })
}

shinyApp(ui, server)
