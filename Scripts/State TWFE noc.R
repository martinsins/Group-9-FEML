library(fixest)
library(dplyr)

# make sure treated is in state_panel
table(state_panel$state, state_panel$treated)

# --- TWFE without controls ---

twfe_violent_noc <- feols(
  violent_rate_100k ~ treated | state + year,
  data = state_panel,
  vcov = "iid"   # simple robust SE
)

twfe_property_noc <- feols(
  property_rate_100k ~ treated | state + year,
  data = state_panel,
  vcov = "iid"
)

twfe_total_noc <- feols(
  total_rate_100k ~ treated | state + year,
  data = state_panel,
  vcov = "iid"
)

summary(twfe_violent_noc)
summary(twfe_property_noc)
summary(twfe_total_noc)

# Create directory
dir.create("Analysis/tables", showWarnings = FALSE)

# Save LaTeX table
etable(
  twfe_violent_noc, twfe_property_noc, twfe_total_noc,
  keep = "treated",
  se.below = TRUE,
  tex = TRUE,
  file = "Analysis/tables/twfe_nocontrols_table.tex"
)

# Save CSV coefficients
twfe_noc_coefs <- bind_rows(
  tidy(twfe_violent_noc) %>% mutate(model = "Violent"),
  tidy(twfe_property_noc) %>% mutate(model = "Property"),
  tidy(twfe_total_noc) %>% mutate(model = "Total")
)

write_csv(twfe_noc_coefs, "Analysis/tables/twfe_nocontrols_coefficients.csv")