# ==============================================================================
# 01_data_validation.R  -  Inspect the raw data and report quality problems
# Run from the project root:  source("R/01_data_validation.R")
# ==============================================================================

source("R/00_setup.R")

raw <- read_csv(PATH_RAW, show_col_types = FALSE)

cat("\n=== Raw data overview ===\n")
cat("Rows   :", nrow(raw), "\n")
cat("Columns:", ncol(raw), "\n\n")
glimpse(raw)

# ---- 1. Expected columns ------------------------------------------------------
expected_cols <- c(
  "ad_id", "collection_date", "source_type", "job_category", "city", "language",
  "salary_min_bdt", "salary_max_bdt", "employment_type", RISK_FLAGS, "data_origin"
)
missing_cols <- setdiff(expected_cols, names(raw))
if (length(missing_cols) > 0) {
  stop("Missing columns: ", paste(missing_cols, collapse = ", "))
}
cat("\n[OK] All expected columns are present.\n")

# ---- 2. Duplicate IDs ----------------------------------------------------------
dup_ids <- raw |> count(ad_id) |> filter(n > 1)
cat("\nDuplicate ad_id values:", nrow(dup_ids), "\n")
if (nrow(dup_ids) > 0) print(dup_ids)

# ---- 3. Missing values per column ----------------------------------------------
cat("\nMissing values per column:\n")
print(colSums(is.na(raw)))

# ---- 4. Flags must be 0 / 1 ----------------------------------------------------
bad_flags <- raw |>
  select(all_of(RISK_FLAGS)) |>
  summarise(across(everything(), ~ sum(!(.x %in% c(0, 1)))))
cat("\nInvalid flag values (should all be 0):\n")
print(bad_flags)

# ---- 5. Inconsistent text values -------------------------------------------------
cat("\nDistinct values (look for spelling / case / space problems):\n")
for (col in c("source_type", "job_category", "city", "language", "employment_type")) {
  cat("\n", col, ":\n", sep = "")
  print(table(raw[[col]], useNA = "ifany"))
}

# ---- 6. Salary sanity -----------------------------------------------------------
bad_salary <- raw |>
  filter(!is.na(salary_min_bdt), !is.na(salary_max_bdt), salary_min_bdt > salary_max_bdt)
cat("\nRows where salary_min > salary_max:", nrow(bad_salary), "\n")

cat("\nValidation finished. Fix issues in R/02_data_cleaning.R.\n")
