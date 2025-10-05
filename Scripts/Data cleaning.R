mydata <- readRDS("~/Desktop/ucr_offenses_1970_1992.rds")
class(mydata)
dim(mydata)
head(mydata)
# 1) Confirm the object exists
ls()
exists("ucr_offenses_1970_1992")

# 2) Inspect it (safe for big data)
class(ucr_offenses_1970_1992)
dim(ucr_offenses_1970_1992)
names(ucr_offenses_1970_1992)[1:20]
head(ucr_offenses_1970_1992)

# 3) If you want it named 'mydata'
mydata <- ucr_offenses_1970_1992

class(mydata)
dim(mydata)
names(mydata)
head(mydata, 10)
str(mydata)


library(dplyr)
mydata_clean <- mydata %>%
  select(state, state_abb, year, month, 
         zip_code, juvenile_age, population_group, population,
         actual_murder, actual_rape_total, actual_robbery_total,
         actual_assault_total, actual_burg_total, actual_theft_total,
         actual_mtr_veh_theft_total, actual_index_violent,
         actual_index_property, actual_index_total)

library(dplyr)

city_year_summary <- mydata_clean %>%
  # drop invalid rows up front
  filter(zip_code != 0, !is.na(juvenile_age)) %>%
  
  group_by(state, state_abb, zip_code, year) %>%
  summarise(
    # yearly totals for all offense columns that start with "actual_"
    across(matches("^actual_"), ~ sum(.x, na.rm = TRUE)),
    
    # yearly average population (ignore 0/NA months)
    population = {
      p <- population[!is.na(population) & population > 0]
      if (length(p)) mean(p) else NA_real_
    },
    
    # take a single value per group (first non-missing)
    juvenile_age     = first(na.omit(juvenile_age)),
    population_group = first(na.omit(population_group)),
    
    .groups = "drop"
  ) %>%
  # put columns in the order you want
  relocate(state, state_abb, juvenile_age, year, population, population_group) %>%
  arrange(state_abb, zip_code, year)

library(dplyr)
library(stringr)

state_group_year <- mydata_clean %>%
  # drop invalid rows
  filter(zip_code != 0, !is.na(juvenile_age)) %>%
  # map population_group to City vs County buckets (Option A)
  mutate(size_bucket = case_when(
    # ---- Cities ----
    population_group %in% c("city under 2,500", "city 2,500 thru 9,999",
                            "city 10,000 thru 24,999")                    ~ "City: Small (<25k)",
    population_group %in% c("city 25,000 thru 49,999", "city 50,000 thru 99,999")
    ~ "City: Medium (25–99k)",
    population_group == "city 100,000 thru 249,999"                       ~ "City: Large (100–249k)",
    population_group == "city 250,000 thru 499,999"                       ~ "City: Very large (250–499k)",
    population_group == "city 500,000 thru 999,999"                       ~ "City: Major (500–999k)",
    population_group == "city 1,000,000+"                                 ~ "City: Mega (1M+)",
    
    # ---- MSA counties ----
    population_group == "msa-county under 10,000"                         ~ "MSA County: Small (<10k)",
    population_group == "msa-county 10,000 thru 24,999"                   ~ "MSA County: Small (10–24k)",
    population_group == "msa-county 25,000 thru 99,999"                   ~ "MSA County: Medium (25–99k)",
    population_group == "msa-county 100,000+"                             ~ "MSA County: Large (100k+)",
    
    # ---- Non-MSA counties ----
    population_group == "non-msa county under 10,000"                     ~ "Non-MSA County: Small (<10k)",
    population_group == "non-msa county 10,000 thru 24,999"               ~ "Non-MSA County: Small (10–24k)",
    population_group == "non-msa county 25,000 thru 99,999"               ~ "Non-MSA County: Medium (25–99k)",
    population_group == "non-msa county 100,000+"                         ~ "Non-MSA County: Large (100k+)",
    
    population_group == "possessions"                                     ~ "Possessions",
    TRUE                                                                  ~ NA_character_
  )) %>%
  # aggregate under each state and group by year
  group_by(state, size_bucket, year) %>%
  summarise(
    across(matches("^actual_"), ~ sum(.x, na.rm = TRUE)),      # yearly totals
    population   = sum(pmax(population, 0), na.rm = TRUE),      # total pop in that group (year)
    juvenile_age = first(na.omit(juvenile_age)),                # state-level constant
    n_places     = n_distinct(zip_code),                        # how many cities/counties rolled up
    .groups = "drop"
  ) %>%
  # order columns as requested
  relocate(state, juvenile_age, year, population, size_bucket) %>%
  arrange(state, size_bucket, year)

state_group_year_sorted <- state_group_year %>%
  mutate(
    size_order = case_when(
      grepl("Mega|Major|Very large|Large", size_bucket) ~ 1L,
      grepl("Medium", size_bucket)                      ~ 2L,
      grepl("Small", size_bucket)                       ~ 3L,
      TRUE                                              ~ 4L
    )
  ) %>%
  arrange(state, year, size_order, size_bucket) %>%
  select(-size_order)

mydata <- mydata_clean
rm(mydata_clean)
saveRDS(mydata, "~/Desktop/mydata.rds")

# Save as CSV on Desktop
write.csv(city_year_summary, "~/Desktop/city_year_summary.csv", row.names = FALSE)
write.csv(state_group_year, "~/Desktop/state_group_year.csv", row.names = FALSE)
write.csv(state_group_year_sorted, "~/Desktop/state_group_year_sorted.csv", row.names = FALSE)

# (Optional) also save as RDS for fast re-loading in R
saveRDS(city_year_summary, "~/Desktop/city_year_summary.rds")
saveRDS(state_group_year, "~/Desktop/state_group_year.rds")
saveRDS(state_group_year_sorted, "~/Desktop/state_group_year_sorted.rds")

