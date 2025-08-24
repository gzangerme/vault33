# 🚀 Data Engineer Workstation Bootstrap

![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)
![Go](https://img.shields.io/badge/Go-1.22-00ADD8?logo=go&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-1.8-844FBA?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Toolkit-FF9900?logo=amazon-aws&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Desktop-2496ED?logo=docker&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-Core-FB542B?logo=dbt&logoColor=white)
![VS Code](https://img.shields.io/badge/VS%20Code-Extensions-007ACC?logo=visual-studio-code&logoColor=white)

---

## 📖 What is this repo?

This repository is a **turnkey developer environment** for **Data Engineers** who work with:

- **Python**, **Go**, **SQL**
- **Terraform** & **AWS**
- **dbt**
- **VS Code**

👉 The idea:
Every time you get a **new machine** or join a **new company**, instead of manually setting up tools, extensions, and configs, you **clone this repo** and run the bootstrap script for your OS.
It configures everything in a **modular, idempotent way** so you can get productive fast.

---

## ⚡ How to Run

### 🐧 Debian / Ubuntu
```bash
chmod +x bootstrap/bootstrap.debian.sh
./bootstrap/bootstrap.debian.sh

chmod +x bootstrap/bootstrap.macos.sh
./bootstrap/bootstrap.macos.sh

### 🍎 macOS
```bash
chmod +x bootstrap/bootstrap.macos.sh
./bootstrap/bootstrap.macos.sh

🪟 Windows
```bash
Set-ExecutionPolicy Bypass -Scope Process -Force
.\bootstrap\bootstrap.windows.ps1

🐳 Dev Containers (Preferred)
If you use Docker + VS Code:

1) Clone this repo.

2) Open in VS Code.

3) Select “Reopen in Container”.

4) Everything installs inside a reproducible container.

## 🧩 VS Code Extensions (Visual Catalog)

Below is the curated set of extensions with **logos, names, and reasons** why they’re included.
This makes it easier for you (and your teammates) to see at a glance what powers your dev environment.

---

### 🔑 Core Productivity

| Logo | Extension | Why it’s included |
|------|-----------|------------------|
| ![GitLens](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/git.svg) | **[GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)** | Deep Git blame/history/repo insights. |
| ![EditorConfig](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/editorconfig.svg) | **[EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)** | Enforces consistent style across editors/CI. |
| ![SpellChecker](https://img.shields.io/badge/ABC-Spell_Checker-blue) | **[Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)** | Catch typos in code/docs. |
| ![Prettier](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/prettier.svg) | **[Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)** | Opinionated formatting for JSON/YAML/Markdown. |
| ![Docker](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/docker.svg) | **[Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)** | Manage containers & images inside VS Code. |
| ![GitHub](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/github.svg) | **[GitHub Actions](https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions)** | Monitor workflows directly in VS Code. |
| 🛠️ | **[Makefile Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.makefile-tools)** | Run/debug Makefile targets easily. |

---

### 🐍 Python

| Logo | Extension | Why it’s included |
|------|-----------|------------------|
| ![Python](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/python.svg) | **[Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)** | Debugging, testing, env mgmt. |
| ![Pylance](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/microsoft.svg) | **[Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)** | Fast IntelliSense & type checking. |
| 🐦 | **[Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)** | Ultra-fast Python linter/formatter. |
| 📓 | **[Jupyter](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter)** | Run notebooks inline. |

---

### 🐹 Go

| Logo | Extension | Why it’s included |
|------|-----------|------------------|
| ![Go](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/go.svg) | **[Go](https://marketplace.visualstudio.com/items?itemName=golang.Go)** | Provides `gopls`, linting, debug/test integration. |

---

### 🗄️ SQL / dbt

| Logo | Extension | Why it’s included |
|------|-----------|------------------|
| ![dbt](https://raw.githubusercontent.com/dbt-labs/dbt-styleguide/main/img/dbt-logo-full.svg) | **[dbt Power User](https://marketplace.visualstudio.com/items?itemName=batisteo.vscode-dbt-power-user)** | Explore dbt projects, run models/tests. |
| ![dbt](https://raw.githubusercontent.com/dbt-labs/dbt-styleguide/main/img/dbt-logo-full.svg) | **[dbt Formatter](https://marketplace.visualstudio.com/items?itemName=jberizbeitia.vscode-dbt-formatter)** | Auto-format dbt SQL + Jinja. |
| ![SQL](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/mysql.svg) | **[SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)** | Run SQL queries across DBs. |
| 📐 | **[Format SQL](https://marketplace.visualstudio.com/items?itemName=a5hk.format-sql)** | Quick SQL formatting. |
| ![SQLite](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/sqlite.svg) | **[SQLite Viewer](https://marketplace.visualstudio.com/items?itemName=alexcvzz.vscode-sqlite)** | Inspect local SQLite DBs. |

---

### ☁️ Terraform / Cloud

| Logo | Extension | Why it’s included |
|------|-----------|------------------|
| ![Terraform](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/terraform.svg) | **[Terraform](https://marketplace.visualstudio.com/items?itemName=hashicorp.terraform)** | HCL language server + plan/fmt integration. |
| ![AWS](https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/amazonaws.svg) | **[AWS Toolkit](https://marketplace.visualstudio.com/items?itemName=amazonwebservices.aws-toolkit-vscode)** | Browse AWS resources, run Lambdas, view logs. |

---

### 🎨 Themes & Fun

| Logo | Extension | Why it’s included |
|------|-----------|------------------|
| ![Pokémon](https://raw.githubusercontent.com/edent/SuperTinyIcons/master/images/svg/pokemon.svg) | **[Pokémon VS Code](https://marketplace.visualstudio.com/items?itemName=jakobhoeg.vscode-pokemon)** | Pokémon companion in editor. |
| 🎨 | **[Pokémon Color Theme](https://marketplace.visualstudio.com/items?itemName=Shinymimikyu.pokemon-color)** | Pokémon-inspired color palette. |
| 🧛 | **[Dracula Official](https://marketplace.visualstudio.com/items?itemName=dracula-theme.theme-dracula)** | High-contrast dark theme, popular among devs. |

---

⚙️ VS Code Settings (with rationale)
{
  "editor.formatOnSave": true,                // Always auto-format
  "editor.codeActionsOnSave": {
    "source.organizeImports": "explicit",
    "source.fixAll": "explicit"
  },
  "files.trimTrailingWhitespace": true,       // Clean diffs
  "files.insertFinalNewline": true,           // POSIX-friendly files
  "editor.tabSize": 2,                        // Default: JSON/YAML/SQL
  "editor.rulers": [88,100,120],              // Visual line guides

  // Python
  "python.formatting.provider": "black",
  "python.testing.pytestEnabled": true,
  "python.analysis.typeCheckingMode": "basic",
  "ruff.lint.args": ["--select","E,F,I,B","--ignore","E501"],

  // Go
  "go.useLanguageServer": true,
  "go.formatTool": "gofmt",
  "go.lintTool": "golangci-lint",

  // SQL / dbt
  "sqlfluff.dialect": "postgres",
  "dbt-power-user.queryLimit": 1000,

  // Terraform
  "terraform.codelens.enabled": true,

  // AWS
  "aws.profile": "default",

  // Git
  "git.autofetch": true,

  // Theme (default)
  "workbench.colorTheme": "Dracula"
}

Why:

Save = format → consistent style.

Type checking on, but not overly strict.

Hide caches like .venv or .terraform.

Rulers keep code style consistent across team.

Black + Ruff enforce Python standards.

Staticcheck in Go for deeper analysis.

sqlfluff ensures clean, consistent SQL.

Terraform codelens shows plan info inline.

Dracula default theme for eye comfort.

📂 Repo Layout
.
├── bootstrap/         # OS-specific scripts (Debian, macOS, Windows)
├── vscode/            # Extensions list, settings, keybindings, snippets
├── dotfiles/          # .editorconfig, .gitconfig, .zshrc
├── devcontainer/      # Containerized dev env (preferred)
├── scripts/           # Modular language-specific installers
└── README.md          # This documentation
