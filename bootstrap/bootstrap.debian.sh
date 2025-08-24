#!/usr/bin/env bash
# Bootstrap for Debian/Ubuntu workstations (Node-free).
# Installs: Git, Zsh, asdf (optional), Python 3.12 stack, Go, Terraform, AWS CLI, Docker, VS Code,
# VS Code extensions (from vscode/extensions.txt if present), your settings/snippets/dotfiles,
# plus common DE tools: pipx, pre-commit, tflint, checkov, sqlfluff(+dbt templater), pgcli/mycli, Go tools.

set -euo pipefail

# ---------------------------
# Helpers
# ---------------------------
log() { printf "\n\033[1;36m▶ %s\033[0m\n" "$*"; }
exists() { command -v "$1" >/dev/null 2>&1; }

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ---------------------------
# Apt prerequisites
# ---------------------------
log "Updating apt & installing base packages"
sudo apt-get update -y
sudo apt-get install -y \
  apt-transport-https ca-certificates curl wget gnupg lsb-release software-properties-common \
  build-essential unzip tar jq git zsh \
  python3 python3-venv python3-pip pipx \
  golang \
  awscli

# Ensure pipx on PATH for this shell
python3 -m pipx ensurepath || true
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------
# VS Code (Microsoft repo)
# ---------------------------
if ! exists code; then
  log "Installing VS Code (Microsoft repository)"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg >/dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list
  sudo apt-get update -y
  sudo apt-get install -y code
else
  log "VS Code already installed"
fi

# ---------------------------
# HashiCorp (Terraform) repo
# ---------------------------
if ! apt-cache policy terraform | grep -q 'apt.releases.hashicorp.com'; then
  log "Adding HashiCorp apt repo for Terraform"
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update -y
fi
sudo apt-get install -y terraform

# ---------------------------
# Docker (optional but recommended)
# ---------------------------
if ! exists docker; then
  log "Installing Docker (community, from distro repos)"
  sudo apt-get install -y docker.io
  sudo usermod -aG docker "$USER" || true
else
  log "Docker already installed"
fi

# ---------------------------
# asdf (optional, for per-project tool pinning)
# ---------------------------
if [ ! -d "$HOME/.asdf" ]; then
  log "Installing asdf version manager"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
  echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
  echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
fi
# shellcheck source=/dev/null
[ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh" || true

# ---------------------------
# Python/dev CLIs via pipx
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
# Terraform linters
# ---------------------------
log "Installing TFLint"
curl -fsSL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
tflint --init || true

# ---------------------------
# VS Code: extensions & user config
# ---------------------------
log "Installing VS Code extensions"
EXT_FILE="$REPO_ROOT/vscode/extensions.txt"
if [ -f "$EXT_FILE" ]; then
  # install from list
  grep -vE '^\s*#' "$EXT_FILE" | sed '/^\s*$/d' | xargs -I {} code --install-extension "{}" || true
else
  # fallback minimal set
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
LINUX_VSC_USER="$HOME/.config/Code/User"
mkdir -p "$LINUX_VSC_USER"
[ -f "$REPO_ROOT/vscode/settings.json" ]   && cp "$REPO_ROOT/vscode/settings.json"   "$LINUX_VSC_USER/settings.json"
[ -f "$REPO_ROOT/vscode/keybindings.json" ] && cp "$REPO_ROOT/vscode/keybindings.json" "$LINUX_VSC_USER/keybindings.json" || true
[ -d "$REPO_ROOT/vscode/snippets" ]        && rsync -a "$REPO_ROOT/vscode/snippets/" "$LINUX_VSC_USER/snippets/" || true

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

log "✅ Debian/Ubuntu bootstrap complete. (If you were added to the docker group, log out/in to use docker without sudo.)"
