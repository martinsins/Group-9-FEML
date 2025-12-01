# ================================================================
#   STATE-LEVEL AGGREGATION — IL / IA / MI — 1973–1991
#   One row per STATE × YEAR (no ZIP filtering, no population threshold)
# ================================================================

# 0) Paths
folder_path <- "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR"
clean_dir   <- file.path(folder_path, "State-level data")
if (!dir.exists(clean_dir)) dir.create(clean_dir, recursive = TRUE)

# 1) Packages
suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(tidyr)
})

# 2) Parameters
states_keep <- c("illinois", "iowa", "michigan")
YEAR_START  <- 1973
YEAR_END    <- 1991

# 3) Load UCR monthly data
rds_monthly <- file.path(folder_path, "ucr_offenses_1970_1992.rds")
stopifnot(file.exists(rds_monthly))
ucr <- readRDS(rds_monthly)

# 4) Select relevant columns
ucr_clean <- ucr %>%
  select(
    state, year, population,
    actual_murder, actual_rape_total, actual_robbery_total,
    actual_assault_total, actual_burg_total, actual_theft_total,
    actual_mtr_veh_theft_total, actual_index_violent,
    actual_index_property, actual_index_total
  )

# 5) Keep only IL / IA / MI + years
ucr_filt <- ucr_clean %>%
  mutate(state = tolower(state)) %>%
  filter(
    state %in% states_keep,
    year >= YEAR_START, year <= YEAR_END
  )

# ================================================================
# 6) AGGREGATION : STATE × YEAR
# ================================================================

state_year <- ucr_filt %>%
  group_by(state, year) %>%
  summarise(
    pop_sum = sum(population, na.rm = TRUE),
    murder   = sum(actual_murder, na.rm = TRUE),
    rape     = sum(actual_rape_total, na.rm = TRUE),
    robbery  = sum(actual_robbery_total, na.rm = TRUE),
    assault  = sum(actual_assault_total, na.rm = TRUE),
    burglary = sum(actual_burg_total, na.rm = TRUE),
    larceny  = sum(actual_theft_total, na.rm = TRUE),
    mv_theft = sum(actual_mtr_veh_theft_total, na.rm = TRUE),
    violent  = sum(actual_index_violent, na.rm = TRUE),
    property = sum(actual_index_property, na.rm = TRUE),
    total    = sum(actual_index_total, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    violent_rate_100k  = 1e5 * violent  / pop_sum,
    property_rate_100k = 1e5 * property / pop_sum,
    total_rate_100k    = 1e5 * total    / pop_sum
  ) %>%
  arrange(state, year)

# Save file
out_csv <- file.path(clean_dir, "state_year_Iowa_Illinois_Michigan_1973_1991.csv")
write.csv(state_year, out_csv, row.names = FALSE)
cat("✅ Saved:", out_csv, "\n")

# ================================================================
# 7) PLOT: TOTAL / VIOLENT / PROPERTY — 3 STATES
# ================================================================

plots_dir <- file.path(clean_dir, "state_year_plots")
if (!dir.exists(plots_dir)) dir.create(plots_dir)

state_year_long <- state_year %>%
  select(state, year, violent_rate_100k, property_rate_100k, total_rate_100k) %>%
  pivot_longer(
    cols = ends_with("rate_100k"),
    names_to = "type",
    values_to = "rate"
  ) %>%
  mutate(type = recode(type,
                       violent_rate_100k = "Violent crime",
                       property_rate_100k = "Property crime",
                       total_rate_100k = "Total crime"))

p1 <- ggplot(state_year_long, aes(x = year, y = rate, color = state)) +
  geom_line(size = 1.1) +
  facet_wrap(~ type, scales = "free_y") +
  labs(
    title = "State-level crime rates (IL / IA / MI), 1973–1991",
    x = "Year", y = "Crimes per 100,000 inhabitants",
    color = "State"
  ) +
  theme_minimal(base_size = 15)

ggsave(file.path(plots_dir, "state_year_crime_rates.png"), p1,
       width = 12, height = 8, dpi = 300)

cat("✅ Saved plot:", file.path(plots_dir, "state_year_crime_rates.png"), "\n")

# ================================================================
# 8) SUCCESS MESSAGE
# ================================================================
cat("\n🎉 DONE! Your new STATE-LEVEL dataset + graph are ready.\n")
cat("Rows:", nrow(state_year), " --- Expected ~ 57 (3 states × 19 years)\n")

