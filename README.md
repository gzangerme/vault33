# Vault33

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
```

### 🍎 macOS
```bash
chmod +x bootstrap/bootstrap.macos.sh
./bootstrap/bootstrap.macos.sh
```

### 🪟 Windows
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\bootstrap\bootstrap.windows.ps1
```

### 🐳 Dev Containers (Preferred)
If you use Docker + VS Code:

1. Clone this repo.
2. Open in VS Code.
3. Select **“Reopen in Container”**.
4. Everything installs inside a reproducible container.

---

## 🧩 VS Code Extensions (Visual Catalog)

Below is the curated set of extensions with **logos, names, and reasons** why they’re included.
This makes it easier for you (and your teammates) to see at a glance what powers your dev environment.

---


### 🔑 Core Productivity

| Extension | Why it’s included |
|-----------|------------------|
| ![GitLens](https://img.shields.io/badge/GitLens-black?logo=git&logoColor=white) | Deep Git blame/history/repo insights. |
| ![EditorConfig](https://img.shields.io/badge/EditorConfig-grey?logo=editorconfig&logoColor=white) | Enforces consistent style across editors/CI. |
| ![Code Spell Checker](https://img.shields.io/badge/Code%20Spell%20Checker-blue?logo=readme&logoColor=white) | Catch typos in code/docs. |
| ![Prettier](https://img.shields.io/badge/Prettier-ff69b4?logo=prettier&logoColor=white) | Opinionated formatting for JSON/YAML/Markdown. |
| ![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white) | Manage containers & images inside VS Code. |
| ![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-181717?logo=githubactions&logoColor=white) | Monitor workflows directly in VS Code. |
| ![Makefile Tools](https://img.shields.io/badge/Makefile%20Tools-grey?logo=gnu&logoColor=white) | Run/debug Makefile targets easily. |

---

### 🐍 Python

| Extension | Why it’s included |
|-----------|------------------|
| ![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white) | Debugging, testing, env mgmt. |
| ![Pylance](https://img.shields.io/badge/Pylance-0078D7?logo=microsoft&logoColor=white) | Fast IntelliSense & type checking. |
| ![Ruff](https://img.shields.io/badge/Ruff-000000?logo=python&logoColor=white) | Ultra-fast Python linter/formatter. |
| ![Jupyter](https://img.shields.io/badge/Jupyter-F37626?logo=jupyter&logoColor=white) | Run notebooks inline. |

---

### 🐹 Go

| Extension | Why it’s included |
|-----------|------------------|
| ![Go](https://img.shields.io/badge/Go-00ADD8?logo=go&logoColor=white) | Provides `gopls`, linting, debug/test integration. |

---

### 🗄️ SQL / dbt

| Extension | Why it’s included |
|-----------|------------------|
| ![dbt](https://img.shields.io/badge/dbt-FB542B?logo=dbt&logoColor=white) **dbt Power User** | Explore dbt projects, run models/tests. |
| ![dbt](https://img.shields.io/badge/dbt-FB542B?logo=dbt&logoColor=white) **dbt Formatter** | Auto-format dbt SQL + Jinja. |
| ![SQLTools](https://img.shields.io/badge/SQLTools-003B57?logo=mysql&logoColor=white) | Run SQL queries across DBs. |
| ![Format SQL](https://img.shields.io/badge/Format%20SQL-336791?logo=postgresql&logoColor=white) | Quick SQL formatting. |
| ![SQLite](https://img.shields.io/badge/SQLite-003B57?logo=sqlite&logoColor=white) | Inspect local SQLite DBs. |

---

### ☁️ Terraform / Cloud

| Extension | Why it’s included |
|-----------|------------------|
| ![Terraform](https://img.shields.io/badge/Terraform-844FBA?logo=terraform&logoColor=white) | HCL language server + plan/fmt integration. |
| ![AWS Toolkit](https://img.shields.io/badge/AWS-232F3E?logo=amazonaws&logoColor=FF9900) | Browse AWS resources, run Lambdas, view logs. |

---

## ⚙️ VS Code Settings (with rationale)

```jsonc
{
  "editor.formatOnSave": true,                // Always auto-format
  "editor.codeActionsOnSave": {
    "source.organizeImports": "explicit",
    "source.fixAll": "explicit"
  },
  "files.trimTrailingWhitespace": true,       // Clean diffs
  "files.insertFinalNewline": true,           // POSIX-friendly files
  "editor.tabSize": 2,                        // Default: JSON/YAML/SQL
  "editor.rulers": [88, 100, 120],            // Visual line guides

  // Python
  "python.formatting.provider": "black",
  "python.testing.pytestEnabled": true,
  "python.analysis.typeCheckingMode": "basic",
  "ruff.lint.args": ["--select", "E,F,I,B", "--ignore", "E501"],

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
```

### Why these settings?

- **Save = format** → consistent style.
- **Type checking** on, but not overly strict.
- Hide caches like `.venv` or `.terraform`.
- Rulers keep code style consistent across team.
- **Black + Ruff** enforce Python standards.
- **Staticcheck-style checks via gopls** for deeper Go analysis.
- **sqlfluff** ensures clean, consistent SQL.
- **Terraform CodeLens** shows useful inline info.
- **Dracula** as default theme for eye comfort.

---

## 📂 Repo Layout

```text
.
├── bootstrap/         # OS-specific scripts (Debian, macOS, Windows)
├── vscode/            # Extensions list, settings, keybindings, snippets
├── dotfiles/          # .editorconfig, .gitconfig, .zshrc
├── devcontainer/      # Containerized dev env (preferred)
├── scripts/           # Modular language-specific installers
└── README.md          # This documentation
```

---

> ✨ “From zero to productive in minutes — on any OS.”
