library(fixest)
library(dplyr)
library(ggplot2)

# 1) Restrict to a reasonable event window (optional but helps)
state_es <- state_panel %>%
  filter(!is.na(event_time),
         event_time >= -5,
         event_time <= 5)

ref_period <- -1  # year before switch

# VIOLENT
es_violent <- feols(
  violent_rate_100k ~ i(event_time, ref = ref_period) +
    unemp_rate + Black + HSGrad + IncomeReal + age |
    state + year,
  data = state_es,      # <-- no cluster here
  vcov = "iid"          # simple robust VCOV
)

# PROPERTY
es_property <- feols(
  property_rate_100k ~ i(event_time, ref = ref_period) +
    unemp_rate + Black + HSGrad + IncomeReal + age |
    state + year,
  data = state_es,
  vcov = "iid"
)

# TOTAL
es_total <- feols(
  total_rate_100k ~ i(event_time, ref = ref_period) +
    unemp_rate + Black + HSGrad + IncomeReal + age |
    state + year,
  data = state_es,
  vcov = "iid"
)

summary(es_violent)
summary(es_property)
summary(es_total)

# VIOLENT
iplot(
  es_violent,
  main = "State-level Event Study: Violent Crime vs Governor Party",
  xlab = "Event Time (years relative to switch)",
  ylab = "Effect on violent crime per 100k"
)
abline(v = 0, col = "red", lwd = 2, lty = 2)

# PROPERTY
iplot(
  es_property,
  main = "State-level Event Study: Property Crime vs Governor Party",
  xlab = "Event Time (years relative to switch)",
  ylab = "Effect on property crime per 100k"
)
abline(v = 0, col = "red", lwd = 2, lty = 2)

# TOTAL
iplot(
  es_total,
  main = "State-level Event Study: Total Crime vs Governor Party",
  xlab = "Event Time (years relative to switch)",
  ylab = "Effect on total crime per 100k"
)
abline(v = 0, col = "red", lwd = 2, lty = 2)

dir.create("Analysis/figs", showWarnings = FALSE)

png("Analysis/figs/es_violent_state.png", width = 900, height = 700)
iplot(
  es_violent,
  main = "State-level Event Study: Violent Crime vs Governor Party",
  xlab = "Event Time (years relative to switch)",
  ylab = "Effect on violent crime rate per 100k"
)
abline(v = 0, col = "red", lwd = 2, lty = 2)
dev.off()

png("Analysis/figs/es_property_state.png", width = 900, height = 700)
iplot(
  es_property,
  main = "State-level Event Study: Property Crime vs Governor Party",
  xlab = "Event Time (years relative to switch)",
  ylab = "Effect on property crime rate per 100k"
)
abline(v = 0, col = "red", lwd = 2, lty = 2)
dev.off()

png("Analysis/figs/es_total_state.png", width = 900, height = 700)
iplot(
  es_total,
  main = "State-level Event Study: Total Crime vs Governor Party",
  xlab = "Event Time (years relative to switch)",
  ylab = "Effect on total crime rate per 100k"
)
abline(v = 0, col = "red", lwd = 2, lty = 2)
dev.off()
