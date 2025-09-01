# Location: src/utils/io.py

"""Input/Output utilities for PCC VizForge."""

import os
import json
import pickle
from pathlib import Path
from typing import Any, Dict, Optional, Union

import pandas as pd
import yaml


def load_config(config_name: str) -> Dict[str, Any]:
    """Load configuration from YAML file.
    
    Args:
        config_name: Name of the config file (without .yaml extension)
        
    Returns:
        Dictionary containing configuration data
        
    Raises:
        FileNotFoundError: If config file doesn't exist
        yaml.YAMLError: If config file is invalid
    """
    config_path = Path(f"config/{config_name}.yaml")
    
    if not config_path.exists():
        raise FileNotFoundError(f"Configuration file not found: {config_path}")
    
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)
        return config
    except yaml.YAMLError as e:
        raise yaml.YAMLError(f"Error parsing config file {config_path}: {e}")


def ensure_directory_exists(file_path: Union[str, Path]) -> None:
    """Ensure that the directory for a file path exists.
    
    Args:
        file_path: Path to file (directory will be created if it doesn't exist)
    """
    path = Path(file_path)
    path.parent.mkdir(parents=True, exist_ok=True)


def save_data(data: Any, file_path: Union[str, Path], format_type: str = "auto") -> None:
    """Save data to file in specified format.
    
    Args:
        data: Data to save (pandas DataFrame, dict, list, etc.)
        file_path: Output file path
        format_type: Format to save in ('csv', 'json', 'pickle', 'auto')
                    'auto' infers from file extension
    """
    file_path = Path(file_path)
    ensure_directory_exists(file_path)
    
    if format_type == "auto":
        format_type = file_path.suffix.lower().lstrip('.')
    
    if format_type == "csv":
        if isinstance(data, pd.DataFrame):
            data.to_csv(file_path, index=False)
        else:
            raise ValueError("CSV format requires pandas DataFrame")
    
    elif format_type == "json":
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, default=str)
    
    elif format_type in ["pickle", "pkl"]:
        with open(file_path, 'wb') as f:
            pickle.dump(data, f)
    
    else:
        raise ValueError(f"Unsupported format: {format_type}")


def load_data(file_path: Union[str, Path], format_type: str = "auto") -> Any:
    """Load data from file.
    
    Args:
        file_path: Input file path
        format_type: Format to load from ('csv', 'json', 'pickle', 'auto')
                    'auto' infers from file extension
        
    Returns:
        Loaded data
        
    Raises:
        FileNotFoundError: If file doesn't exist
        ValueError: If format is unsupported
    """
    file_path = Path(file_path)
    
    if not file_path.exists():
        raise FileNotFoundError(f"Data file not found: {file_path}")
    
    if format_type == "auto":
        format_type = file_path.suffix.lower().lstrip('.')
    
    if format_type == "csv":
        return pd.read_csv(file_path)
    
    elif format_type == "json":
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    elif format_type in ["pickle", "pkl"]:
        with open(file_path, 'rb') as f:
            return pickle.load(f)
    
    else:
        raise ValueError(f"Unsupported format: {format_type}")


def get_data_directory(data_type: str) -> Path:
    """Get the data directory path for a specific data type.
    
    Args:
        data_type: Type of data (e.g., 'random_walk', 'dice', etc.)
        
    Returns:
        Path to the data directory
    """
    data_dir = Path(f"data/synthetic/{data_type}")
    data_dir.mkdir(parents=True, exist_ok=True)
    return data_dir


def get_export_directory(export_type: str) -> Path:
    """Get the export directory path for a specific export type.
    
    Args:
        export_type: Type of export ('images' or 'html')
        
    Returns:
        Path to the export directory
    """
    export_dir = Path(f"exports/{export_type}")
    export_dir.mkdir(parents=True, exist_ok=True)
    return export_dir


def list_available_configs() -> list[str]:
    """List all available configuration files.
    
    Returns:
        List of configuration names (without .yaml extension)
    """
    config_dir = Path("config")
    if not config_dir.exists():
        return []
    
    configs = []
    for file in config_dir.glob("*.yaml"):
        configs.append(file.stem)
    
    return sorted(configs)