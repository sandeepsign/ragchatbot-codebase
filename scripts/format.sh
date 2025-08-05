#!/bin/bash

# Code formatting script
echo "Running code quality checks..."

echo "1. Sorting imports with isort..."
uv run isort backend/ main.py

echo "2. Formatting code with Black..."
uv run black backend/ main.py

echo "3. Running flake8 linting..."
uv run flake8 backend/ main.py

echo "4. Running mypy type checking..."
uv run mypy backend/ main.py

echo "Code quality checks completed!"