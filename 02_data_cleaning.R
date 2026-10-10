# ==============================================================================
# 02_data_cleaning.R  -  Clean the raw advertisement data
# Output : data/processed/jobs_clean.csv
# ==============================================================================

source("R/00_setup.R")

raw <- read_csv(PATH_RAW, show_col_types = FALSE)
n_raw <- nrow(raw)

clean <- raw |>
  # 1. Tidy text columns: trim spaces, collapse repeated spaces, Title Case
  mutate(across(
    c(source_type, job_category, city, language, employment_type),
    ~ str_to_title(str_squish(.x))
  )) |>
  # 2. Restore the "&" casing that str_to_title leaves intact, keep names consistent
  mutate(job_category = recode(job_category,
                               "Software & It" = "Software & IT")) |>
  # 3. Proper types
  mutate(
    collection_date = as.Date(collection_date),
    across(all_of(RISK_FLAGS), as.integer)
  ) |>
  # 4. Remove exact duplicate advertisement IDs (keep the first)
  distinct(ad_id, .keep_all = TRUE) |>
  # 5. Salary features
  mutate(
    salary_mid_bdt = (salary_min_bdt + salary_max_bdt) / 2
  )

n_clean <- nrow(clean)

# Sanity checks - stop early if something is wrong
stopifnot(!anyDuplicated(clean$ad_id))
stopifnot(all(unlist(clean[RISK_FLAGS]) %in% c(0L, 1L)))

write_csv(clean, PATH_CLEAN)

cat("Rows before cleaning:", n_raw, "\n")
cat("Rows after cleaning :", n_clean, "\n")
cat("Rows removed        :", n_raw - n_clean, "(duplicates)\n")
cat("Saved to            :", PATH_CLEAN, "\n")
