# Group-9-FoE
R code and data workflow for our Econometrics and Machine Learning project.

──────────────────────────────────────────────────────────────
🔐 ACCESS & CLONE THE REPOSITORY
──────────────────────────────────────────────────────────────

1. Generate and Add an SSH Key (recommended)

macOS / Linux:
    ssh-keygen -t ed25519 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    pbcopy < ~/.ssh/id_ed25519.pub   # copies the public key

Windows (Git Bash):
    ssh-keygen -t ed25519 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    cat ~/.ssh/id_ed25519.pub        # copy this manually

Then go to GitHub → Settings → SSH and GPG keys → New SSH key → paste → Save.

Clone the repository (using SSH):
    git clone git@github.com:martinsins/Group-9-FoE.git
    cd Group-9-FoE

✅ SSH means you’ll never need to paste your token or password again.

──────────────────────────────────────────────────────────────
🧰 ENVIRONMENT SETUP
──────────────────────────────────────────────────────────────

R version 4.1+ (RStudio recommended)
Core packages (install once):

    install.packages(c("tidyverse", "dplyr", "readr", "janitor", "lubridate", "here"))

──────────────────────────────────────────────────────────────
🗂 PROJECT STRUCTURE
──────────────────────────────────────────────────────────────

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

⚠️ Large files (Data/Raw/*.csv, Data/Raw/*.rds) are ignored by Git.
Share them via Google Drive or Dropbox if needed.

──────────────────────────────────────────────────────────────
▶️ HOW TO RUN
──────────────────────────────────────────────────────────────

1. Open the project in RStudio:
       - Double-click group-9-FoE.Rproj
       - or File → Open Project → group-9-FoE.Rproj

2. Add the data:
       - Place raw data files in Data/Raw/
       - or run Scripts/get_data.R to download them automatically

3. Run the cleaning script:
       - Open Scripts/Data cleaning.R
       - Press Ctrl+Shift+Enter (Windows) or Cmd+Shift+Enter (Mac)

4. Output:
       - Cleaned datasets will appear in Data/Sorted/

──────────────────────────────────────────────────────────────
🔄 GIT WORKFLOW (TEAM)
──────────────────────────────────────────────────────────────

1. Pull the latest changes
       git pull

2. Do your work
       # edit scripts or add new ones

3. Stage, Commit, and Push
       git add Scripts/ Data/Sorted/ README.md
       git commit -m "Add new cleaning step / fix variable names"
       git push

4. (Optional) Work on a new feature branch
       git checkout -b feature/my-change
       # make edits
       git add .
       git commit -m "Implement new feature"
       git push -u origin feature/my-change

Then open a Pull Request on GitHub.

──────────────────────────────────────────────────────────────
🧹 .GITIGNORE CONTENTS
──────────────────────────────────────────────────────────────

.Rproj.user
.Rhistory
.RData
.Ruserdata
Data/Raw/*.csv
Data/Raw/*.rds

──────────────────────────────────────────────────────────────
💡 TIPS
──────────────────────────────────────────────────────────────

- Use SSH to avoid entering tokens each time.
- Always git pull before starting new work.
- Never commit files over 50 MB.
- Document all major changes in commit messages.

──────────────────────────────────────────────────────────────
👥 AUTHORS
──────────────────────────────────────────────────────────────

Maintainer: @martinsins  
Collaborators: Group-9-FoE team

