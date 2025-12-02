library(tidyverse)
library(fixest)

state_panel <- read_csv("Data/Processed/state_year_panel_final.csv")

# Check treatment pattern
table(state_panel$state, state_panel$treated)

# Optional: check switch year by state
state_panel %>%
  group_by(state) %>%
  summarise(
    first_treated_year = min(year[treated == 1], na.rm = TRUE)
  )

twfe_state_violent <- feols(
  violent_rate_100k ~ treated + unemp_rate + Black + HSGrad + IncomeReal + age |
    state + year,
  cluster = ~ state,      # cluster by state (only 3 clusters → inference very shaky)
  data = state_panel
)

twfe_state_property <- feols(
  property_rate_100k ~ treated + unemp_rate + Black + HSGrad + IncomeReal + age |
    state + year,
  cluster = ~ state,
  data = state_panel
)

twfe_state_total <- feols(
  total_rate_100k ~ treated + unemp_rate + Black + HSGrad + IncomeReal + age |
    state + year,
  cluster = ~ state,
  data = state_panel
)

summary(twfe_state_violent)
summary(twfe_state_property)
summary(twfe_state_total)

etable(
  twfe_state_violent, twfe_state_property, twfe_state_total,
  vcov = ~ state,
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
  tex  = TRUE,
  file = "Analysis/tables/twfe_state_table.tex"
)
library(broom)

twfe_state_coefs <- bind_rows(
  tidy(twfe_state_violent)  %>% mutate(model = "Violent"),
  tidy(twfe_state_property) %>% mutate(model = "Property"),
  tidy(twfe_state_total)    %>% mutate(model = "Total")
)

write_csv(twfe_state_coefs, "Analysis/tables/twfe_state_coefficients.csv")

library(ggplot2)
library(dplyr)

g_violent_state <- state_panel %>%
  group_by(state, year) %>%
  summarise(violent_rate_100k = mean(violent_rate_100k, na.rm = TRUE)) %>%
  ggplot(aes(x = year, y = violent_rate_100k, color = state)) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 1977, linetype = "dashed", color = "red") +
  geom_vline(xintercept = 1983, linetype = "dashed", color = "blue") +
  labs(
    title = "Violent Crime Trends by State",
    subtitle = "Red = Illinois switch (1977), Blue = Michigan switch (1983)",
    x = "Year", y = "Violent Crime Rate per 100k"
  ) +
  theme_minimal(base_size = 14)

g_violent_state

library(ggplot2)
library(dplyr)

g_property_state <- state_panel %>%
  group_by(state, year) %>%
  summarise(property_rate_100k = mean(property_rate_100k, na.rm = TRUE)) %>%
  ggplot(aes(x = year, y = property_rate_100k, color = state)) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 1977, linetype = "dashed", color = "red") +
  geom_vline(xintercept = 1983, linetype = "dashed", color = "blue") +
  labs(
    title = "Property Crime Trends by State",
    subtitle = "Red = Illinois switch (1977), Blue = Michigan switch (1983)",
    x = "Year", y = "Property Crime Rate per 100k"
  ) +
  theme_minimal(base_size = 14)

g_property_state

library(ggplot2)
library(dplyr)

g_total_state <- state_panel %>%
  group_by(state, year) %>%
  summarise(total_rate_100k = mean(total_rate_100k, na.rm = TRUE)) %>%
  ggplot(aes(x = year, y = total_rate_100k, color = state)) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 1977, linetype = "dashed", color = "red") +
  geom_vline(xintercept = 1983, linetype = "dashed", color = "blue") +
  labs(
    title = "Total Crime Trends by State",
    subtitle = "Red = Illinois switch (1977), Blue = Michigan switch (1983)",
    x = "Year", y = "Total Crime Rate per 100k"
  ) +
  theme_minimal(base_size = 14)

g_total_state

ggsave("Analysis/figs/state_trends_violent.png", g_violent_state,
       width = 10, height = 7)
ggsave("Analysis/figs/state_trends_property.png", g_property_state,
       width = 10, height = 7)
ggsave("Analysis/figs/state_trends_total.png", g_total_state,
       width = 10, height = 7)
