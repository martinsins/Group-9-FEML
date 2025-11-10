# ==== IL / IA / MI — 1973–1991 — villes >= POP_THRESHOLD : 3 fichiers exacts ====

# 0) Chemins
folder_path <- "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR"
clean_dir   <- file.path(folder_path, "Donnée clean")
if (!dir.exists(clean_dir)) dir.create(clean_dir, recursive = TRUE)

# 1) Packages
suppressPackageStartupMessages({
  library(dplyr)
  library(stringr)
})

# 2) Paramètres
YEAR_START    <- 1973
YEAR_END      <- 1991
states_keep   <- c("illinois","iowa","michigan")
POP_THRESHOLD <- 85000  # <<< Change UNIQUEMENT cette ligne si tu veux 60k, 100k, etc.

# 3) Charger la base mensuelle
rds_monthly <- file.path(folder_path, "ucr_offenses_1970_1992.rds")
stopifnot(file.exists(rds_monthly))
ucr <- readRDS(rds_monthly)

# 4) Colonnes utiles
mydata_clean <- ucr %>%
  select(state, state_abb, year, month,
         zip_code, juvenile_age, population_group, population,
         actual_murder, actual_rape_total, actual_robbery_total,
         actual_assault_total, actual_burg_total, actual_theft_total,
         actual_mtr_veh_theft_total, actual_index_violent,
         actual_index_property, actual_index_total)

# 5) Filtre États + période (PAS de seuil ici)  -> monthly_raw.*  (FICHIER 1)
monthly_raw <- mydata_clean %>%
  mutate(state_lower = tolower(state)) %>%
  filter(state_lower %in% states_keep,
         year >= YEAR_START, year <= YEAR_END) %>%
  select(-state_lower)

f1_base <- "monthly_raw_Iowa_Illinois_Michigan_1973_1991"
saveRDS(monthly_raw, file.path(clean_dir, paste0(f1_base, ".rds")))
write.csv(monthly_raw, file.path(clean_dir, paste0(f1_base, ".csv")), row.names = FALSE)
cat("\n✅ Écrit:", f1_base, ".(rds/csv)\n", sep = "")

# 6) Agrégation VILLE (ZIP) × ANNÉE (pas de seuil ici)
city_year <- monthly_raw %>%
  filter(zip_code != 0, !is.na(juvenile_age)) %>%
  group_by(state, state_abb, zip_code, year) %>%
  summarise(
    across(starts_with("actual_"), ~ sum(.x, na.rm = TRUE)),   # totaux annuels
    population = {
      p <- population[!is.na(population) & population > 0]
      if (length(p)) mean(p) else NA_real_
    },
    population_group = first(na.omit(population_group)),
    juvenile_age     = first(na.omit(juvenile_age)),
    .groups = "drop"
  )

# 7) Filtre "villes" + seuil de population + nettoyage "années sans relevés"
city_clean <- city_year %>%
  mutate(
    is_city = grepl("^city ", tolower(population_group)),
    all_offenses_zero = (coalesce(actual_index_violent, 0) +
                           coalesce(actual_index_property, 0) +
                           coalesce(actual_index_total, 0)) == 0
  ) %>%
  filter(
    is_city,
    !is.na(population), population >= POP_THRESHOLD,
    population > 0,
    !all_offenses_zero
  ) %>%
  select(-is_city, -all_offenses_zero)

# 8) city_year (≥ seuil, CLEAN) — même NOM demandé (FICHIER 2)
#    ⚠️ Le contenu est maintenant RESTREINT aux villes >= POP_THRESHOLD.
f2_base <- "city_year_Iowa_Illinois_Michigan_1973_1991"
saveRDS(city_clean, file.path(clean_dir, paste0(f2_base, ".rds")))
write.csv(city_clean, file.path(clean_dir, paste0(f2_base, ".csv")), row.names = FALSE)
cat("✅ Écrit:", f2_base, ".(rds/csv)  [contenu: villes >= ", POP_THRESHOLD, "]\n", sep = "")

# 9) Reconstruire 'size_bucket' (pour l’agrégation ÉTAT × TAILLE × ANNÉE)
map_bucket <- function(pg){
  dplyr::case_when(
    pg %in% c("city under 2,500","city 2,500 thru 9,999","city 10,000 thru 24,999") ~ "City: Small (<25k)",
    pg %in% c("city 25,000 thru 49,999","city 50,000 thru 99,999")                   ~ "City: Medium (25–99k)",
    pg == "city 100,000 thru 249,999"                                                ~ "City: Large (100–249k)",
    pg == "city 250,000 thru 499,999"                                                ~ "City: Very large (250–499k)",
    pg == "city 500,000 thru 999,999"                                                ~ "City: Major (500–999k)",
    pg == "city 1,000,000+"                                                          ~ "City: Mega (1M+)",
    TRUE ~ NA_character_
  )
}

state_group_year_sorted_MI_IL_IA_1973_1991 <- city_clean %>%
  mutate(size_bucket = map_bucket(population_group)) %>%
  group_by(state, size_bucket, year) %>%
  summarise(
    across(starts_with("actual_"), ~ sum(.x, na.rm = TRUE)),
    population   = sum(population, na.rm = TRUE),
    n_cities     = n_distinct(zip_code),
    .groups = "drop"
  ) %>%
  mutate(
    violent_rate_100k  = ifelse(population > 0, 1e5 * actual_index_violent  / population, NA_real_),
    property_rate_100k = ifelse(population > 0, 1e5 * actual_index_property / population, NA_real_),
    total_rate_100k    = ifelse(population > 0, 1e5 * actual_index_total    / population, NA_real_)
  ) %>%
  arrange(state, size_bucket, year)

# 10) state_group_year_sorted (≥ seuil) — même NOM demandé (FICHIER 3)
#     ⚠️ Contenu basé uniquement sur les villes >= POP_THRESHOLD
f3_base <- "state_group_year_sorted_MI_IL_IA_1973_1991"
saveRDS(state_group_year_sorted_MI_IL_IA_1973_1991, file.path(clean_dir, paste0(f3_base, ".rds")))
write.csv(state_group_year_sorted_MI_IL_IA_1973_1991, file.path(clean_dir, paste0(f3_base, ".csv")), row.names = FALSE)
cat("✅ Écrit:", f3_base, ".(rds/csv)  [contenu: agrégé depuis villes >= ", POP_THRESHOLD, "]\n", sep = "")

# 11) Diagnostics rapides (utile pour vérifier ton échantillon)
cat("\n──────── DIAGNOSTICS — villes >=", POP_THRESHOLD, " (", YEAR_START, "–", YEAR_END, ") ────────\n", sep = "")
cat("Ville-année (rows) :", nrow(city_clean), "\n")
cat("Villes distinctes  :", n_distinct(city_clean$zip_code), "\n")

print(
  city_clean %>%
    summarise(n_cities = n_distinct(zip_code),
              n_years  = n_distinct(year),
              years_min = min(year), years_max = max(year),
              .by = state)
)

cat("\nObs par État × année (ville-année):\n")
print(
  city_clean %>%
    count(state, year, name = "n_obs") %>%
    arrange(state, year),
  n = Inf
)

cat("\nTaille de ville présente après filtre (état × bucket):\n")
print(
  state_group_year_sorted_MI_IL_IA_1973_1991 %>%
    count(state, size_bucket, name = "n_obs") %>%
    arrange(state, size_bucket),
  n = Inf
)

cat("\n✅ Terminé. Fichiers écrits dans:", normalizePath(clean_dir), "\n")

cat("\n──────── LISTE DES VILLES (>= ", POP_THRESHOLD, ") PAR ÉTAT ────────\n", sep = "")
city_clean %>%
  group_by(state) %>%
  summarise(villes = paste(unique(zip_code), collapse = ", ")) %>%
  print(n = Inf)

###GRAPHS

# === APPENDIX — Graphs for IL / IA / MI (cities >= THRESHOLD) ===
suppressPackageStartupMessages({
  library(dplyr); library(tidyr); library(ggplot2); library(stringr)
})

# ---- Params ----
THRESHOLD   <- 90000     # mets 85000 si tu préfères
COMMON_YEARS <- TRUE     # TRUE = on ne garde que l'intersection des années communes aux 3 États

# ---- Paths (reuse your clean_dir if it exists) ----
if (!exists("clean_dir")) {
  folder_path <- "C:/Users/Guillaume/Documents/Master/1 er semestre/Econometrics/Project/Données/UCR"
  clean_dir   <- file.path(folder_path, "Donnée clean")
}
city_csv <- file.path(clean_dir, "city_year_Iowa_Illinois_Michigan_1973_1991.csv")
stopifnot(file.exists(city_csv))

city <- read.csv(city_csv, check.names = FALSE)

# ---- Filter: cities >= threshold ----
city_f <- city %>%
  filter(!is.na(population), population > 0, population >= THRESHOLD) %>%
  mutate(state = tolower(state))

# Option: keep only years common to all 3 states
if (COMMON_YEARS) {
  common_years <- city_f %>% distinct(state, year) %>% count(year) %>% filter(n == 3) %>% pull(year)
  city_f <- city_f %>% filter(year %in% common_years)
}

# ========= 1) Aggregates (Violent / Property / Total) =========
state_year_agg <- city_f %>%
  group_by(state, year) %>%
  summarise(
    pop_sum  = sum(population, na.rm = TRUE),
    violent  = sum(actual_index_violent,  na.rm = TRUE),
    property = sum(actual_index_property, na.rm = TRUE),
    total    = sum(actual_index_total,    na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    violent_rate_100k  = ifelse(pop_sum > 0, 1e5 * violent  / pop_sum, NA_real_),
    property_rate_100k = ifelse(pop_sum > 0, 1e5 * property / pop_sum, NA_real_),
    total_rate_100k    = ifelse(pop_sum > 0, 1e5 * total    / pop_sum, NA_real_)
  ) %>%
  select(state, year, violent_rate_100k, property_rate_100k, total_rate_100k) %>%
  pivot_longer(ends_with("_rate_100k"), names_to = "type", values_to = "rate_100k") %>%
  mutate(type = recode(type,
                       violent_rate_100k  = "Violent crimes",
                       property_rate_100k = "Property crimes",
                       total_rate_100k    = "Total index"))

p1 <- ggplot(state_year_agg, aes(x = year, y = rate_100k, color = type)) +
  geom_line(linewidth = 1) +
  facet_wrap(~ state, scales = "free_y", ncol = 1) +
  labs(
    title = paste0("Average crime rates (pop-weighted) — Cities ≥", format(THRESHOLD, big.mark=" "),
                   " — IL / IA / MI"),
    subtitle = if (COMMON_YEARS) "Common years across all three states" else "All available years per state",
    x = "Year", y = "Crimes per 100,000 inhabitants", color = "Series"
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "bottom")

print(p1)

# Save
plots_dir <- file.path(clean_dir, "plots"); if (!dir.exists(plots_dir)) dir.create(plots_dir, TRUE)
out1 <- file.path(plots_dir, paste0("agg_trends_states_ge", THRESHOLD,
                                    if (COMMON_YEARS) "_commonyears" else "", ".png"))
ggsave(out1, p1, width = 9, height = 8, dpi = 300)
cat("✅ Saved:", out1, "\n")

# ========= 2) Details by offense (7 components) =========
detail <- city_f %>%
  group_by(state, year) %>%
  summarise(
    pop_sum  = sum(population, na.rm = TRUE),
    murder   = sum(actual_murder,                na.rm = TRUE),
    rape     = sum(actual_rape_total,            na.rm = TRUE),
    robbery  = sum(actual_robbery_total,         na.rm = TRUE),
    assault  = sum(actual_assault_total,         na.rm = TRUE),
    burglary = sum(actual_burg_total,            na.rm = TRUE),
    larceny  = sum(actual_theft_total,           na.rm = TRUE),
    mv_theft = sum(actual_mtr_veh_theft_total,   na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(across(c(murder:mv_theft),
                ~ ifelse(pop_sum > 0, 1e5 * .x / pop_sum, NA_real_),
                .names = "{.col}_rate_100k")) %>%
  select(state, year, ends_with("_rate_100k")) %>%
  pivot_longer(ends_with("_rate_100k"), names_to = "offense", values_to = "rate_100k") %>%
  mutate(offense = offense %>% str_replace("_rate_100k", "") %>%
           recode(murder="Murder", rape="Rape", robbery="Robbery", assault="Assault",
                  burglary="Burglary", larceny="Larceny-theft", mv_theft="Motor vehicle theft"))

p2 <- ggplot(detail, aes(x = year, y = rate_100k)) +
  geom_line(linewidth = 0.8) +
  facet_grid(state ~ offense, scales = "free_y") +
  labs(
    title = paste0("Crime rates by offense — Cities ≥", format(THRESHOLD, big.mark=" "), " — IL / IA / MI"),
    subtitle = if (COMMON_YEARS) "Common years across all three states" else "All available years per state",
    x = "Year", y = "Crimes per 100,000 inhabitants"
  ) +
  theme_minimal(base_size = 12)

print(p2)

out2 <- file.path(plots_dir, paste0("offense_trends_states_ge", THRESHOLD,
                                    if (COMMON_YEARS) "_commonyears" else "", ".png"))
ggsave(out2, p2, width = 12, height = 8, dpi = 300)
cat("✅ Saved:", out2, "\n")

# ---- Quick console recap ----
cat("\n──────── SUMMARY (≥", THRESHOLD, ") ────────\n", sep = "")
cat("States:", paste(sort(unique(city_f$state)), collapse = ", "), "\n")
print(city_f %>% group_by(state) %>% summarise(min_year=min(year), max_year=max(year), .groups="drop"))
cat("Rows (city-year):", nrow(city_f), " | Distinct cities:", n_distinct(city_f$zip_code), "\n")


# --- PATCH PLOT: offenses avec échelles Y libres (Murder, Rape visibles) ---
p_off <- ggplot(detail, aes(x = year, y = rate_100k)) +
  geom_line(linewidth = 0.8) +
  facet_grid(state ~ offense, scales = "free_y") +
  labs(
    title = "Crime rates by offense — Cities ≥90 000 — IL / IA / MI",
    subtitle = "Common years across all three states",
    x = "Year", y = "Crimes per 100,000 inhabitants"
  ) +
  theme_minimal(base_size = 12)

print(p_off)

# (Optionnel) sauvegarde
ggsave(file.path(clean_dir, "plots/offense_trends_states_ge90000_freeY.png"),
       p_off, width = 12, height = 8, dpi = 300)
cat("✅ Saved plot with free Y scales.\n")


