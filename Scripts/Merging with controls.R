library(tidyverse)

# -----------------------------
# 1. Fix DEMOGRAPHICS (state-year)
# -----------------------------
demo <- read_csv("Data/Raw/demo_year_state_1970_1992.csv")

demo <- demo %>%
  # rename to match panel
  rename(state = statefip) %>%
  mutate(state = tolower(state)) %>%  # ensure lowercase
  select(state, year, age, Male, Black, Hispanic, HSGrad, CollegeGrad, IncomeReal)
# -----------------------------
# 2. Fix UNEMPLOYMENT
# -----------------------------
unemp <- read_csv("Data/Raw/unemp_year_state_1970_1992.csv")

unemp <- unemp %>%
  rename(
    state = `State/Area`,
    year  = Year,
    unemp_rate = `Percent (%) of Labor Force Unemployed in State/Area`
  ) %>%
  mutate(state = tolower(state)) %>%
  select(state, year, unemp_rate)

# -----------------------------
# 3. Load panel
# -----------------------------
panel <- read_csv("Data/Processed/city_year_panel_clean.csv")

# -----------------------------
# 4. Merge unemployment + demographics
# -----------------------------
panel_controls <- panel %>%
  left_join(unemp, by = c("state", "year")) %>%
  left_join(demo,  by = c("state", "year"))

# -----------------------------
# 5. Check result
# -----------------------------
head(select(panel_controls, state, year, city_id,
            violent_rate_100k, unemp_rate, Black, HSGrad, IncomeReal, age))

# -----------------------------
# 6. Save final dataset
# -----------------------------
write_csv(panel_controls, "Data/Processed/city_year_panel_with_controls.csv")