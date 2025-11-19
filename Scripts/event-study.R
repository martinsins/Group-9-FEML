es_property <- feols(
  property_rate_100k ~ i(event_time, ref = -1) +
    unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel
)

summary(es_property)   # optional, to see the table

iplot(es_property,
      main = "Event Study: Property Crime vs Governor Party",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on property crime rate per 100k")

es_violent <- feols(
  violent_rate_100k ~ i(event_time, ref = -1) +
    unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel
)

summary(es_violent)

iplot(es_violent,
      main = "Event Study: Violent Crime vs Governor Party",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on violent crime rate per 100k")

es_total <- feols(
  total_rate_100k ~ i(event_time, ref = -1) +
    unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel
)

summary(es_total)

iplot(es_total,
      main = "Event Study: Total Crime vs Governor Party",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on total crime rate per 100k")

png("Analysis/figs/es_property.png", width = 900, height = 700)
iplot(es_property,
      main = "Event Study: Property Crime vs Governor Party",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on property crime rate per 100k")
dev.off()
png("Analysis/figs/es_violent.png", width = 900, height = 700)
iplot(es_violent,
      main = "Event Study: Violent Crime vs Governor Party",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on violent crime rate per 100k")
dev.off()
png("Analysis/figs/es_total.png", width = 900, height = 700)
iplot(es_total,
      main = "Event Study: Total Crime vs Governor Party",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on total crime rate per 100k")
dev.off()