# Project title
## 📊 EXTENSION: STATE GOVERNOR ANALYSIS (2025 ADDITION)

In this extended version of the project, we refined the analysis to focus on the **political affiliation of each U.S. state’s governor** between 1970 and 1992.  
This approach is more relevant than simply using presidential election results, because **governors directly influence state-level law enforcement and security policies**.

### 🏛 Governors’ key responsibilities include:
- Enforcing state laws  
- Managing the **state police** and **National Guard**  
- Proposing the **state budget** to the local legislature  
- Appointing judges and agency heads  
- Influencing priorities on public safety, crime prevention, and social policies  

Therefore, analyzing states based on **governors’ political parties** (Democrat or Republican) better captures variations in security and crime policies.

---

## 🗳 STATES THAT DID NOT CHANGE POLITICAL PARTY (1970–1992)

| Party | States |
|-------|--------|
| **Democrat** | Georgia, Hawaii, **Maryland** |
| **Republican** | **Iowa**, Northern Mariana Islands |

Among these, the most suitable pair for comparison is **Maryland (Democrat)** vs **Iowa (Republican)**:
- Both have mixed rural and urban structures  
- Comparable economic development and stability  
- Similar climate and seasonality (Midwest/Northeast)  
- Maryland’s urban areas are moderate in size (Baltimore, not a megacity)  

➡️ This combination provides the **most balanced and coherent setup** for comparative econometric analysis.

---

## 🧮 DATA OUTPUTS

Two new cleaned datasets were created for this comparison:

| File | Description | Use |
|------|--------------|-----|
| **`state_group_year_sorted_MD_IA.csv`** | Multiple lines per state & year depending on city size | For internal analysis (urban vs rural) |
| **`state_year_agg_MD_IA.csv`** | One line per state & year (Iowa & Maryland only) | For direct state-level comparison (main analysis) |

These filtered datasets reduced the data from **over 4 million rows to fewer than 300**, while keeping all relevant variables for analysis.

---

