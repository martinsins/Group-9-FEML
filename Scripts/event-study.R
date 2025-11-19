library(ggplot2)

panel %>%
  group_by(state, year) %>%
  summarize(property_rate_100k = mean(property_rate_100k, na.rm = TRUE)) %>%
  ggplot(aes(x = year, y = property_rate_100k, color = state)) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 1977, linetype = "dashed", color = "red") + 
  geom_vline(xintercept = 1983, linetype = "dashed", color = "blue") +
  labs(title = "Raw Property Crime Trends by State",
       subtitle = "Dotted lines = Illinois (1977) and Michigan (1983) party switches",
       x = "Year", y = "Crime Rate per 100k") +
  theme_minimal(base_size = 14)


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