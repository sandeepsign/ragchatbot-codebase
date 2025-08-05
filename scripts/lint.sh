#!/bin/bash

# Linting and type checking script (read-only checks)
echo "Running code quality checks (read-only)..."

echo "1. Running flake8 linting..."
uv run flake8 backend/ main.py

echo "2. Running mypy type checking..."
uv run mypy backend/ main.py

echo "3. Checking import sorting..."
uv run isort --check-only --diff backend/ main.py

echo "4. Checking code formatting..."
uv run black --check --diff backend/ main.py

echo "Code quality checks completed!"