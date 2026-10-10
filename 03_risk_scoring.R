# ==============================================================================
# 03_risk_scoring.R  -  Compute the heuristic Risk Score (0-5) and Risk Level
#
# Score = number of warning signs present in an advertisement:
#   asks_money + unrealistic_salary + no_company_info +
#   only_chat_contact + no_experience_claim
#
# Level : 0-1 = Low | 2-3 = Medium | 4-5 = High
#
# NOTE  : The score ranks advertisements for human review. It does NOT prove
#         that an advertisement or a company is fraudulent.
# ==============================================================================

source("R/00_setup.R")

clean  <- read_csv(PATH_CLEAN, show_col_types = FALSE)
scored <- add_risk_score(clean)

write_csv(scored, PATH_SCORED)

cat("Risk level distribution:\n")
print(table(scored$risk_level))

cat("\nShare of advertisements by risk level (%):\n")
print(round(prop.table(table(scored$risk_level)) * 100, 1))

cat("\nSaved to:", PATH_SCORED, "\n")
