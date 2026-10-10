# Data Collection Guide (for real data)

## Before you start

* Read and respect each website's terms of service and `robots.txt`. If scraping is not allowed, collect by hand or ask for permission.
* Do not log in to private groups to copy content without the group's permission.
* Decide the inclusion criteria in advance (for example: Bangladesh-targeted advertisements posted in a given period).

## What to record

Only the columns in `data/README.md`. Record the **source type**, not the post URL, and never record:

* phone numbers, emails or WhatsApp/Telegram handles
* names of individuals
* company names in the published dataset

Keep any private notes in `data/private/` (git-ignored).

## Suggested sample plan

| Source type | Target ads |
|---|---|
| Job Portal | 40 |
| Company Website | 20 |
| Social Media Group | 40 |
| Messaging Channel | 20 |

A target of 100-200 advertisements is enough for descriptive work. State clearly that it is not a random sample.

## Coding procedure

1. Use the rules in `docs/methodology.md`.
2. Code each advertisement independently on a first pass.
3. If possible, have a second person code 20-30% of the ads; compute agreement (for example Cohen's kappa) and discuss disagreements.
4. Note uncertain cases in a private file.

## Quality checklist

- [ ] `ad_id` unique
- [ ] Dates in YYYY-MM-DD
- [ ] Flags only 0 or 1
- [ ] Salary in BDT per month (convert and note if given weekly or daily)
- [ ] `data_origin` set to `real`
- [ ] No personal identifiers
