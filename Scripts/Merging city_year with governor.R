library(tidyverse)

# 1. Load your two existing datasets
city <- read_csv("Data/Processed/city_year_panel.csv")
gov  <- read_csv("Data/Sorted/governors_panel.csv")
# gov has: state, year, party ("Democrat"/"Republican")

# 2. Create Gov_Rep dummy and event-time within each state
gov <- gov %>%
  mutate(
    Gov_Rep = if_else(party == "Republican", 1L, 0L)
  ) %>%
  group_by(state) %>%
  mutate(
    # first year the state becomes Republican (treatment start)
    treat_start = if_else(Gov_Rep == 1 & lag(Gov_Rep, default = 0) == 0,
                          year, NA_integer_)
  ) %>%
  fill(treat_start, .direction = "down") %>%
  mutate(
    event_time = if_else(!is.na(treat_start), year - treat_start, NA_integer_)
  ) %>%
  ungroup()

# (optional) event-study dummies, -5..+5
for (k in -5:5) {
  varname <- paste0("event_", ifelse(k >= 0, paste0("+", k), k))
  gov[[varname]] <- if_else(gov$event_time == k, 1L, 0L)
}

# 3. Merge with the city-year panel
panel <- city %>%
  left_join(gov, by = c("state", "year"))

# Quick sanity check
head(select(panel, state, year, Gov_Rep, party, event_time))

write_csv(panel, "Data/Processed/city_year_panel_with_gov.csv")
