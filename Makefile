.PHONY: setup python go tf dbt lint fmt

setup:  ## install all dev tools (local)
	./scripts/install_python_tools.sh
	./scripts/install_go_tools.sh
	./scripts/install_sql_tools.sh
	./scripts/install_terraform_tools.sh
	./scripts/install_dbt_tools.sh

python:
	python -m venv .venv && . .venv/bin/activate && poetry install

go:
	go mod tidy

tf:
	tflint && terraform fmt -recursive && terraform validate

dbt:
	dbt deps && dbt build --select state:modified+

lint:
	pre-commit run --all-files

fmt:
	ruff --fix . || true
	black .
	sqlfluff fix .
