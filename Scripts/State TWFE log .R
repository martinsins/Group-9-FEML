state_panel <- state_panel %>%
  mutate(
    log_violent  = log(violent_rate_100k + 1),
    log_property = log(property_rate_100k + 1),
    log_total    = log(total_rate_100k + 1)
  )
twfe_log_violent <- feols(
  log_violent ~ treated + unemp_rate + Black + HSGrad + IncomeReal + age |
    state + year,
  data = state_panel,
  vcov = "iid"
)

twfe_log_property <- feols(
  log_property ~ treated + unemp_rate + Black + HSGrad + IncomeReal + age |
    state + year,
  data = state_panel,
  vcov = "iid"
)

twfe_log_total <- feols(
  log_total ~ treated + unemp_rate + Black + HSGrad + IncomeReal + age |
    state + year,
  data = state_panel,
  vcov = "iid"
)

summary(twfe_log_violent)
summary(twfe_log_property)
summary(twfe_log_total)
dir.create("Analysis/tables", showWarnings = FALSE)

etable(
  twfe_log_violent, twfe_log_property, twfe_log_total,
  keep = "treated|unemp_rate|Black|HSGrad|IncomeReal|age",
  se.below = TRUE,
  tex = TRUE,
  file = "Analysis/tables/twfe_log_table.tex"
)

log_coefs <- bind_rows(
  tidy(twfe_log_violent) %>% mutate(model = "Violent"),
  tidy(twfe_log_property) %>% mutate(model = "Property"),
  tidy(twfe_log_total) %>% mutate(model = "Total")
)

write_csv(log_coefs, "Analysis/tables/twfe_log_coefficients.csv")
