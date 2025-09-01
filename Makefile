# Location: Makefile

.PHONY: install install-dev test clean lint format check-format type-check help

# Default target
help:
	@echo "Available targets:"
	@echo "  install      Install the package"
	@echo "  install-dev  Install package with development dependencies"
	@echo "  test         Run tests"
	@echo "  clean        Clean generated files"
	@echo "  lint         Run linting (flake8)"
	@echo "  format       Format code with black"
	@echo "  check-format Check if code is formatted"
	@echo "  type-check   Run type checking with mypy"
	@echo "  all-checks   Run all checks (format, lint, type, test)"

# Installation
install:
	pip install -e .

install-dev:
	pip install -e ".[dev]"

# Testing
test:
	pytest

test-verbose:
	pytest -v

test-coverage:
	pytest --cov=src --cov-report=html --cov-report=term

# Code quality
lint:
	flake8 src tests

format:
	black src tests

check-format:
	black --check src tests

type-check:
	mypy src

# Combined checks
all-checks: check-format lint type-check test

# Cleaning
clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .mypy_cache/
	rm -rf htmlcov/
	rm -rf .coverage
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	rm -rf data/synthetic/*/
	rm -rf exports/images/*
	rm -rf exports/html/*

clean-data:
	rm -rf data/synthetic/*/
	rm -rf exports/images/*
	rm -rf exports/html/*

# Development utilities
jupyter:
	jupyter notebook notebooks/

# Build and distribution
build:
	python -m build

publish-test:
	python -m twine upload --repository testpypi dist/*

publish:
	python -m twine upload dist/*

# Quick generation commands
generate-all:
	python -m src.cli random_walk --library matplotlib --export-type image
	python -m src.cli random_walk --library plotly --export-type html
	python -m src.cli dice --library matplotlib --export-type image
	python -m src.cli dice --library plotly --export-type html
	python -m src.cli weather --library matplotlib --export-type image
	python -m src.cli weather --library plotly --export-type html
	python -m src.cli quakes --library matplotlib --export-type image
	python -m src.cli quakes --library plotly --export-type html
	python -m src.cli github --library matplotlib --export-type image
	python -m src.cli github --library plotly --export-type html

demo:
	python -m src.cli random_walk --library matplotlib --export-type image