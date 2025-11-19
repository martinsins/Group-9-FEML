library(tidyverse)
library(fixest)

crime <- read_csv("Data/Sorted/city_year_Iowa_Illinois_Michigan_1973_1991.csv")
gov   <- read_csv("Data/Sorted/governors_panel.csv")
demo  <- read_csv("Data/Raw/demo_year_state_1970_1992.csv")
unemp <- read_csv("Data/Raw/unemp_year_state_1970_1992.csv")

crime <- crime %>%
  mutate(
    violent_rate_100k  = (actual_index_violent / population) * 100000,
    property_rate_100k = (actual_index_property / population) * 100000,
    total_rate_100k    = (actual_index_total / population) * 100000
  )
crime <- crime %>%
  rename(city_id = zip_code)
crime <- crime %>%
  select(
    state, state_abb, city_id, year, population,
    violent_rate_100k, property_rate_100k, total_rate_100k
  )
write_csv(crime, "Data/Processed/city_year_crime_rates.csv")


gov2 <- gov %>%
  arrange(state, year) %>%
  group_by(state) %>%
  mutate(
    party_lag = lag(party),
    switched = if_else(party != party_lag, 1, 0),
    treat_start_raw = if_else(switched == 1, year, NA_real_)
  ) %>%
  summarise(
    treat_start = ifelse(all(is.na(treat_start_raw)),
                         NA,              # state never switches
                         min(treat_start_raw, na.rm = TRUE))  # first switch
    
crime <- read_csv("Data/Processed/city_year_crime_rates.csv")
crime <- crime %>%
  mutate(state = tolower(state))
gov2 <- gov2 %>%
  mutate(state = tolower(state))
panel <- crime %>%
  left_join(gov2, by = "state")

panel <- panel %>%
  mutate(event_time = year - treat_start)

write_csv(panel, "Data/Processed/city_year_panel_phase3_treatment_ready.csv")
write_csv(gov2, "Data/Processed/gov2_panel.csv")
