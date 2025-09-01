#!/bin/bash

# PCC-VizForge Project Structure Generator
# Creates the complete directory structure and placeholder files
# for the PCC-VizForge synthetic data visualization suite

set -e  # Exit on any error

PROJECT_NAME="pcc-vizforge"
BASE_DIR="$(pwd)/$PROJECT_NAME"

echo "🚀 Creating PCC-VizForge project structure..."

# Create base project directory
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

# Create main directories
echo "📁 Creating main directories..."
mkdir -p config
mkdir -p data/synthetic/{random_walk,dice,weather,quakes,github}
mkdir -p exports/{images,html}
mkdir -p src/{utils,generators,plots}
mkdir -p notebooks
mkdir -p tests

# Create root files
echo "📄 Creating root configuration files..."

# .gitignore
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
pip-wheel-metadata/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Jupyter
.ipynb_checkpoints/
*.ipynb

# Data and exports (optional - remove if you want to track generated data)
data/synthetic/*/
exports/images/*
exports/html/*
!data/synthetic/*/.keep
!exports/images/.keep
!exports/html/.keep

# OS
.DS_Store
Thumbs.db
EOF

# pyproject.toml
cat > pyproject.toml << 'EOF'
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "pcc-vizforge"
version = "1.0.0"
description = "PCC-VizForge: Synthetic Data Visualization Suite"
authors = [{name = "Your Name", email = "your.email@example.com"}]
license = {text = "MIT"}
readme = "README.md"
requires-python = ">=3.8"
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Education",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Topic :: Scientific/Engineering :: Visualization",
]

dependencies = [
    "matplotlib>=3.5.0",
    "plotly>=5.0.0",
    "pandas>=1.3.0",
    "numpy>=1.21.0",
    "pyyaml>=6.0",
    "click>=8.0.0",
    "jupyter>=1.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=6.0",
    "pytest-cov>=2.0",
    "black>=22.0",
    "flake8>=4.0",
]

[project.scripts]
pcc-vizforge = "src.cli:main"

[tool.setuptools.packages.find]
where = ["."]
include = ["src*"]

[tool.black]
line-length = 88
target-version = ['py38']

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
EOF

# Makefile
cat > Makefile << 'EOF'
.PHONY: install dev test clean generate plot demo help

# Default Python interpreter
PYTHON := python3

help: ## Show this help message
	@echo "PCC-VizForge Development Commands:"
	@echo "=================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install the package and dependencies
	$(PYTHON) -m pip install -e .

dev: ## Install development dependencies
	$(PYTHON) -m pip install -e ".[dev]"

test: ## Run tests
	pytest tests/ -v

test-cov: ## Run tests with coverage
	pytest tests/ --cov=src --cov-report=html --cov-report=term

clean: ## Clean generated files
	rm -rf build/ dist/ *.egg-info/
	rm -rf data/synthetic/*/
	rm -rf exports/images/* exports/html/*
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

generate: ## Generate all synthetic datasets
	$(PYTHON) -m src.cli generate --all

plot: ## Create all visualizations
	$(PYTHON) -m src.cli plot --all

demo: install generate plot ## Full demo: install, generate data, create plots
	@echo "🎉 Demo complete! Check exports/ directory for results."

format: ## Format code with black
	black src/ tests/

lint: ## Lint code with flake8
	flake8 src/ tests/

jupyter: ## Start Jupyter notebook server
	jupyter notebook notebooks/
EOF

# README.md
cat > README.md << 'EOF'
# 📊 PCC-VizForge: Synthetic Data Visualization Suite

A comprehensive visualization project inspired by Python Crash Course's data visualization track, featuring synthetic dataset generation and dual-library plotting (Matplotlib + Plotly).

## 🎯 Project Overview

**PCC-VizForge** demonstrates mastery of data visualization concepts through:
- **Synthetic data generation** for reproducible, offline workflows
- **Dual visualization approach** (static + interactive plots)
- **Portfolio-ready structure** with automated exports
- **Educational focus** on core visualization principles

## 🚀 Quick Start

```bash
# Clone and setup
git clone <your-repo-url>
cd pcc-vizforge

# Install and run demo
make demo
```

## 📁 Project Structure

```
pcc-vizforge/
├── config/          # YAML configurations for each dataset
├── data/synthetic/  # Generated datasets
├── exports/         # Output plots (images/ and html/)
├── src/             # Source code
│   ├── generators/  # Synthetic data generators
│   ├── plots/       # Matplotlib & Plotly visualizations
│   ├── utils/       # Utilities and theming
│   └── cli.py       # Command-line interface
├── notebooks/       # Jupyter exploration notebooks
└── tests/           # Unit tests
```

## 🔧 Usage

### Generate Data
```bash
# Generate specific dataset
python -m src.cli generate random_walk

# Generate all datasets
make generate
```

### Create Visualizations
```bash
# Plot specific dataset with matplotlib
python -m src.cli plot random_walk --library matplotlib

# Create all plots
make plot
```

## 📊 Datasets

1. **Random Walks** - Stochastic paths with statistical analysis
2. **Dice Experiments** - Multi-dice probability distributions
3. **Weather Series** - Seasonal patterns with realistic noise
4. **Earthquake Catalogs** - Magnitude-depth distributions
5. **GitHub Stats** - Repository metrics with power-law modeling

## 🛠 Development

```bash
make dev      # Install development dependencies
make test     # Run tests
make format   # Format code
make lint     # Check code style
```

## 📚 Learning Objectives

- Synthetic data generation techniques
- Statistical visualization principles
- Interactive vs. static plot design
- Reproducible analysis workflows
- Portfolio project structure

---

*Part of the Python Crash Course visualization learning track*
EOF

# Create .keep files for empty directories
echo "📌 Creating .keep files..."
touch data/synthetic/random_walk/.keep
touch data/synthetic/dice/.keep
touch data/synthetic/weather/.keep
touch data/synthetic/quakes/.keep
touch data/synthetic/github/.keep
touch exports/images/.keep
touch exports/html/.keep

# Create config files
echo "⚙️ Creating configuration files..."

# config/random_walk.yaml
cat > config/random_walk.yaml << 'EOF'
# Random Walk Configuration
dataset: "random_walk"
parameters:
  n_steps: 5000
  n_walks: 3
  step_size: 1.0
  seed: 42
  
output:
  filename: "random_walks.csv"
  
visualization:
  title: "Random Walk Analysis"
  colors: ["#1f77b4", "#ff7f0e", "#2ca02c"]
  figsize: [12, 8]
  highlight_endpoints: true
EOF

# config/dice.yaml
cat > config/dice.yaml << 'EOF'
# Dice Experiments Configuration
dataset: "dice"
parameters:
  n_dice: [1, 2, 3]
  n_rolls: 10000
  die_sides: 6
  seed: 42

output:
  filename: "dice_results.csv"

visualization:
  title: "Dice Roll Probability Distributions"
  colors: ["#d62728", "#9467bd", "#8c564b"]
  figsize: [14, 10]
  show_theoretical: true
EOF

# config/weather.yaml
cat > config/weather.yaml << 'EOF'
# Weather Data Configuration
dataset: "weather"
parameters:
  start_date: "2020-01-01"
  end_date: "2023-12-31"
  locations: ["City_A", "City_B"]
  temp_range: [-10, 35]  # Celsius
  noise_level: 2.5
  missing_rate: 0.02
  seed: 42

output:
  filename: "weather_data.csv"

visualization:
  title: "Weather Patterns Analysis"
  temp_colors: ["#ff4444", "#4444ff"]
  figsize: [15, 10]
  show_trends: true
EOF

# config/quakes.yaml
cat > config/quakes.yaml << 'EOF'
# Earthquake Catalog Configuration
dataset: "quakes"
parameters:
  n_events: 2000
  magnitude_range: [2.0, 8.5]
  depth_range: [1, 700]  # km
  lat_range: [-60, 70]
  lon_range: [-180, 180]
  clusters: 5  # Number of seismic zones
  seed: 42

output:
  filename: "earthquake_catalog.csv"

visualization:
  title: "Global Earthquake Activity"
  magnitude_colormap: "plasma"
  figsize: [16, 12]
  show_depth_distribution: true
EOF

# config/github.yaml
cat > config/github.yaml << 'EOF'
# GitHub-like Repository Stats Configuration
dataset: "github"
parameters:
  n_repositories: 1000
  languages: ["Python", "JavaScript", "Java", "C++", "Go", "Rust"]
  star_distribution: "power_law"  # or "normal"
  activity_months: 24
  seed: 42

output:
  filename: "github_stats.csv"

visualization:
  title: "Repository Statistics Analysis"
  language_colors:
    Python: "#3776ab"
    JavaScript: "#f7df1e" 
    Java: "#ed8b00"
    "C++": "#00599c"
    Go: "#00add8"
    Rust: "#000000"
  figsize: [14, 12]
  show_correlations: true
EOF

# Create Python package files
echo "🐍 Creating Python package structure..."

# src/__init__.py
cat > src/__init__.py << 'EOF'
"""
PCC-VizForge: Synthetic Data Visualization Suite

A comprehensive project for generating synthetic datasets and creating
both static (Matplotlib) and interactive (Plotly) visualizations.
"""

__version__ = "1.0.0"
__author__ = "Your Name"
EOF

# src/utils/__init__.py
touch src/utils/__init__.py

# src/utils/io.py
cat > src/utils/io.py << 'EOF'
"""I/O utilities for loading configurations and saving data."""

import yaml
import pandas as pd
from pathlib import Path
from typing import Dict, Any


def load_config(config_name: str) -> Dict[str, Any]:
    """Load YAML configuration file."""
    config_path = Path(f"config/{config_name}.yaml")
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)


def save_data(df: pd.DataFrame, dataset_name: str, filename: str) -> Path:
    """Save DataFrame to synthetic data directory."""
    output_dir = Path(f"data/synthetic/{dataset_name}")
    output_dir.mkdir(parents=True, exist_ok=True)
    output_path = output_dir / filename
    df.to_csv(output_path, index=False)
    return output_path


def load_data(dataset_name: str, filename: str) -> pd.DataFrame:
    """Load DataFrame from synthetic data directory."""
    data_path = Path(f"data/synthetic/{dataset_name}/{filename}")
    return pd.read_csv(data_path)
EOF

# src/utils/theming.py
cat > src/utils/theming.py << 'EOF'
"""Theming utilities for consistent plot styling."""

import matplotlib.pyplot as plt
import plotly.io as pio
from typing import List, Dict


# Professional color palette
COLORS = {
    'primary': '#1f77b4',
    'secondary': '#ff7f0e', 
    'accent': '#2ca02c',
    'danger': '#d62728',
    'dark': '#2f2f2f',
    'light': '#f0f0f0'
}

QUALITATIVE_PALETTE = [
    '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
    '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf'
]


def setup_matplotlib_style():
    """Configure matplotlib with professional styling."""
    plt.style.use('default')
    plt.rcParams.update({
        'figure.figsize': (10, 6),
        'axes.spines.top': False,
        'axes.spines.right': False,
        'axes.grid': True,
        'grid.alpha': 0.3,
        'font.size': 11,
        'axes.titlesize': 14,
        'axes.labelsize': 12,
        'xtick.labelsize': 10,
        'ytick.labelsize': 10,
        'legend.fontsize': 10
    })


def setup_plotly_theme():
    """Configure Plotly with professional styling."""
    pio.templates.default = "plotly_white"


def get_colors(n: int) -> List[str]:
    """Get n colors from the qualitative palette."""
    return (QUALITATIVE_PALETTE * ((n // len(QUALITATIVE_PALETTE)) + 1))[:n]
EOF

# src/generators/__init__.py
touch src/generators/__init__.py

# src/plots/__init__.py  
touch src/plots/__init__.py

# Create placeholder generator files
echo "📊 Creating generator placeholders..."
generators=("random_walk" "dice" "weather" "quakes" "github")
for gen in "${generators[@]}"; do
    gen_title=$(echo "$gen" | sed 's/_/ /g' | sed 's/\b\w/\U&/g')
    cat > "src/generators/${gen}.py" << EOF
"""${gen_title} synthetic data generator."""

import pandas as pd
import numpy as np
from src.utils.io import load_config, save_data


def generate_${gen}_data():
    """Generate ${gen} synthetic dataset."""
    config = load_config("${gen}")
    
    # TODO: Implement ${gen} data generation
    # This is a placeholder - implement according to config parameters
    
    # Example placeholder data
    df = pd.DataFrame({
        'placeholder': [1, 2, 3],
        'data': ['a', 'b', 'c']
    })
    
    output_path = save_data(df, "${gen}", config['output']['filename'])
    print(f"Generated ${gen} data: {output_path}")
    return df


if __name__ == "__main__":
    generate_${gen}_data()
EOF
done

# Create placeholder plot files
echo "📈 Creating plot placeholders..."
libraries=("mpl" "plotly")
for gen in "${generators[@]}"; do
    gen_title=$(echo "$gen" | sed 's/_/ /g' | sed 's/\b\w/\U&/g')
    for lib in "${libraries[@]}"; do
        lib_title=$(echo "$lib" | sed 's/\b\w/\U&/g')
        if [ "$lib" = "mpl" ]; then
            lib_full="matplotlib"
            import_line="import matplotlib.pyplot as plt"
            theme_import="setup_matplotlib_style"
            theme_call="setup_matplotlib_style()"
            plot_code="fig, ax = plt.subplots(figsize=config['visualization']['figsize'])
    ax.plot([1, 2, 3], [1, 2, 3])  # Placeholder
    ax.set_title(config['visualization']['title'])
    
    # Save plot
    output_path = Path(f\"exports/images/${gen}_matplotlib.png\")
    fig.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()"
        else
            lib_full="plotly"
            import_line="import plotly.express as px"
            theme_import="setup_plotly_theme"
            theme_call="setup_plotly_theme()"
            plot_code="fig = px.line(x=[1, 2, 3], y=[1, 2, 3])  # Placeholder
    fig.update_layout(title=config['visualization']['title'])
    
    # Save plot
    output_path = Path(f\"exports/html/${gen}_plotly.html\")
    fig.write_html(output_path)"
        fi
        
        cat > "src/plots/${gen}_${lib}.py" << EOF
"""${gen_title} visualization using ${lib_title}."""

import pandas as pd
${import_line}
from pathlib import Path
from src.utils.io import load_config, load_data
from src.utils.theming import ${theme_import}


def plot_${gen}_${lib_full}():
    """Create ${gen} visualization using ${lib_title}."""
    config = load_config("${gen}")
    df = load_data("${gen}", config['output']['filename'])
    
    ${theme_call}
    
    # TODO: Implement ${gen} ${lib} visualization
    # This is a placeholder - implement according to dataset
    
    ${plot_code}
    
    print(f"Created ${gen} ${lib} plot: {output_path}")
    return fig


if __name__ == "__main__":
    plot_${gen}_${lib_full}()
EOF
    done
done

# src/cli.py
cat > src/cli.py << 'EOF'
"""Command-line interface for PCC-VizForge."""

import click
from pathlib import Path


@click.group()
@click.version_option()
def main():
    """PCC-VizForge: Synthetic Data Visualization Suite"""
    pass


@main.command()
@click.argument('dataset', required=False)
@click.option('--all', is_flag=True, help='Generate all datasets')
def generate(dataset, all):
    """Generate synthetic datasets."""
    datasets = ['random_walk', 'dice', 'weather', 'quakes', 'github']
    
    if all:
        click.echo("🔄 Generating all synthetic datasets...")
        for ds in datasets:
            _generate_dataset(ds)
    elif dataset:
        if dataset not in datasets:
            click.echo(f"❌ Unknown dataset: {dataset}")
            click.echo(f"Available datasets: {', '.join(datasets)}")
            return
        _generate_dataset(dataset)
    else:
        click.echo("Please specify a dataset or use --all flag")
        click.echo(f"Available datasets: {', '.join(datasets)}")


@main.command()
@click.argument('dataset', required=False)
@click.option('--library', type=click.Choice(['matplotlib', 'plotly']), help='Visualization library')
@click.option('--all', is_flag=True, help='Create all plots')
def plot(dataset, library, all):
    """Create visualizations."""
    datasets = ['random_walk', 'dice', 'weather', 'quakes', 'github']
    
    if all:
        click.echo("📊 Creating all visualizations...")
        for ds in datasets:
            _create_plots(ds, library)
    elif dataset:
        if dataset not in datasets:
            click.echo(f"❌ Unknown dataset: {dataset}")
            return
        _create_plots(dataset, library)
    else:
        click.echo("Please specify a dataset or use --all flag")


def _generate_dataset(dataset):
    """Generate a specific dataset."""
    try:
        module = __import__(f'src.generators.{dataset}', fromlist=[''])
        func = getattr(module, f'generate_{dataset}_data')
        func()
        click.echo(f"✅ Generated {dataset} dataset")
    except Exception as e:
        click.echo(f"❌ Failed to generate {dataset}: {e}")


def _create_plots(dataset, library):
    """Create plots for a specific dataset."""
    libraries = ['matplotlib', 'plotly'] if not library else [library]
    
    for lib in libraries:
        try:
            lib_short = 'mpl' if lib == 'matplotlib' else 'plotly'
            module = __import__(f'src.plots.{dataset}_{lib_short}', fromlist=[''])
            func_name = f'plot_{dataset}_{lib}'
            if lib == 'matplotlib':
                func_name = f'plot_{dataset}_matplotlib'
            func = getattr(module, func_name)
            func()
            click.echo(f"✅ Created {dataset} {lib} plot")
        except Exception as e:
            click.echo(f"❌ Failed to create {dataset} {lib} plot: {e}")


if __name__ == '__main__':
    main()
EOF

# Create notebook placeholders
echo "📓 Creating Jupyter notebooks..."
notebooks=("01_random_walk" "02_dice" "03_weather" "04_quakes" "05_github")
for nb in "${notebooks[@]}"; do
    cat > "notebooks/${nb}.ipynb" << 'EOF'
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Notebook Placeholder\n",
    "\n",
    "This notebook will explore the dataset and demonstrate visualization techniques.\n",
    "\n",
    "## TODO:\n",
    "- Import libraries\n",
    "- Load synthetic data\n",
    "- Exploratory analysis\n",
    "- Create visualizations\n",
    "- Document insights"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# Imports\n",
    "import pandas as pd\n",
    "import numpy as np\n",
    "import matplotlib.pyplot as plt\n",
    "import plotly.express as px\n",
    "\n",
    "# Local imports\n",
    "from src.utils.io import load_config, load_data\n",
    "from src.utils.theming import setup_matplotlib_style, setup_plotly_theme"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Data Generation and Loading\n",
    "\n",
    "TODO: Add data generation and loading code"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Exploratory Analysis\n",
    "\n",
    "TODO: Add data exploration code"
   ]
  },
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "## Visualizations\n",
    "\n",
    "TODO: Add visualization code"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}
EOF
done

# Create test files
echo "🧪 Creating test files..."

# tests/__init__.py
touch tests/__init__.py

# tests/test_generators.py
cat > tests/test_generators.py << 'EOF'
"""Tests for data generators."""

import pytest
import pandas as pd
from pathlib import Path

# TODO: Import specific generators as they are implemented
# from src.generators.random_walk import generate_random_walk_data


class TestGenerators:
    """Test data generation functionality."""
    
    def test_placeholder(self):
        """Placeholder test - replace with actual generator tests."""
        assert True
    
    # TODO: Add tests for each generator
    # Example:
    # def test_random_walk_generation(self):
    #     """Test random walk data generation."""
    #     df = generate_random_walk_data()
    #     assert isinstance(df, pd.DataFrame)
    #     assert len(df) > 0
    #     # Add more specific validation
EOF

# tests/test_plots.py
cat > tests/test_plots.py << 'EOF'
"""Tests for plot generation."""

import pytest
from pathlib import Path

# TODO: Import specific plotting functions as they are implemented


class TestPlots:
    """Test plot generation functionality."""
    
    def test_placeholder(self):
        """Placeholder test - replace with actual plot tests."""
        assert True
    
    # TODO: Add tests for each plotting function
    # Example:
    # def test_random_walk_matplotlib_plot(self):
    #     """Test matplotlib random walk plot generation."""
    #     fig = plot_random_walk_matplotlib()
    #     assert fig is not None
    #     # Check if output file was created
    #     assert Path("exports/images/random_walk_matplotlib.png").exists()
EOF

echo ""
echo "🎉 PCC-VizForge project structure created successfully!"
echo ""
echo "📁 Project location: $BASE_DIR"
echo ""
echo "🚀 Next steps:"
echo "   1. cd $PROJECT_NAME"
echo "   2. python -m venv venv && source venv/bin/activate"
echo "   3. make install"
echo "   4. Start implementing generators and plots!"
echo ""
echo "💡 Use 'make help' to see all available commands"
echo ""
echo "📚 Key files to start with:"
echo "   - src/generators/ - Implement data generation logic"
echo "   - src/plots/ - Implement visualization functions" 
echo "   - notebooks/ - Jupyter exploration notebooks"
echo ""