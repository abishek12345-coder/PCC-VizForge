# Location: src/generators/random_walk.py

"""Random Walk data generator."""

from typing import Dict, List, Optional, Tuple, Union
import numpy as np
import pandas as pd

from src.utils.io import load_config, save_data, get_data_directory


class RandomWalkGenerator:
    """Generator for random walk data."""
    
    def __init__(self, config_name: str = "random_walk"):
        """Initialize the generator with configuration.
        
        Args:
            config_name: Name of configuration file to use
        """
        self.config = load_config(config_name)
        self.data_config = self.config["data_generation"]
        
    def generate(self, save_to_file: bool = True) -> pd.DataFrame:
        """Generate random walk data.
        
        Args:
            save_to_file: Whether to save generated data to file
            
        Returns:
            DataFrame with random walk data
        """
        # Set random seed for reproducibility
        if "random_seed" in self.data_config:
            np.random.seed(self.data_config["random_seed"])
        
        n_steps = self.data_config["n_steps"]
        n_walks = self.data_config["n_walks"]
        step_size = self.data_config["step_size"]
        dimensions = self.data_config.get("dimensions", 1)
        
        data = []
        
        for walk_id in range(n_walks):
            if dimensions == 1:
                # 1D random walk
                steps = np.random.choice([-1, 1], size=n_steps) * step_size
                positions = np.cumsum(steps)
                
                for step in range(n_steps):
                    data.append({
                        "walk_id": walk_id,
                        "step": step,
                        "position": positions[step],
                        "x_position": positions[step],
                        "y_position": 0,
                    })
                    
            else:
                # 2D random walk
                x_steps = np.random.choice([-1, 1], size=n_steps) * step_size
                y_steps = np.random.choice([-1, 1], size=n_steps) * step_size
                
                x_positions = np.cumsum(x_steps)
                y_positions = np.cumsum(y_steps)
                
                for step in range(n_steps):
                    distance = np.sqrt(x_positions[step]**2 + y_positions[step]**2)
                    data.append({
                        "walk_id": walk_id,
                        "step": step,
                        "position": distance,
                        "x_position": x_positions[step],
                        "y_position": y_positions[step],
                    })
        
        df = pd.DataFrame(data)
        
        # Add derived metrics
        df["cumulative_distance"] = df.groupby("walk_id")["position"].cumsum()
        df["step_size"] = df.groupby("walk_id")["position"].diff().fillna(0).abs()
        
        if save_to_file:
            data_dir = get_data_directory("random_walk")
            save_data(df, data_dir / "random_walk_data.csv", "csv")
        
        return df
    
    def generate_multiple_scenarios(self, scenarios: List[Dict], 
                                   save_to_file: bool = True) -> Dict[str, pd.DataFrame]:
        """Generate multiple random walk scenarios with different parameters.
        
        Args:
            scenarios: List of parameter dictionaries to override config
            save_to_file: Whether to save generated data to files
            
        Returns:
            Dictionary mapping scenario names to DataFrames
        """
        results = {}
        original_config = self.data_config.copy()
        
        for i, scenario in enumerate(scenarios):
            scenario_name = scenario.get("name", f"scenario_{i}")
            
            # Update config with scenario parameters
            self.data_config.update(scenario)
            
            # Generate data
            df = self.generate(save_to_file=False)
            df["scenario"] = scenario_name
            results[scenario_name] = df
            
            if save_to_file:
                data_dir = get_data_directory("random_walk")
                save_data(df, data_dir / f"random_walk_{scenario_name}.csv", "csv")
        
        # Restore original config
        self.data_config = original_config
        
        return results
    
    def calculate_statistics(self, data: pd.DataFrame) -> Dict[str, float]:
        """Calculate statistical measures for random walk data.
        
        Args:
            data: Random walk DataFrame
            
        Returns:
            Dictionary of statistical measures
        """
        stats = {}
        
        # Final positions
        final_positions = data.groupby("walk_id")["position"].last()
        stats["mean_final_position"] = final_positions.mean()
        stats["std_final_position"] = final_positions.std()
        stats["max_final_position"] = final_positions.max()
        stats["min_final_position"] = final_positions.min()
        
        # Maximum excursions
        max_positions = data.groupby("walk_id")["position"].max()
        min_positions = data.groupby("walk_id")["position"].min()
        
        stats["mean_max_excursion"] = max_positions.mean()
        stats["mean_min_excursion"] = min_positions.mean()
        stats["mean_total_excursion"] = (max_positions - min_positions).mean()
        
        # Step statistics
        stats["mean_step_size"] = data["step_size"].mean()
        stats["total_steps"] = len(data)
        stats["n_walks"] = data["walk_id"].nunique()
        
        return stats
    
    def get_walk_summary(self, data: pd.DataFrame, walk_id: int) -> Dict[str, Union[float, int]]:
        """Get summary statistics for a specific walk.
        
        Args:
            data: Random walk DataFrame
            walk_id: ID of the walk to summarize
            
        Returns:
            Dictionary of walk statistics
        """
        walk_data = data[data["walk_id"] == walk_id]
        
        if walk_data.empty:
            raise ValueError(f"Walk ID {walk_id} not found in data")
        
        return {
            "walk_id": walk_id,
            "n_steps": len(walk_data),
            "final_position": walk_data["position"].iloc[-1],
            "max_position": walk_data["position"].max(),
            "min_position": walk_data["position"].min(),
            "total_distance": walk_data["cumulative_distance"].iloc[-1],
            "mean_step_size": walk_data["step_size"].mean(),
            "net_displacement": abs(walk_data["position"].iloc[-1]),
        }