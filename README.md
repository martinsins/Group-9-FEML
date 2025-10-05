R code and data workflow for our Econometrics/ML work.

🔐 Access & clone (SSH recommended)
  1) Add an SSH key to GitHub (one-time) [macOS / Linux]

    ssh-keygen -t ed25519 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    pbcopy < ~/.ssh/id_ed25519.pub   # copies the public key

Then: GitHub → Settings → SSH and GPG keys → New SSH key → paste → Save.

  2) Clone via SSH:
    git clone git@github.com:martinsins/Group-9-FoE.git
    cd Group-9-FoE

🧰 Environment
- R: 4.1+ (RStudio recommended)
- Core packages (install once):
  
  install.packages(c(
  "tidyverse","dplyr","readr","janitor","lubridate","here"
  ))
  
🗂 Project structure

Group-9-FoE/
├── Scripts/
│   ├── Data cleaning.R              # main cleaning script
│   └── get_data.R                   # (optional) downloads large data
├── Data/
│   ├── Raw/                         # large raw files (ignored by Git)
│   └── Sorted/                      # cleaned / derived data saved here
├── README.md
├── .gitignore
└── group-9-FoE.Rproj


Large data (Data/Raw/*.csv, Data/Raw/*.rds) are not tracked by Git.
Share via Drive/Dropbox and/or populate with Scripts/get_data.R.

▶️ How to run
- Open the RStudio project: group-9-FoE.Rproj
- Put the raw files in Data/Raw/ (or run Scripts/get_data.R if provided).
- Run the cleaning script:
    Open Scripts/Data cleaning.R
    Run (Ctrl/Cmd + Shift + Enter)
    Outputs (cleaned .rds/.csv) are written to Data/Sorted/

🔄 Git workflow (team)
1. Pull latest

  git pull

2. Do your work (edit scripts / add new ones).
3. Stage → Commit → Push

  git add Scripts/ Data/Sorted/ README.md
  git commit -m "Add X; fix Y"
  git push

4. If you’re doing bigger changes, create a branch + PR:

  git checkout -b feature/my-change
  # work, commit, push
  git push -u origin feature/my-change

  Open a Pull Request on GitHub → one teammate reviews → Merge.

Rule of thumb
- Commit code and small outputs.
- Never commit big raw data (they’re ignored by .gitignore).

🧹 .gitignore (already set)
.Rproj.user
.Rhistory
.RData
.Ruserdata
Data/Raw/*.csv
Data/Raw/*.rds

🆘 Common issues
Asked for a password while pushing → you cloned with HTTPS and didn’t set a helper.
  - macOS: git config --global credential.helper osxkeychain (enter token once).
  - Or switch to SSH: git remote set-url origin git@github.com:martinsins/Group-9-FoE.git
Push rejected: large files → keep >50MB files in Data/Raw/ only, never commit them.
