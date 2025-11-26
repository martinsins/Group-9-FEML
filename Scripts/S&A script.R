library(fixest)
library(ggplot2)

str(panel)
table(panel$state, panel$treat_start)

#-----------------------------
# 1. Sun & Abraham estimators
#    (with same controls as TWFE)
#-----------------------------

sa_violent <- feols(
  violent_rate_100k ~ sunab(treat_start, year) +
    unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel
)

sa_property <- feols(
  property_rate_100k ~ sunab(treat_start, year) +
    unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel
)

sa_total <- feols(
  total_rate_100k ~ sunab(treat_start, year) +
    unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel
)

summary(sa_violent)
summary(sa_property)
summary(sa_total)

#-----------------------------
# 2. Event-time S&A plots on screen
#-----------------------------

iplot(sa_violent,
      main = "Sun & Abraham Event Study: Violent Crime",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on violent crime rate per 100k")

iplot(sa_property,
      main = "Sun & Abraham Event Study: Property Crime",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on property crime rate per 100k")

iplot(sa_total,
      main = "Sun & Abraham Event Study: Total Crime",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on total crime rate per 100k")

#-----------------------------
# 3. Save the S&A plots
#-----------------------------

png("Analysis/figs/sa_violent.png", width = 900, height = 700)
iplot(sa_violent,
      main = "Sun & Abraham Event Study: Violent Crime",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on violent crime rate per 100k")
dev.off()

png("Analysis/figs/sa_property.png", width = 900, height = 700)
iplot(sa_property,
      main = "Sun & Abraham Event Study: Property Crime",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on property crime rate per 100k")
dev.off()

png("Analysis/figs/sa_total.png", width = 900, height = 700)
iplot(sa_total,
      main = "Sun & Abraham Event Study: Total Crime",
      xlab = "Event time (years relative to switch)",
      ylab = "Effect on total crime rate per 100k")
dev.off()

etable(
  list(
    "Violent Crime (S&A)"  = sa_violent,
    "Property Crime (S&A)" = sa_property,
    "Total Crime (S&A)"    = sa_total
  ),
  tex = TRUE,
  file = "Analysis/tables/sa_results.tex"
)

etable(sa_violent,
       tex = TRUE,
       file = "Analysis/tables/sa_violent.tex")

etable(sa_property,
       tex = TRUE,
       file = "Analysis/tables/sa_property.tex")

etable(sa_total,
       tex = TRUE,
       file = "Analysis/tables/sa_total.tex")

### to load these in latex
#\input{Analysis/tables/sa_results.tex}
##or
#\input{Analysis/tables/sa_violent.tex}
#\input{Analysis/tables/sa_property.tex}
#\input{Analysis/tables/sa_total.tex}

