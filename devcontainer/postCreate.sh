#!/usr/bin/env bash
set -euo pipefail

# Python tooling
pipx install poetry pre-commit ruff black pytest ipykernel

# dbt + SQL linting
pipx install dbt-core dbt-postgres dbt-bigquery sqlfluff
pipx inject sqlfluff sqlfluff-templater-dbt

# Go tooling
go install golang.org/x/tools/gopls@latest
go install github.com/segmentio/golines@latest
go install golang.org/x/lint/golint@latest
go install github.com/fatih/gomodifytags@latest

# Terraform + policy
curl -fsSL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
tflint --init
pipx install checkov

# SQL clients
pipx install pgcli mycli

# Git hooks (repo-level)
pre-commit install --install-hooks

# VS Code user assets (if you keep them in repo)
cp -r /workspaces/vscode-provisioning/vscode/* /home/vscode/.vscode/ || true
