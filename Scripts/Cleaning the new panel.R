library(dplyr)

panel_clean <- panel %>%
  # use zip_code as the "city" identifier
  rename(city_id = zip_code) %>%
  select(
    # IDs
    state,
    state_abb,
    city_id,
    year,
    population,
    
    # outcomes (Y)
    violent_rate_100k,
    property_rate_100k,
    total_rate_100k,
    
    # treatment + event-study stuff
    party,
    Gov_Rep,
    treat_start,
    event_time,
    starts_with("event_")    # event_-5 ... event_+5
  )
names(panel_clean)
head(panel_clean)

write_csv(panel_clean, "Data/Processed/city_year_panel_clean.csv")