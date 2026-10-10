# ==============================================================================
# 04_exploratory_analysis.R  -  Job market analysis + warning-sign analysis
# Outputs: CSV tables in results/
#
# With the synthetic sample data, statistical tests below only demonstrate the
# workflow. Interpret them only after replacing the sample with real,
# documented data.
# ==============================================================================

source("R/00_setup.R")

jobs <- load_scored_jobs()

# ---- A. Job market overview ------------------------------------------------------
by_category <- jobs |>
  group_by(job_category) |>
  summarise(
    ads              = n(),
    median_salary    = median(salary_mid_bdt, na.rm = TRUE),
    salary_missing   = sum(is.na(salary_mid_bdt)),
    mean_risk_score  = round(mean(risk_score), 2),
    pct_high_risk    = round(mean(risk_level == "High") * 100, 1),
    .groups = "drop"
  ) |>
  arrange(desc(ads))

by_city <- jobs |>
  group_by(city) |>
  summarise(
    ads             = n(),
    median_salary   = median(salary_mid_bdt, na.rm = TRUE),
    mean_risk_score = round(mean(risk_score), 2),
    .groups = "drop"
  ) |>
  arrange(desc(ads))

by_source <- jobs |>
  group_by(source_type) |>
  summarise(
    ads             = n(),
    mean_risk_score = round(mean(risk_score), 2),
    pct_high_risk   = round(mean(risk_level == "High") * 100, 1),
    .groups = "drop"
  ) |>
  arrange(desc(mean_risk_score))

cat("\n=== By job category ===\n");  print(by_category)
cat("\n=== By city ===\n");         print(by_city)
cat("\n=== By source type ===\n");  print(by_source)

# ---- B. Warning-sign prevalence --------------------------------------------------
flag_prevalence <- jobs |>
  summarise(across(all_of(RISK_FLAGS), ~ round(mean(.x) * 100, 1))) |>
  pivot_longer(everything(), names_to = "warning_sign", values_to = "pct_of_ads") |>
  arrange(desc(pct_of_ads))

cat("\n=== Warning-sign prevalence (% of ads) ===\n")
print(flag_prevalence)

# ---- C. Warning signs by job category (percent with the sign) ----------------------
flags_by_category <- jobs |>
  group_by(job_category) |>
  summarise(across(all_of(RISK_FLAGS), ~ round(mean(.x) * 100, 1)), .groups = "drop")

# ---- D. Do warning signs occur together? (phi / Pearson on 0-1 data) ----------------
flag_correlation <- round(cor(jobs[RISK_FLAGS]), 2)
cat("\n=== Correlation between warning signs ===\n")
print(flag_correlation)

# ---- E. Simple statistical tests (workflow demonstration) -----------------------------
cat("\n=== Kruskal-Wallis: risk score differs across job categories? ===\n")
kw <- kruskal.test(risk_score ~ job_category, data = jobs)
print(kw)

cat("\n=== Fisher's exact: asks_money vs only_chat_contact ===\n")
ft <- fisher.test(table(jobs$asks_money, jobs$only_chat_contact))
print(ft)

cat("\n=== Chi-square: risk level vs source type ===\n")
tab <- table(jobs$source_type, jobs$risk_level)
print(tab)
ct <- suppressWarnings(chisq.test(tab))
print(ct)
if (any(ct$expected < 5)) {
  cat("Note: some expected counts are < 5; treat the chi-square p-value with caution.\n")
}

# ---- F. Save tables ---------------------------------------------------------------------
write_csv(by_category,        file.path(DIR_RESULTS, "summary_by_category.csv"))
write_csv(by_city,            file.path(DIR_RESULTS, "summary_by_city.csv"))
write_csv(by_source,          file.path(DIR_RESULTS, "summary_by_source.csv"))
write_csv(flag_prevalence,    file.path(DIR_RESULTS, "warning_sign_prevalence.csv"))
write_csv(flags_by_category,  file.path(DIR_RESULTS, "warning_signs_by_category.csv"))

cat("\nTables saved in", DIR_RESULTS, "\n")
