unemp2 <- unemp %>%
  rename(
    state = `State/Area`,
    year  = Year,
    unemp_rate = `Percent (%) of Labor Force Unemployed in State/Area`
  ) %>%
  mutate(state = tolower(state)) %>%
  select(state, year, unemp_rate)

demo2 <- demo %>%
  rename(state = statefip) %>%
  mutate(state = tolower(state)) %>%
  select(state, year, age, Male, Black, Hispanic, HSGrad, CollegeGrad, IncomeReal)

panel4 <- panel %>%
  left_join(unemp2, by = c("state", "year")) %>%
  left_join(demo2,  by = c("state", "year"))
twfe_property <- feols(
  property_rate_100k ~ Gov_Rep + unemp_rate + Black + HSGrad + IncomeReal + age |
    city_id + year,
  cluster = ~ state,
  data = panel4
)

panel <- panel4
write_csv(panel, "Data/Processed/city_year_panel_final.csv")
list.files("Data/Processed")

