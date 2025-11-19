panel <- panel %>%
  mutate(
    treated = if_else(!is.na(treat_start) & year >= treat_start, 1, 0)
  )
table(panel$state, panel$treated)

twfe_violent <- feols(
  violent_rate_100k ~ treated + unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel
)

twfe_property <- feols(
  property_rate_100k ~ treated + unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel
)

twfe_total <- feols(
  total_rate_100k ~ treated + unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel
)

saveRDS(
  list(
    twfe_violent  = twfe_violent,
    twfe_property = twfe_property,
    twfe_total    = twfe_total
  ),
  file = "Data/Processed/twfe_models.rds"
)

saveRDS(
  list(
    twfe_violent  = twfe_violent,
    twfe_property = twfe_property,
    twfe_total    = twfe_total
  ),
  file = "Data/Processed/twfe_models.rds"
)

### to read it later
#twfe_list <- readRDS("Data/Processed/twfe_models.rds")
#twfe_violent  <- twfe_list$twfe_violent
#twfe_property <- twfe_list$twfe_property
#ttfe_total    <- twfe_list$twfe_total### 

library(fixest)

etable(
  twfe_violent, twfe_property, twfe_total,
  vcov = ~ state,                     # clustered SE (same as in your models)
  keep = "treated|unemp_rate|Black|HSGrad|IncomeReal|age",
  se.below = TRUE,
  dict = c(
    treated    = "Post-switch (treated)",
    unemp_rate = "Unemployment rate",
    Black      = "% Black",
    HSGrad     = "% HS Graduates",
    IncomeReal = "Real income",
    age        = "Average age"
  ),
  tex = TRUE,
  file = "Analysis/tables/twfe_table.tex"
)
etable(
  twfe_violent, twfe_property, twfe_total,
  vcov = ~ state,
  keep = "treated|unemp_rate|Black|HSGrad|IncomeReal|age",
  se.below = TRUE
)
library(broom)

twfe_coefs <- bind_rows(
  tidy(twfe_violent)  %>% mutate(model = "Violent"),
  tidy(twfe_property) %>% mutate(model = "Property"),
  tidy(twfe_total)    %>% mutate(model = "Total")
)

write_csv(twfe_coefs, "Analysis/tables/twfe_coefficients.csv")
