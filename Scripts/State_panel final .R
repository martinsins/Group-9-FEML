library(dplyr)
library(readr)

state_year <- read_csv("Data/Sorted/state_year_iowa_illinois_Michigan_1973_1991.csv")
gov <- read_csv("Data/Sorted/governors_panel.csv")

state_year <- state_year %>%
  left_join(gov, by = c("state", "year"))

state_year <- state_year %>%
  mutate(
    Gov_Rep = if_else(party == "Republican", 1L, 0L)
  ) %>%
  group_by(state) %>%
  mutate(
    # if a state is never Republican → NA
    treat_start = if (all(Gov_Rep == 0L | is.na(Gov_Rep))) {
      NA_integer_
    } else {
      min(year[Gov_Rep == 1L], na.rm = TRUE)
    }
  ) %>%
  ungroup()

state_year <- state_year %>%
  mutate(
    # ever treated indicator
    ever_treated = if_else(!is.na(treat_start), 1L, 0L),
    
    # treatment status in each year: 1 only after the switch, 0 otherwise
    treated = if_else(ever_treated == 1L & year >= treat_start, 1L, 0L),
    
    # event time: years relative to the switch, NA for never-treated
    event_time = if_else(ever_treated == 1L, year - treat_start, NA_integer_)
  )

# Unemployment
unemp2 <- unemp %>%
  rename(
    state      = `State/Area`,
    year       = Year,
    unemp_rate = `Percent (%) of Labor Force Unemployed in State/Area`
  ) %>%
  mutate(state = tolower(state)) %>%   # "Illinois" → "illinois"
  select(state, year, unemp_rate)
library(tidyverse)

# Read controls (if not already done in this script)
unemp_raw <- read_csv("Data/Raw/unemp_year_state_1970_1992.csv")
demo_raw  <- read_csv("Data/Raw/demo_year_state_1970_1992.csv")
unemp2 <- unemp_raw %>%
  rename(
    state      = `State/Area`,
    year       = Year,
    unemp_rate = `Percent (%) of Labor Force Unemployed in State/Area`
  ) %>%
  mutate(state = tolower(state)) %>%
  select(state, year, unemp_rate)

# Demographics
demo2 <- demo_raw %>%
  rename(state = statefip) %>%
  mutate(state = tolower(state)) %>%
  select(state, year, age, Male, Black, Hispanic, HSGrad, CollegeGrad, IncomeReal)
state_panel <- state_year %>%
  mutate(state = tolower(state)) %>%
  left_join(unemp2, by = c("state", "year")) %>%
  left_join(demo2,  by = c("state", "year"))

# Quick sanity check
state_panel %>%
  select(state, year, property_rate_100k, violent_rate_100k,
         unemp_rate, Black, HSGrad, IncomeReal, age) %>%
  head()

write_csv(state_panel, "Data/Processed/state_year_panel_final.csv")
