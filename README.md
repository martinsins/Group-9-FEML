# Project title
---
# Group-9-FoE R code and data workflow for our Econometrics and Machine Learning project. ───────────────────────────────────────────────────────────── 🔐 ACCESS & CLONE THE REPOSITORY ───────────────────────────────────────────────────────────── 1. Generate and Add an SSH Key (recommended) macOS / Linux: ssh-keygen -t ed25519 -C "your_email@example.com" eval "$(ssh-agent -s)" ssh-add ~/.ssh/id_ed25519 pbcopy < ~/.ssh/id_ed25519.pub # copies the public key Then go to GitHub → Settings → SSH and GPG keys → New SSH key → paste → Save. Clone the repository (using SSH): git clone git@github.com:martinsins/Group-9-FoE.git cd Group-9-FoE ✅ SSH means you’ll never need to paste your token or password again. ────────────────────────────────────────────────────────────── 🧰 ENVIRONMENT SETUP ────────────────────────────────────────────────────────────── R version 4.1+ (RStudio recommended) Core packages (install once): install.packages(c("tidyverse", "dplyr", "readr", "janitor", "lubridate", "here")) ────────────────────────────────────────────────────────────── 🗂 PROJECT STRUCTURE ──────────────────────────────────────────────────────────────
Group-9-FoE/
│
├── Scripts/
│   ├── Data cleaning.R          # main data cleaning script
│   └── get_data.R               # optional: downloads large data
│
├── Data/
│   ├── Raw/                     # large raw data (ignored by Git)
│   └── Sorted/                  # cleaned / processed outputs
│
├── .gitignore
├── README.md
└── group-9-FoE.Rproj
⚠️ Large files (Data/Raw/*.csv, Data/Raw/*.rds) are ignored by Git. Share them via Google Drive or Dropbox if needed. ────────────────────────────────────────────────────────────── ▶️ HOW TO RUN ────────────────────────────────────────────────────────────── 1. Open the project in RStudio: - Double-click group-9-FoE.Rproj - or File → Open Project → group-9-FoE.Rproj 2. Add the data: - Place raw data files in Data/Raw/ - or run Scripts/get_data.R to download them automatically 3. Run the cleaning script: - Open Scripts/Data cleaning.R - Press Ctrl+Shift+Enter (Windows) or Cmd+Shift+Enter (Mac) 4. Output: - Cleaned datasets will appear in Data/Sorted/ ────────────────────────────────────────────────────────────── 🔄 GIT WORKFLOW (TEAM) ────────────────────────────────────────────────────────────── 1. Pull the latest changes
git pull
4. Do your work # edit scripts or add new ones 5. Stage, Commit, and Push
git add Scripts/ Data/Sorted/ README.md
       git commit -m "Add new cleaning step / fix variable names"
       git push
6. (Optional) Work on a new feature branch git checkout -b feature/my-change # make edits git add . git commit -m "Implement new feature" git push -u origin feature/my-change Then open a Pull Request on GitHub. ────────────────────────────────────────────────────────────── 🧹 .GITIGNORE CONTENTS ────────────────────────────────────────────────────────────── .Rproj.user .Rhistory .RData .Ruserdata Data/Raw/*.csv Data/Raw/*.rds ────────────────────────────────────────────────────────────── 💡 TIPS ────────────────────────────────────────────────────────────── - Use SSH to avoid entering tokens each time. - Always git pull before starting new work. - Never commit files over 50 MB. - Document all major changes in commit messages. ────────────────────────────────────────────────────────────── 👥 AUTHORS ────────────────────────────────────────────────────────────── Maintainer: @martinsins

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

