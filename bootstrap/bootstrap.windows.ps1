<#
Bootstrap for Windows 10/11 (Node-free).

Installs:
- Git, VS Code, Docker Desktop, Python 3.12, Go, Terraform, AWS CLI (via winget)
- pipx + dev CLIs: poetry, pre-commit, ruff, black, pytest, ipykernel, sqlfluff(+templater-dbt), checkov, pgcli, mycli
- dbt-core + adapters (postgres, bigquery) via pipx
- Go tools: gopls, golines, golint, gomodifytags
- TFLint (via winget if available; else Chocolatey)
- VS Code extensions from vscode/extensions.txt (or a sensible fallback)
- VS Code settings/keybindings/snippets
- Dotfiles (.editorconfig, .gitconfig)
#>

#---------------------------
# Helpers
#---------------------------
$ErrorActionPreference = 'Stop'
function Log($msg) { Write-Host "`n▶ $msg" -ForegroundColor Cyan }
function Exists($cmd) { Get-Command $cmd -ErrorAction SilentlyContinue | Out-Null }
$REPO_ROOT = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

# Require admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script in an elevated PowerShell (Run as Administrator)."
    exit 1
}

#---------------------------
# winget presence
#---------------------------
if (-not (Exists winget)) {
    Write-Warning "winget not found. Make sure you're on Windows 10/11 with App Installer installed."
    Write-Warning "You can install packages manually or install Chocolatey: https://chocolatey.org/install"
}

# Install via winget (idempotent)
function Install-WinGetPackage {
    param([string]$Id)
    if (Exists winget) {
        $installed = winget list --id $Id --source winget 2>$null
        if ($LASTEXITCODE -eq 0 -and $installed) {
            Log "winget package already present: $Id"
        }
        else {
            Log "Installing with winget: $Id"
            winget install --id $Id --silent --accept-package-agreements --accept-source-agreements | Out-Null
        }
    }
}

#---------------------------
# Core packages (winget)
#---------------------------
Install-WinGetPackage -Id "Git.Git"
Install-WinGetPackage -Id "Microsoft.VisualStudioCode"
Install-WinGetPackage -Id "Docker.DockerDesktop"
Install-WinGetPackage -Id "Python.Python.3.12"
Install-WinGetPackage -Id "GoLang.Go"
Install-WinGetPackage -Id "Hashicorp.Terraform"
Install-WinGetPackage -Id "Amazon.AWSCLI"

#---------------------------
# TFLint (winget OR Chocolatey fallback)
#---------------------------
$TFLintWingetIds = @("Terraform-Linters.tflint", "tflint")
$gotTflint = $false
foreach ($id in $TFLintWingetIds) {
    try {
        Install-WinGetPackage -Id $id
        if (Exists tflint) { $gotTflint = $true; break }
    }
    catch { }
}
if (-not $gotTflint) {
    if (-not (Exists choco)) {
        Log "Installing Chocolatey (required only for TFLint fallback)"
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    Log "Installing TFLint via Chocolatey"
    choco install tflint -y --no-progress
}

#---------------------------
# Ensure Python/pipx available
#---------------------------
try {
    Log "Installing pipx (user)"
    # Prefer the Python Launcher 'py' (installed by winget Python)
    if (Exists py) {
        py -m pip install --user --upgrade pip pipx
        py -m pipx ensurepath
    }
    else {
        python -m pip install --user --upgrade pip pipx
        python -m pipx ensurepath
    }
}
catch { Write-Warning "pipx installation encountered an issue: $($_.Exception.Message)" }

# Update PATH for this session so pipx apps are found immediately
$pipxPath1 = "$env:USERPROFILE\.local\bin"
$pipxPath2 = "$env:APPDATA\Python\Scripts"
foreach ($p in @($pipxPath1, $pipxPath2)) {
    if (Test-Path $p -and ($env:PATH -notlike "*$p*")) { $env:PATH = "$p;$env:PATH" }
}

#---------------------------
# Developer CLIs via pipx
#---------------------------
function PipxInstall($pkg) {
    try { pipx install $pkg | Out-Null } catch { Write-Warning "pipx failed for $pkg: $($_.Exception.Message)" }
}
function PipxInject($pkg, $dep) {
    try { pipx inject $pkg $dep | Out-Null } catch { Write-Warning "pipx inject failed: $pkg <- $dep" }
}

Log "Installing Python dev CLIs via pipx"
PipxInstall "poetry"
PipxInstall "pre-commit"
PipxInstall "ruff"
PipxInstall "black"
PipxInstall "pytest"
PipxInstall "ipykernel"
PipxInstall "pgcli"
PipxInstall "mycli"
PipxInstall "checkov"
PipxInstall "sqlfluff"
PipxInject "sqlfluff" "sqlfluff-templater-dbt"

# dbt (install the adapters you use)
PipxInstall "dbt-core"
PipxInstall "dbt-postgres"
PipxInstall "dbt-bigquery"

#---------------------------
# Go developer tools
#---------------------------
if (Exists go) {
    Log "Installing Go tools"
    $gopath = (& go env GOPATH).Trim()
    if (-not $gopath) { $gopath = "$env:USERPROFILE\go" }
    $gobin = Join-Path $gopath "bin"
    if ($env:PATH -notlike "*$gobin*") { $env:PATH = "$gobin;$env:PATH" }

    & go install golang.org/x/tools/gopls@latest
    & go install github.com/segmentio/golines@latest
    & go install golang.org/x/lint/golint@latest
    & go install github.com/fatih/gomodifytags@latest
}
else {
    Write-Warning "Go not found on PATH; skip Go tools."
}

#---------------------------
# VS Code CLI (code) resolve
#---------------------------
$CodeCmd = "code"
if (-not (Exists $CodeCmd)) {
    $fallback = Join-Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin" "code.cmd"
    if (Test-Path $fallback) { $CodeCmd = $fallback }
}
if (-not (Test-Path $CodeCmd) -and -not (Exists "code")) {
    Write-Warning "VS Code CLI not found. Open VS Code → Command Palette → 'Shell Command: Install 'code' command in PATH', then re-run extensions step."
}

#---------------------------
# VS Code extensions
#---------------------------
if (Test-Path $CodeCmd) {
    Log "Installing VS Code extensions"
    $extFile = Join-Path $REPO_ROOT "vscode\extensions.txt"
    if (Test-Path $extFile) {
        Get-Content $extFile | ForEach-Object {
            $id = $_.Trim()
            if ($id -and -not $id.StartsWith("#")) {
                try { & $CodeCmd --install-extension $id | Out-Null } catch { Write-Warning "Extension failed: $id" }
            }
        }
    }
    else {
        # Fallback curated set (Pokémon + Dracula included)
        $fallbackExts = @(
            "eamodio.gitlens",
            "EditorConfig.EditorConfig",
            "streetsidesoftware.code-spell-checker",
            "esbenp.prettier-vscode",
            "ms-azuretools.vscode-docker",
            "github.vscode-github-actions",
            "ms-vscode.makefile-tools",
            "ms-python.python",
            "ms-python.vscode-pylance",
            "charliermarsh.ruff",
            "ms-toolsai.jupyter",
            "golang.Go",
            "batisteo.vscode-dbt-power-user",
            "jberizbeitia.vscode-dbt-formatter",
            "mtxr.sqltools",
            "a5hk.format-sql",
            "alexcvzz.vscode-sqlite",
            "hashicorp.terraform",
            "AmazonWebServices.aws-toolkit-vscode",
            "jakobhoeg.vscode-pokemon",
            "Shinymimikyu.pokemon-color",
            "dracula-theme.theme-dracula"
        )
        foreach ($e in $fallbackExts) {
            try { & $CodeCmd --install-extension $e | Out-Null } catch { Write-Warning "Extension failed: $e" }
        }
    }
}

#---------------------------
# VS Code user settings / keybindings / snippets
#---------------------------
Log "Copying VS Code settings/keybindings/snippets"
$WinVSCUser = Join-Path $env:APPDATA "Code\User"
New-Item -ItemType Directory -Force -Path $WinVSCUser | Out-Null
$srcSettings = Join-Path $REPO_ROOT "vscode\settings.json"
$srcKeybinds = Join-Path $REPO_ROOT "vscode\keybindings.json"
$srcSnippets = Join-Path $REPO_ROOT "vscode\snippets"

if (Test-Path $srcSettings) { Copy-Item $srcSettings   (Join-Path $WinVSCUser "settings.json") -Force }
if (Test-Path $srcKeybinds) { Copy-Item $srcKeybinds   (Join-Path $WinVSCUser "keybindings.json") -Force }
if (Test-Path $srcSnippets) {
    $dstSnip = Join-Path $WinVSCUser "snippets"
    New-Item -ItemType Directory -Force -Path $dstSnip | Out-Null
    robocopy $srcSnippets $dstSnip /E /NFL /NDL /NJH /NJS /NP | Out-Null
}

#---------------------------
# Dotfiles
#---------------------------
Log "Installing dotfiles"
$dotEditor = Join-Path $REPO_ROOT "dotfiles\.editorconfig"
$dotGitcfg = Join-Path $REPO_ROOT "dotfiles\.gitconfig"
if (Test-Path $dotEditor) { Copy-Item $dotEditor "$HOME\.editorconfig" -Force }
if (Test-Path $dotGitcfg) { Copy-Item $dotGitcfg "$HOME\.gitconfig" -Force }

#---------------------------
# Pre-commit hooks (if repo has config)
#---------------------------
$preCfg = Join-Path $REPO_ROOT ".pre-commit-config.yaml"
if (Test-Path $preCfg) {
    try {
        Log "Installing repo pre-commit hooks"
        Push-Location $REPO_ROOT
        pre-commit install --install-hooks | Out-Null
        Pop-Location
    }
    catch { Write-Warning "pre-commit hook install failed: $($_.Exception.Message)" }
}

Log "✅ Windows bootstrap complete.
If Docker Desktop was installed/updated, you may need to sign out/in or reboot.
If 'code' CLI wasn't on PATH, open VS Code → Command Palette → 'Shell Command: Install code command in PATH', then re-run the extensions step."
