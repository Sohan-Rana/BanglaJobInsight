# ==============================================================================
# 05_visualization.R  -  Publication-style charts (ggplot2)
# Outputs: PNG files in outputs/figures/
# ==============================================================================

source("R/00_setup.R")

jobs <- load_scored_jobs()

save_fig <- function(plot, name, w = 9, h = 5.5) {
  ggsave(file.path(DIR_FIGURES, name), plot, width = w, height = h, dpi = 300, bg = "white")
  message("Saved: ", name)
}

# ---- Fig 1. Risk level distribution -------------------------------------------------
p1 <- jobs |>
  count(risk_level) |>
  ggplot(aes(risk_level, n, fill = risk_level)) +
  geom_col(width = 0.65, show.legend = FALSE) +
  geom_text(aes(label = n), vjust = -0.4, fontface = "bold") +
  scale_fill_manual(values = RISK_COLOURS) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(title = "Job advertisements by risk level",
       subtitle = "Risk level = number of warning signs present (0-1 Low, 2-3 Medium, 4-5 High)",
       x = NULL, y = "Number of advertisements", caption = DATA_CAPTION) +
  theme_bji()
save_fig(p1, "01_risk_level_distribution.png")

# ---- Fig 2. Warning-sign prevalence ---------------------------------------------------
p2 <- jobs |>
  summarise(across(all_of(RISK_FLAGS), mean)) |>
  pivot_longer(everything(), names_to = "sign", values_to = "share") |>
  mutate(sign = str_replace_all(sign, "_", " ") |> str_to_sentence()) |>
  ggplot(aes(reorder(sign, share), share)) +
  geom_col(fill = "#3B6EA5", width = 0.65) +
  geom_text(aes(label = percent(share, accuracy = 1)), hjust = -0.15) +
  coord_flip() +
  scale_y_continuous(labels = percent, expand = expansion(mult = c(0, 0.15))) +
  labs(title = "How common is each warning sign?",
       x = NULL, y = "Share of advertisements", caption = DATA_CAPTION) +
  theme_bji()
save_fig(p2, "02_warning_sign_prevalence.png")

# ---- Fig 3. Mean risk score by job category ---------------------------------------------
p3 <- jobs |>
  group_by(job_category) |>
  summarise(mean_risk = mean(risk_score), n = n(), .groups = "drop") |>
  ggplot(aes(reorder(job_category, mean_risk), mean_risk)) +
  geom_col(fill = "#8E5BA8", width = 0.65) +
  geom_text(aes(label = sprintf("%.2f (n=%d)", mean_risk, n)), hjust = -0.1, size = 3.5) +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.3))) +
  labs(title = "Average risk score by job category",
       x = NULL, y = "Mean risk score (0-5)", caption = DATA_CAPTION) +
  theme_bji()
save_fig(p3, "03_risk_by_category.png")

# ---- Fig 4. Risk level mix by source type -------------------------------------------------
p4 <- jobs |>
  count(source_type, risk_level) |>
  group_by(source_type) |>
  mutate(share = n / sum(n)) |>
  ungroup() |>
  ggplot(aes(source_type, share, fill = risk_level)) +
  geom_col(width = 0.7) +
  scale_fill_manual(values = RISK_COLOURS, name = "Risk level") +
  scale_y_continuous(labels = percent) +
  labs(title = "Risk level mix by advertisement source",
       x = NULL, y = "Share of advertisements", caption = DATA_CAPTION) +
  theme_bji() +
  theme(axis.text.x = element_text(angle = 15, hjust = 1))
save_fig(p4, "04_risk_by_source.png")

# ---- Fig 5. Salary distribution by job category -------------------------------------------
p5 <- jobs |>
  filter(!is.na(salary_mid_bdt)) |>
  ggplot(aes(reorder(job_category, salary_mid_bdt, median), salary_mid_bdt)) +
  geom_boxplot(fill = "#9CC5E8", outlier.colour = "#C0392B") +
  coord_flip() +
  scale_y_continuous(labels = label_number(big.mark = ",")) +
  labs(title = "Advertised monthly salary by job category (BDT, midpoint of range)",
       subtitle = "Red points are unusually high advertised pay",
       x = NULL, y = "Monthly salary (BDT)", caption = DATA_CAPTION) +
  theme_bji()
save_fig(p5, "05_salary_by_category.png")

# ---- Fig 6. Heatmap: warning signs x job category -----------------------------------------
p6 <- jobs |>
  group_by(job_category) |>
  summarise(across(all_of(RISK_FLAGS), mean), .groups = "drop") |>
  pivot_longer(-job_category, names_to = "sign", values_to = "share") |>
  mutate(sign = str_replace_all(sign, "_", " ") |> str_to_sentence()) |>
  ggplot(aes(sign, job_category, fill = share)) +
  geom_tile(colour = "white") +
  geom_text(aes(label = percent(share, accuracy = 1)), size = 3.3) +
  scale_fill_gradient(low = "#F5F5F5", high = "#C0392B", labels = percent, name = "Share") +
  labs(title = "Warning signs by job category",
       x = NULL, y = NULL, caption = DATA_CAPTION) +
  theme_bji() +
  theme(axis.text.x = element_text(angle = 25, hjust = 1), panel.grid = element_blank())
save_fig(p6, "06_warning_sign_heatmap.png", w = 10, h = 5.5)

cat("\nAll figures saved in", DIR_FIGURES, "\n")
