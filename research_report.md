# Exploratory Analysis of Job Market Patterns and Potential Scam Indicators in Bangladeshi Job Advertisements Using R

**Author:** Sohan Rana
**Status:** Draft template. Sections marked **[TO COMPLETE]** need real data and real results.
**Version:** 0.1 (October 2026)

> The bundled sample dataset is synthetic. Numbers produced from it must never be presented as real findings about Bangladesh. Replace every placeholder with results from a documented real dataset before sharing this report as research.

---

## Abstract **[TO COMPLETE]**

Write 150-200 words covering: (1) the problem (recruitment fraud in online job advertisements), (2) the dataset (source types, collection period, sample size), (3) the method (descriptive statistics and a transparent 0-5 warning-sign score in R), (4) the main results, and (5) the main limitation.

**Keywords:** job advertisements, recruitment fraud, Bangladesh, exploratory data analysis, R

## 1. Introduction

Online job advertising is a major route to employment, and it also attracts fraudulent advertisements that ask applicants for money or personal information. This project studies observable characteristics of job advertisements in Bangladesh, combining two goals:

1. describe the advertised job market (categories, cities, salary ranges, sources), and
2. measure how many recognisable warning signs each advertisement shows.

**[TO COMPLETE]** Add 2-3 paragraphs of context with cited sources on recruitment fraud in Bangladesh or South Asia.

## 2. Research Questions

* **RQ1.** Which warning signs are most common in the collected advertisements?
* **RQ2.** How do warning signs and advertised salaries differ by job category, city and source type?
* **RQ3.** Do warning signs tend to occur together?
* **RQ4 (future work).** Can a validated model help prioritise advertisements for human review?

## 3. Related Work **[TO COMPLETE]**

Review published work on: online recruitment fraud detection, fake job posting datasets, text classification for scam detection, and any Bangladesh-specific studies. Add each source to `references.md` only after you have read it and verified the citation details.

## 4. Data

### 4.1 Source and collection **[TO COMPLETE]**

Document: platforms or source types, collection dates, who collected the data, sampling method, inclusion and exclusion criteria, and how the site terms of service were respected.

### 4.2 Variables

See `data/README.md` for the full data dictionary. Five binary warning signs are recorded: `asks_money`, `unrealistic_salary`, `no_company_info`, `only_chat_contact`, `no_experience_claim`.

### 4.3 Coding rules **[TO COMPLETE]**

Define precisely when each sign is coded `1`. Example: `unrealistic_salary = 1` when the advertised pay is more than *X* times the typical pay for the category, with the reference source stated. Report how many coders there were and how disagreements were resolved.

### 4.4 Privacy and ethics

No personal identifiers or company names are stored. Results are reported at the category level. A high score is not an accusation.

## 5. Methods

All analysis uses R. The pipeline (`R/run_all.R`) performs:

1. **Validation** of columns, duplicates, missing values and invalid codes.
2. **Cleaning**: trimming and standardising text, removing duplicate IDs, converting types.
3. **Scoring**: `risk_score` = sum of the five signs (0-5); Low (0-1), Medium (2-3), High (4-5).
4. **Descriptive statistics** by category, city and source.
5. **Association checks**: correlation between signs, Kruskal-Wallis test (score by category), Fisher's exact test, chi-square test (level by source).
6. **Visualisation** with ggplot2.

The equal-weight score is a simple, transparent baseline, not a validated classifier.

## 6. Results **[TO COMPLETE]**

Insert figures from `outputs/figures/` and tables from `results/`, and describe what they show without over-claiming.

| Figure | File | Shows |
|---|---|---|
| 1 | `01_risk_level_distribution.png` | Advertisements by risk level |
| 2 | `02_warning_sign_prevalence.png` | Prevalence of each warning sign |
| 3 | `03_risk_by_category.png` | Mean risk score by category |
| 4 | `04_risk_by_source.png` | Risk level mix by source |
| 5 | `05_salary_by_category.png` | Salary distribution by category |
| 6 | `06_warning_sign_heatmap.png` | Warning signs by category |

Report sample sizes (n) next to every percentage and avoid conclusions from very small groups.

## 7. Discussion **[TO COMPLETE]**

Interpret results, consider alternative explanations (for example, a platform may simply attract more advertisements in one category), and compare with prior work.

## 8. Limitations and Ethical Considerations

See `docs/limitations.md`. Key points: non-random sample, subjective coding, equal weights, small subgroup sizes, and the risk of false accusations.

## 9. Conclusion and Future Work **[TO COMPLETE]**

Summarise the findings, then outline next steps: independent verification of a labelled subset, weighted scoring or logistic regression with held-out evaluation, and Bangla-language text analysis.

## References

See `references.md`.

## Appendix

* Session information: run `sessionInfo()` and paste the output here.
* Full tables: `results/*.csv`.
