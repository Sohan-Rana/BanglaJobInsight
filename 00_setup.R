# ==============================================================================
# 00_setup.R  -  Shared setup, constants and helper functions
# Project : BanglaJobInsight
# Requires: R >= 4.1 (uses the native pipe |>)
# Usage   : source("R/00_setup.R") from the PROJECT ROOT folder
# ==============================================================================

required_packages <- c("readr", "dplyr", "tidyr", "stringr", "ggplot2", "scales")

install_if_missing <- function(pkgs) {
  missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) > 0) {
    message("Installing missing packages: ", paste(missing, collapse = ", "))
    install.packages(missing)
  }
}

install_if_missing(required_packages)

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(stringr)
  library(ggplot2)
  library(scales)
})

# ---- Paths -------------------------------------------------------------------
PATH_RAW       <- "data/sample/sample_jobs.csv"
PATH_CLEAN     <- "data/processed/jobs_clean.csv"
PATH_SCORED    <- "data/processed/jobs_scored.csv"
DIR_FIGURES    <- "outputs/figures"
DIR_RESULTS    <- "results"

for (d in c("data/processed", DIR_FIGURES, DIR_RESULTS)) {
  dir.create(d, showWarnings = FALSE, recursive = TRUE)
}

# ---- Warning-sign flags (1 = present, 0 = absent) ------------------------------
RISK_FLAGS <- c(
  "asks_money",           # asks the applicant to pay a fee up front
  "unrealistic_salary",   # pay is far above what the role normally offers
  "no_company_info",      # no verifiable company name or address
  "only_chat_contact",    # contact only via chat apps (WhatsApp / Telegram etc.)
  "no_experience_claim"   # "no experience needed, earn from home" style claims
)

RISK_LEVELS <- c("Low", "Medium", "High")

# ---- Helpers -----------------------------------------------------------------

#' Add a 0-5 risk score and a Low / Medium / High level.
#' IMPORTANT: this is a transparent heuristic, NOT proof of fraud.
add_risk_score <- function(df) {
  df |>
    mutate(
      risk_score = rowSums(across(all_of(RISK_FLAGS))),
      risk_level = case_when(
        risk_score >= 4 ~ "High",
        risk_score >= 2 ~ "Medium",
        TRUE            ~ "Low"
      ),
      risk_level = factor(risk_level, levels = RISK_LEVELS)
    )
}

#' Read the cleaned + scored dataset (run scripts 02 and 03 first).
load_scored_jobs <- function(path = PATH_SCORED) {
  read_csv(path, show_col_types = FALSE) |>
    mutate(risk_level = factor(risk_level, levels = RISK_LEVELS))
}

#' A single consistent ggplot theme for all figures.
theme_bji <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.title    = element_text(face = "bold"),
      plot.subtitle = element_text(colour = "grey35"),
      plot.caption  = element_text(colour = "grey45", size = 9),
      panel.grid.minor = element_blank()
    )
}

# Colour-blind-friendly palette for risk levels
RISK_COLOURS <- c(Low = "#4C9F70", Medium = "#E0A030", High = "#C0392B")

DATA_CAPTION <- paste0(
  "Illustrative synthetic data - not real Bangladeshi job-market statistics. ",
  "Risk score is a heuristic, not proof of fraud."
)

message("Setup complete.")
