#!/usr/bin/env bash
# Bootstrap for macOS workstations (Node-free).
# Installs: Homebrew, Git, Zsh, asdf, Python 3.12, Go, Terraform, AWS CLI, Docker (Desktop),
# VS Code + extensions (including Pokémon & Dracula), your VS Code settings/snippets/dotfiles,
# and common DE tools via pipx, plus Go/Terraform linters.

set -euo pipefail

log() { printf "\n\033[1;36m▶ %s\033[0m\n" "$*"; }
exists() { command -v "$1" >/dev/null 2>&1; }

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ---------------------------
# Xcode CLT & Homebrew
# ---------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools"
  xcode-select --install || true
fi

if ! exists brew; then
  log "Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
fi

# ---------------------------
# Core packages
# ---------------------------
log "Installing core packages with brew"
brew update
brew install --quiet git zsh asdf python@3.12 go terraform awscli pipx pre-commit jq wget tflint
brew install --cask visual-studio-code docker

# asdf in shell startup
if ! grep -q 'asdf.sh' "$HOME/.zshrc" 2>/dev/null; then
  echo -e '\n. $(brew --prefix asdf)/libexec/asdf.sh' >> "$HOME/.zshrc"
fi
# pipx path
pipx ensurepath
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------
# Developer CLIs via pipx
# ---------------------------
log "Installing developer CLIs via pipx"
pipx install poetry || true
pipx install pre-commit || true
pipx install ruff || true
pipx install black || true
pipx install pytest || true
pipx install ipykernel || true
pipx install pgcli || true
pipx install mycli || true
pipx install checkov || true
pipx install sqlfluff || true
pipx inject sqlfluff sqlfluff-templater-dbt || true

# dbt adapters (install the ones you actually use)
pipx install dbt-core || true
pipx install dbt-postgres || true
pipx install dbt-bigquery || true

# ---------------------------
# Go developer tools
# ---------------------------
log "Installing Go dev tools"
export GOPATH="${GOPATH:-$HOME/go}"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"
go install golang.org/x/tools/gopls@latest
go install github.com/segmentio/golines@latest
go install golang.org/x/lint/golint@latest
go install github.com/fatih/gomodifytags@latest

# ---------------------------
# VS Code: extensions & user config
# ---------------------------
log "Installing VS Code extensions"
EXT_FILE="$REPO_ROOT/vscode/extensions.txt"
if [ -f "$EXT_FILE" ]; then
  grep -vE '^\s*#' "$EXT_FILE" | sed '/^\s*$/d' | xargs -I {} code --install-extension "{}" || true
else
  for ext in \
    eamodio.gitlens EditorConfig.EditorConfig streetsidesoftware.code-spell-checker esbenp.prettier-vscode \
    ms-azuretools.vscode-docker github.vscode-github-actions ms-vscode.makefile-tools \
    ms-python.python ms-python.vscode-pylance charliermarsh.ruff ms-toolsai.jupyter \
    golang.Go batisteo.vscode-dbt-power-user jberizbeitia.vscode-dbt-formatter \
    mtxr.sqltools a5hk.format-sql alexcvzz.vscode-sqlite hashicorp.terraform aws-toolkit-vscode \
    jakobhoeg.vscode-pokemon Shinymimikyu.pokemon-color dracula-theme.theme-dracula
  do
    code --install-extension "$ext" || true
  done
fi

log "Copying VS Code settings/keybindings/snippets"
MAC_VSC_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$MAC_VSC_USER"
[ -f "$REPO_ROOT/vscode/settings.json" ]   && cp "$REPO_ROOT/vscode/settings.json"   "$MAC_VSC_USER/settings.json"
[ -f "$REPO_ROOT/vscode/keybindings.json" ] && cp "$REPO_ROOT/vscode/keybindings.json" "$MAC_VSC_USER/keybindings.json" || true
[ -d "$REPO_ROOT/vscode/snippets" ]        && rsync -a "$REPO_ROOT/vscode/snippets/" "$MAC_VSC_USER/snippets/" || true

# ---------------------------
# Dotfiles
# ---------------------------
log "Installing dotfiles"
[ -f "$REPO_ROOT/dotfiles/.editorconfig" ] && cp "$REPO_ROOT/dotfiles/.editorconfig" "$HOME/.editorconfig"
[ -f "$REPO_ROOT/dotfiles/.gitconfig" ]    && cp "$REPO_ROOT/dotfiles/.gitconfig"    "$HOME/.gitconfig"
[ -f "$REPO_ROOT/dotfiles/.zshrc" ]        && cp "$REPO_ROOT/dotfiles/.zshrc"        "$HOME/.zshrc" || true

# ---------------------------
# Git hooks (if repository has pre-commit config)
# ---------------------------
if [ -f "$REPO_ROOT/.pre-commit-config.yaml" ]; then
  log "Installing repo pre-commit hooks"
  (cd "$REPO_ROOT" && pre-commit install --install-hooks) || true
fi

log "✅ macOS bootstrap complete. Launch Docker.app once and accept privileges if prompted."
