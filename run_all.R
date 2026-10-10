# ==============================================================================
# run_all.R  -  Run the whole pipeline in order
# Usage: open BanglaJobInsight.Rproj (or setwd to the project root), then
#        source("R/run_all.R")
# ==============================================================================

if (!file.exists("R/00_setup.R")) {
  stop("Please set the working directory to the project root (the folder that contains the R/ folder).")
}

scripts <- c(
  "R/01_data_validation.R",
  "R/02_data_cleaning.R",
  "R/03_risk_scoring.R",
  "R/04_exploratory_analysis.R",
  "R/05_visualization.R"
)

for (s in scripts) {
  cat("\n\n########## Running", s, "##########\n")
  source(s, echo = FALSE)
}

cat("\n\nPipeline finished.\n")
cat("Charts : outputs/figures/\nTables : results/\n")
cat("Dashboard: shiny::runApp('app')\n")
