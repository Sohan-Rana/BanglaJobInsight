# BanglaJobInsight 🇧🇩

**Job market analysis and warning-sign risk scoring for job advertisements in Bangladesh, built with R.**

BanglaJobInsight is the second, expanded version of the earlier *BanglaJobGuard* idea. Instead of only labelling advertisements as "Suspicious" or "Legitimate", it:

1. **Analyses the job market**: demand by category and city, advertised salary ranges, and advertisement sources.
2. **Scores each advertisement (0-5)** by counting transparent warning signs, then groups the result into Low, Medium and High.
3. **Presents the results** as reproducible R scripts, publication-style charts, a research report and an interactive Shiny dashboard.

> **Status: research prototype.** The bundled dataset (`data/sample/sample_jobs.csv`) is **synthetic** and exists only to demonstrate the workflow. Nothing in this repository is a real statistic about the Bangladeshi job market, and the risk score is **not** proof that an advertisement or company is fraudulent.

---

## Warning signs used in the risk score

Each sign is coded `1` (present) or `0` (absent). The risk score is their sum.

| Column | Meaning |
|---|---|
| `asks_money` | Asks the applicant to pay a fee up front |
| `unrealistic_salary` | Pay far above what the role normally offers |
| `no_company_info` | No verifiable company name or address |
| `only_chat_contact` | Contact only through chat apps (WhatsApp, Telegram, etc.) |
| `no_experience_claim` | "No experience needed, earn from home" style claims |

| Score | Level |
|---|---|
| 0-1 | Low |
| 2-3 | Medium |
| 4-5 | High |

## Project structure

```
BanglaJobInsight/
├── README.md
├── LICENSE
├── .gitignore
├── BanglaJobInsight.Rproj
├── data/
│   ├── README.md                 # data dictionary + ethics
│   ├── sample/sample_jobs.csv    # synthetic demo data (120 rows + 1 duplicate)
│   └── processed/                # created by the scripts
├── R/
│   ├── 00_setup.R                # packages, constants, helper functions
│   ├── 01_data_validation.R      # quality checks on raw data
│   ├── 02_data_cleaning.R        # text tidying, de-duplication, types
│   ├── 03_risk_scoring.R         # risk score + level
│   ├── 04_exploratory_analysis.R # summaries, correlations, tests
│   ├── 05_visualization.R        # ggplot2 figures
│   └── run_all.R                 # run everything in order
├── app/app.R                     # Shiny dashboard
├── outputs/figures/              # charts (PNG)
├── results/                      # summary tables (CSV)
├── reports/
│   ├── research_report.md
│   └── references.md
└── docs/
    ├── methodology.md
    ├── limitations.md
    ├── data_collection_guide.md
    └── freelance_portfolio_notes.md
```

## Quick start

**Requirements:** R ≥ 4.1 and RStudio Desktop. Packages (`readr`, `dplyr`, `tidyr`, `stringr`, `ggplot2`, `scales`, `shiny`) are installed automatically by `R/00_setup.R` if missing.

```r
# 1. Open BanglaJobInsight.Rproj in RStudio (this sets the working directory)

# 2. Run the whole pipeline
source("R/run_all.R")

# 3. Launch the dashboard
install.packages("shiny")   # only if not installed yet
shiny::runApp("app")
```

After step 2 you will find charts in `outputs/figures/`, tables in `results/`, and the scored dataset in `data/processed/jobs_scored.csv`.

## Using your own real data

1. Read `docs/data_collection_guide.md` first (ethics, privacy, site terms).
2. Create a CSV with the same columns as `data/sample/sample_jobs.csv`.
3. Set `data_origin` to `real`, then change `PATH_RAW` in `R/00_setup.R`.
4. Re-run `source("R/run_all.R")`.

Remove or replace the "synthetic data" caption in `R/00_setup.R` (`DATA_CAPTION`) only when real data is in use.

## Research questions

1. Which warning signs are most common in the collected advertisements?
2. How do warning signs and advertised salaries vary across job categories, cities and sources?
3. Do warning signs tend to occur together?
4. (Future) Can a carefully validated model help prioritise advertisements for human review?

## Ethics and limitations

* Never publish personal data (phone numbers, emails, names of individuals).
* Do not name companies or people as scammers. Analyse patterns, not accusations.
* Respect each website's terms of service when collecting data.
* A high score is a reason to verify, not a verdict. See `docs/limitations.md`.

## Roadmap

- [x] Synthetic demo dataset and data dictionary
- [x] Validation, cleaning and scoring pipeline
- [x] Exploratory analysis and charts
- [x] Shiny dashboard
- [ ] Collect 100-200 real advertisements with documented sources
- [ ] Independent verification of a labelled subset
- [ ] Weighted score / logistic regression, evaluated with held-out data
- [ ] Bangla text analysis (NLP)

## License

Code is released under the MIT License (see `LICENSE`). Datasets you add may have different licences.

## Author

Sohan Rana (SR), Software Engineering, Daffodil International University.
