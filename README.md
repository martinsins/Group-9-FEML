# Project title
## 📊 EXTENSION: STATE GOVERNOR ANALYSIS (2025 ADDITION)

In this extended version of the project, we refined the analysis to focus on the **political affiliation of each U.S. state’s governor** between 1970 and 1992.  
This approach is more relevant than simply using presidential election results, because **governors directly influence state-level law enforcement and security policies**.

🏛 Project Overview

Initially, our goal was to classify U.S. states as either Republican or Democratic based on presidential election outcomes.
However, we later realized that for studying crime and policing, the political affiliation of each state’s governor is a far more relevant indicator.

Governors directly shape law enforcement and public safety policies through their authority to:
- Enforce state laws
- Manage the state police and National Guard
- Propose the state budget to the local legislature
- Appoint key officials such as judges and agency heads
- Influence state-level priorities in security, justice, and economic policy

Based on this reasoning, we identified which U.S. states changed or maintained the same political party in the governorship between 1970 and 1992.

🌎 Case Study: Illinois, Michigan, and Iowa

We selected Illinois, Michigan, and Iowa as our comparative sample:
- Illinois → switched from Republican to Democratic governors during the period
- Michigan → switched from Democratic to Republican governors
- Iowa → remained Republican throughout

This variation provides a strong basis for comparative econometric analysis, allowing us to contrast crime dynamics across states with differing political trajectories.

🏙 Focus on Urban Areas (≥85,000 inhabitants)

For the city-level analysis, we restricted our dataset to urban areas with populations of at least 85,000 between 1973 and 1991.

This threshold was chosen because it:
- Ensures a sufficient sample size (28 comparable cities)
- Focuses on larger, more homogeneous urban environments
- Reduces noise from small or rural jurisdictions with inconsistent reporting

The final dataset includes detailed crime statistics (violent, property, and offense-specific categories) complemented by socioeconomic and demographic variables such as:
- Poverty rates
- Median income
- Racial disparities
- Population size and density

📈 Methodology

The empirical strategy relies on Difference-in-Differences (DiD) and Fixed Effects (FE) models to evaluate how crime rates evolved before and after gubernatorial elections.

By comparing both:
- Within-state changes (pre/post-governor transitions), and
- Across-state differences (Republican vs. Democratic governorships),

we aim to identify whether shifts in political control correlate with measurable changes in violent and property crime trends.

📂 Data Files
File	Description	Use
- monthly_raw_Iowa_Illinois_Michigan_1973_1991.csv: Monthly-level data for all police-reported offenses between 1973 and 1991 across Illinois, Iowa, and Michigan.	Contains the most granular information for time-series or monthly aggregation analyses.
- city_year_Iowa_Illinois_Michigan_1973_1991.csv:	Aggregated at the city-year level (ZIP code granularity). Includes annual totals for crimes and population.	Core dataset used for city-level analysis — restricted to cities ≥85,000 inhabitants.
- state_group_year_sorted_MI_IL_IA_1973_1991.csv: Aggregated at the state-year-city-size level.	Used for comparing crime trends across states and by city size (e.g., medium vs. large).

🧮 Summary
- Period: 1973–1991
- States analyzed: Illinois, Iowa, Michigan
- Population threshold: ≥85,000 inhabitants
- Number of cities: 28
- Goal: Assess how political transitions at the state level (governor changes) correlate with shifts in crime ratesping all relevant variables for analysis.

---

