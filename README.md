# Group-9-FoE

R code and data workflow for our Econometrics and Machine Learning project.

---

## 🔐 Access & Clone the Repository

### 1. Generate and Add an SSH Key (recommended)

#### macOS / Linux
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub   # copies the public key

2. Clone the Repository (using SSH)
git clone git@github.com:martinsins/Group-9-FoE.git
cd Group-9-FoE


✅ SSH means you’ll never need to paste your token or password again.

🧰 Environment Setup

R: version 4.1+ (RStudio recommended)

Core packages (install once):

install.packages(c("tidyverse", "dplyr", "readr", "janitor", "lubridate", "here"))

🗂 Project Structure
Group-9-FoE/
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


⚠️ Large files (Data/Raw/*.csv, Data/Raw/*.rds) are ignored by Git
and should be shared via Google Drive or Dropbox if needed.

▶️ How to Run

Open the project in RStudio

Double-click group-9-FoE.Rproj, or

In RStudio: File → Open Project → group-9-FoE.Rproj

Add the data

Place raw data files in Data/Raw/

(Or run Scripts/get_data.R to download them automatically)

Run the cleaning script

Open Scripts/Data cleaning.R

Press Ctrl + Shift + Enter (Windows) or Cmd + Shift + Enter (Mac)

Output

Cleaned datasets will appear in Data/Sorted/

/

🔄 Git Workflow (Team)
1. Pull the latest changes
git pull

2. Do your work

Edit scripts or add new ones.

3. Stage, Commit, and Push
git add Scripts/ Data/Sorted/ README.md
git commit -m "Add new cleaning step / fix variable names"
git push

4. (Optional) Work on a new feature branch
git checkout -b feature/my-change
# ... make edits ...
git add .
git commit -m "Implement new feature"
git push -u origin feature/my-change


Then open a Pull Request on GitHub.
