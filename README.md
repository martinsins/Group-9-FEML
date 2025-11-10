# Governors & Crime (IL/IA/MI, 1973–1991): DiD/FE

## Goal
Estimate how state governor party (R vs D) relates to city-level crime rates (violent, property) via DiD with city and year fixed effects, plus event-study for pre-trends.

## Data layout
- `Data/Raw/`: original city-year crime & population
- `Data/External/gov_party_states_1970_1992.csv`: governor party by state-year with `switch_year`
- `Data/Processed/`: analysis-ready panels

## Repro steps
```bash
R -q -e "renv::restore()"
Rscript Scripts/00_data_check.R
Rscript Scripts/01_governor_party.R
Rscript Scripts/02_baseline_twfe.R
Rscript Scripts/03_staggered_did.R
Rscript Scripts/04_robustness.R
Rscript Scripts/05_figs_tables.R
```

Group-9-FEML/
├─ README.md
├─ LICENSE
├─ .gitignore
├─ group-9-FoE.Rproj
├─ renv.lock
├─ renv/
├─ Data/
│  ├─ Raw/          # original downloads (not committed)
│  ├─ External/     # small, cleaned covariates & lookups (commit if allowed)
│  ├─ Interim/      # temporary outputs
│  └─ Processed/    # analysis-ready panel (RDS/CSV)
├─ Scripts/
│  ├─ 00_data_check.R
│  ├─ 00b_covariates_build.R
│  ├─ 01_governor_party.R
│  ├─ 02_baseline_twfe.R
│  ├─ 03_staggered_did.R
│  ├─ 04_robustness.R
│  └─ 05_figs_tables.R
├─ Analysis/
│  ├─ figs/
│  ├─ tables/
│  └─ report.Rmd
└─ .github/workflows/
   └─ r-pipeline.yml


# A tight, do-able workflow

### 1. Lock the research design
- **Outcomes:** select three to five primary measures (e.g., violent, property, burglary, robbery).
- **Treatment:** define an indicator for Republican (or Democratic) governor and include event-time dummies for an event-study specification.
- **Units & time:** use the city-year panel as the baseline; optionally add a state-year panel for aggregate checks.
- **Sample rule:** retain only cities with population ≥ 85k (the current README already restricts to 28 cities).

### 2. Data audit & build
- Start from `city_year_Iowa_Illinois_Michigan_1973_1991.csv` as the core table; keep `monthly_raw_...` files only if you plan to model seasonality or AR terms; keep `state_group_year_...` for state-year robustness exercises.
- Create a tidy panel with `city_id`, `state`, `year`, outcomes, population, and socio-economic controls (poverty, income, racial composition, density) where available.
- Merge governor party by state-year, coding turnover years for Illinois and Michigan and the constant path for Iowa.

### 3. Identification & specifications (baseline → event-study)
**Baseline TWFE (city & year FE)**

$$
y_{cst} = \beta \cdot \text{RepGov}_{st} + \gamma_c + \delta_t + X'_{cst}\theta + \varepsilon_{cst}
$$

Cluster standard errors at the state level (conservative) or employ two-way clustering (city & year).

**Event-study (pre-trends)**

$$
y_{cst} = \sum_{k\neq -1} \beta_k \mathbf{1}[\text{years since switch} = k] + \gamma_c + \delta_t + X'_{cst}\theta + \varepsilon_{cst}
$$

Plot \(\beta_k\) with confidence intervals and verify pre-period coefficients are near zero.

**Staggered DiD correction (optional)**

Apply Sun & Abraham or Callaway & Sant’Anna estimators to account for staggered adoption (e.g., `fixest::sunab()` or the `did` package in R).

### 4. Robustness & falsification
- Alternative outcomes: run offense-specific categories.
- Alternative samples: drop one state at a time; raise the population threshold (≥ 100k) to test whether large cities drive results.
- Alternative trends: add state-specific linear trends or region-year fixed effects if the scope expands.
- Placebos: shift the treatment switch three years earlier and expect null effects.
- Weights: compare population-weighted vs. unweighted estimates.
- Inference: use wild bootstrap clustered by state (note small number of clusters).

### 5. Interpretation & write-up
- Summarize coefficient signs and magnitudes as percentages relative to sample means.
- Discuss potential mechanisms (budgeting, policing directives) as hypotheses rather than definitive channels.
- State limitations clearly: only three states and non-random governance changes.

## Concrete to-dos (R-first)

| Script | Focus |
| --- | --- |
| `Scripts/00_data_check.R` | Read `city_year_...csv`, inspect duplicates/missingness/units/outliers, and build `crime_rate = 100000 * crimes / pop`. |
| `Scripts/01_governor_party.R` | Create `gov_party_st_year` with Illinois/Michigan turnover years and Iowa’s constant series; construct `rep_gov` and `event_time = year - switch_year` (NA for Iowa). Save as `Data/Processed/panel_city_year.rds`. |
| `Scripts/02_baseline_twfe.R` | Use `fixest` to run baseline TWFE and Sun & Abraham event-study, plot `iplot(et)`, and export tables via `etable`. |
| `Scripts/03_staggered_did.R` (optional) | Implement Sun & Abraham or `did::att_gt` for staggered DiD and compare ATT paths to TWFE. |
| `Scripts/04_robustness.R` | Rerun models with population weights, state exclusions, and state-specific trends. |
| `Scripts/05_figs_tables.R` | Generate event-study figures and tables (main + robustness) for dissemination. |

### Deliverables checklist

- Clean panel (`panel_city_year.rds`) with accompanying codebook.
- Main table (violent crime rate) with two to three specifications plus one to two secondary tables (property/robbery).
- Event-study figure with a pre-trend window (e.g., −5 to +5 years).
- One-page methods and results summary with caveats.