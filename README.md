# Data folder

## `sample/sample_jobs.csv`

**Synthetic demonstration data.** It was generated with a fixed random seed to show the analysis workflow. It does **not** describe real advertisements, companies or statistics from Bangladesh. Every row has `data_origin = synthetic`.

The file deliberately contains a few quality problems so that the cleaning script has something to fix:

* one city written as `" dhaka "` (extra spaces, lower case)
* two category/source values in lower case
* one duplicated `ad_id`

## Data dictionary

| Column | Type | Description |
|---|---|---|
| `ad_id` | text | Unique advertisement ID (e.g. `JA001`) |
| `collection_date` | date (YYYY-MM-DD) | Date the advertisement was recorded |
| `source_type` | text | Job Portal, Company Website, Social Media Group, Messaging Channel |
| `job_category` | text | Data Entry, Customer Service, Software & IT, Marketing & Sales, Online Income, Teaching, Accounting |
| `city` | text | City or "Remote" |
| `language` | text | Bangla, English, Bangla-English |
| `salary_min_bdt` | number | Lower end of advertised monthly salary in BDT (blank if not stated) |
| `salary_max_bdt` | number | Upper end of advertised monthly salary in BDT (blank if not stated) |
| `employment_type` | text | Full-time, Part-time, Contract, Freelance, Internship |
| `asks_money` | 0/1 | Applicant must pay a fee up front |
| `unrealistic_salary` | 0/1 | Pay far above normal for the role |
| `no_company_info` | 0/1 | No verifiable company name or address |
| `only_chat_contact` | 0/1 | Contact only through chat apps |
| `no_experience_claim` | 0/1 | "No experience needed, earn from home" style claim |
| `data_origin` | text | `synthetic` or `real` |

Columns added by the pipeline: `salary_mid_bdt`, `risk_score`, `risk_level`.

## Privacy rules for real data

* Do **not** store phone numbers, email addresses, personal names or profile links.
* Do **not** store company names if the data could be used to accuse a company.
* Keep raw collected files in `data/raw/` or `data/private/` (both are git-ignored).
* Record the source type, not the exact post URL, in any published file.
