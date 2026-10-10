# Limitations

1. **Synthetic sample data.** The bundled dataset is generated for demonstration. Its results say nothing about the real job market.
2. **Heuristic score, not a detector.** The risk score counts warning signs. Legitimate advertisements can show some signs (for example, small employers who only use chat apps), and scams can show none.
3. **Equal weights.** Not every sign is equally informative. Weights have not been validated.
4. **No ground truth.** Without independently verified labels, accuracy, precision and recall cannot be measured.
5. **Sampling bias.** Manually collected advertisements are not a random sample of all advertisements.
6. **Subjective coding.** Signs such as "unrealistic salary" depend on the coder's judgement. Use a written rule and, ideally, a second coder.
7. **Small subgroups.** Percentages for categories or cities with few advertisements are unstable.
8. **Time sensitivity.** Scam tactics and salary levels change; results describe only the collection period.
9. **Language coverage.** The current workflow uses structured flags, not Bangla text analysis.
10. **Risk of harm.** Mislabelling a real employer as suspicious can damage their reputation. Report patterns, not names, and never present a score as a verdict.

## Advice for readers

If an advertisement shows several warning signs, verify the employer independently (official website, registered address, reviews from trusted sources) and never pay a fee to get a job.
