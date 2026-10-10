# Methodology

## 1. Design

Exploratory, descriptive study of job advertisements. The project does not estimate how common job scams are in Bangladesh and does not claim to detect fraud.

## 2. Unit of analysis

One job advertisement (one row).

## 3. Warning-sign coding

Each sign is coded 1 if clearly present, otherwise 0. When unsure, code 0 and note it.

| Sign | Code 1 when... |
|---|---|
| `asks_money` | The advertisement asks for any up-front payment (registration, training, security deposit, "processing" fee) |
| `unrealistic_salary` | Pay is far above the usual range for the role, judged against a documented reference (e.g. other listings on reputable portals) |
| `no_company_info` | No company name, or a name/address that cannot be found elsewhere |
| `only_chat_contact` | The only contact route is a chat app number, with no company email or website |
| `no_experience_claim` | Claims of high earnings with no skills or experience, "work from home, earn daily" style |

## 4. Risk score

```
risk_score = asks_money + unrealistic_salary + no_company_info
           + only_chat_contact + no_experience_claim
```

| Score | Level |
|---|---|
| 0-1 | Low |
| 2-3 | Medium |
| 4-5 | High |

**Why equal weights?** They are simple and transparent. Weights learned from data (for example logistic regression) should only be used once a verified labelled dataset exists.

## 5. Analysis steps

1. Validate and clean the data (`01`, `02`).
2. Compute scores (`03`).
3. Summaries by category, city and source; warning-sign prevalence; sign correlations; Kruskal-Wallis, Fisher and chi-square tests (`04`).
4. Visualise (`05`).

## 6. Statistical notes

* Kruskal-Wallis is used because the score is ordinal and bounded.
* Chi-square approximations are unreliable when expected counts are below 5; the script prints a warning.
* With many tests, p-values should be treated as exploratory (consider adjusting for multiple comparisons).
* Report group sizes with every percentage.

## 7. Reproducibility

Run `source("R/run_all.R")` from the project root. Record `sessionInfo()` in the report appendix.
