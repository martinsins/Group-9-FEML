folder_path <- "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR"
ucr_offenses_1970_1992 <- readRDS(file.path(folder_path, "ucr_offenses_1970_1992.rds"))
dim(ucr_offenses_1970_1992)

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
write.csv(city_year_summary, "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR/Donnée clean/city_year_summary.csv", row.names = FALSE)
write.csv(state_group_year, "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR/Donnée clean/state_group_year.csv", row.names = FALSE)
write.csv(state_group_year_sorted, "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR/Donnée clean/state_group_year_sorted.csv", row.names = FALSE)

# (Optional) also save as RDS for fast re-loading in R
saveRDS(city_year_summary, "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR/Donnée clean/city_year_summary.rds")
saveRDS(state_group_year, "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR/Donnée clean/state_group_year.rds")
saveRDS(state_group_year_sorted, "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR/Donnée clean/state_group_year_sorted.rds")


#File to see governors
library(dplyr)

# Mets le chemin correct vers ton fichier
gov_path <- "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR/governors.csv"

governors <- read.csv(gov_path)

# Regarde les premières lignes
head(governors)

stab <- governors %>%
  filter(year >= 1970, year <= 1992) %>%
  group_by(state) %>%
  summarise(
    parties = n_distinct(party),
    unique_parties = paste(unique(party), collapse = "/")
  ) %>%
  mutate(
    status = case_when(
      parties == 1 & grepl("Democrat", unique_parties, ignore.case = TRUE) ~ "Resté Démocrate",
      parties == 1 & grepl("Republican", unique_parties, ignore.case = TRUE) ~ "Resté Républicain",
      TRUE ~ "A changé"
    )
  )

print(stab)

write.csv(stab, file.path(dirname(gov_path), "governors_stability_1970_1992.csv"), row.names = FALSE)

# === FILTER FROM CLEAN FILE: keep only Iowa (IA) and Maryland (MD) ===
library(dplyr)

# 0) Ensure base folder exists
if (!exists("folder_path")) {
  folder_path <- "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR"
}
clean_dir <- file.path(folder_path, "Donnée clean")

# 1) Helper to read state_group_year_sorted (prefer RDS, else CSV)
read_state_group_year_sorted <- function(dir) {
  rds_path <- file.path(dir, "state_group_year_sorted.rds")
  csv_path <- file.path(dir, "state_group_year_sorted.csv")
  if (file.exists(rds_path)) {
    readRDS(rds_path)
  } else if (file.exists(csv_path)) {
    read.csv(csv_path, check.names = FALSE)
  } else {
    stop("state_group_year_sorted.(rds/csv) not found in: ", dir)
  }
}

sgy_sorted <- read_state_group_year_sorted(clean_dir)

# 2) Keep only Iowa & Maryland (robust to capitalization)
sgy_MD_IA <- sgy_sorted %>%
  mutate(state_lower = tolower(state)) %>%
  filter(state_lower %in% c("iowa", "maryland")) %>%
  select(-state_lower)

# Quick checks
cat("Rows kept (IA + MD): ", nrow(sgy_MD_IA), "\n")
if ("state" %in% names(sgy_MD_IA)) print(table(sgy_MD_IA$state, useNA = "ifany"))

# 3) Save the detailed (by size_bucket) subset
out_dir <- clean_dir
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

saveRDS(sgy_MD_IA, file.path(out_dir, "state_group_year_sorted_MD_IA.rds"))
write.csv(sgy_MD_IA, file.path(out_dir, "state_group_year_sorted_MD_IA.csv"), row.names = FALSE)

# 4) Build a STATE-YEAR aggregate (sums across size buckets)
#    -> one row per state-year, plus rates per 100k
agg_MD_IA <- sgy_MD_IA %>%
  group_by(state, year) %>%
  summarise(
    across(matches("^actual_"), ~ sum(.x, na.rm = TRUE)),
    population = sum(pmax(population, 0), na.rm = TRUE),
    n_groups   = n(),                # number of size_buckets aggregated
    .groups = "drop"
  ) %>%
  mutate(
    violent_rate_100k  = ifelse(population > 0, 1e5 * actual_index_violent  / population, NA_real_),
    property_rate_100k = ifelse(population > 0, 1e5 * actual_index_property / population, NA_real_),
    total_rate_100k    = ifelse(population > 0, 1e5 * actual_index_total    / population, NA_real_)
  ) %>%
  arrange(state, year)

# Save the aggregated state-year file
saveRDS(agg_MD_IA, file.path(out_dir, "state_year_agg_MD_IA.rds"))
write.csv(agg_MD_IA, file.path(out_dir, "state_year_agg_MD_IA.csv"), row.names = FALSE)

cat("✅ Saved:\n - ", file.path(out_dir, "state_group_year_sorted_MD_IA.rds"),
    "\n - ", file.path(out_dir, "state_group_year_sorted_MD_IA.csv"),
    "\n - ", file.path(out_dir, "state_year_agg_MD_IA.rds"),
    "\n - ", file.path(out_dir, "state_year_agg_MD_IA.csv"), "\n", sep = "")


