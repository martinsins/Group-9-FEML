library(tidyverse)

#--------------------------------------------------
# 1. Read state-year crime panel and governor data
#--------------------------------------------------

state_year <- read_csv("Data/Sorted/state_year_iowa_illinois_Michigan_1973_1991.csv") %>%
  mutate(state = tolower(state))

gov_raw <- read_csv("Data/Sorted/governors_panel.csv") %>%
  mutate(state = tolower(state))

#--------------------------------------------------
# 2. Build treatment: first party switch in each state
#--------------------------------------------------

# 2.1 Compute party changes over time by state
gov2 <- gov_raw %>%
  arrange(state, year) %>%
  group_by(state) %>%
  mutate(
    prev_party = lag(party),
    # a switch occurs when party != previous party
    switched   = if_else(!is.na(prev_party) & party != prev_party, 1L, 0L)
  ) %>%
  ungroup()

# 2.2 First year with a switch = treat_start; NA if no switch
switch_years <- gov2 %>%
  group_by(state) %>%
  summarise(
    treat_start = if (all(switched == 0L | is.na(switched))) {
      NA_integer_
    } else {
      min(year[switched == 1L], na.rm = TRUE)
    },
    .groups = "drop"
  )

#--------------------------------------------------
# 3. Merge governors + treatment into state-year panel
#--------------------------------------------------

state_year <- state_year %>%
  left_join(
    gov2 %>% select(state, year, party),  # keep one party variable per year
    by = c("state", "year")
  ) %>%
  left_join(switch_years, by = "state") %>%
  mutate(
    # ever-treated state (has a switch)
    ever_treated = if_else(!is.na(treat_start), 1L, 0L),
    # treated years = years at/after first switch (only if ever-treated)
    treated      = if_else(ever_treated == 1L & year >= treat_start, 1L, 0L),
    # event time relative to first switch; NA for never-treated
    event_time   = if_else(ever_treated == 1L,
                           year - treat_start,
                           NA_integer_)
  )

# Quick sanity check: treatment pattern by state
state_year %>%
  select(state, year, party, treat_start, treated, event_time) %>%
  arrange(state, year) %>%
  print(n = Inf)
# You should see:
# - Iowa: treat_start = NA, treated = 0, event_time = NA
# - Illinois: treat_start = 1977, event_time 0 in 1977, negatives before, positives after
# - Michigan: treat_start = year of its first party change, same logic

#--------------------------------------------------
# 4. Add unemployment and demographics
#--------------------------------------------------

# 4.1 Unemployment
unemp_raw <- read_csv("Data/Raw/unemp_year_state_1970_1992.csv")

unemp2 <- unemp_raw %>%
  rename(
    state      = `State/Area`,
    year       = Year,
    unemp_rate = `Percent (%) of Labor Force Unemployed in State/Area`
  ) %>%
  mutate(state = tolower(state)) %>%
  select(state, year, unemp_rate)

# 4.2 Demographics
demo_raw <- read_csv("Data/Raw/demo_year_state_1970_1992.csv")

demo2 <- demo_raw %>%
  rename(state = statefip) %>%
  mutate(state = tolower(state)) %>%
  select(state, year, age, Male, Black, Hispanic, HSGrad, CollegeGrad, IncomeReal)

# 4.3 Merge controls into the panel
state_panel <- state_year %>%
  left_join(unemp2, by = c("state", "year")) %>%
  left_join(demo2,  by = c("state", "year"))

# Quick check
state_panel %>%
  select(state, year, property_rate_100k, violent_rate_100k,
         treated, event_time,
         unemp_rate, Black, HSGrad, IncomeReal, age) %>%
  arrange(state, year) %>%
  head(20)

#--------------------------------------------------
# 5. Save final state-level panel
#--------------------------------------------------

write_csv(state_panel, "Data/Processed/state_year_panel_final.csv")