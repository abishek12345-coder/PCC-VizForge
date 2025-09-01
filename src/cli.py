# Location: src/cli.py

"""Command-line interface for PCC VizForge."""

import click
from pathlib import Path
from typing import Optional

from src.generators import (
    RandomWalkGenerator, DiceGenerator, WeatherGenerator, 
    EarthquakeGenerator, GitHubGenerator
)
from src.plots import (
    RandomWalkMatplotlibPlot, DiceMatplotlibPlot, WeatherMatplotlibPlot,
    EarthquakeMatplotlibPlot, GitHubMatplotlibPlot
)


@click.group()
@click.version_option()
def main():
    """PCC VizForge - Comprehensive Data Visualization Toolkit."""
    pass


@main.command()
@click.option('--library', type=click.Choice(['matplotlib', 'plotly']), default='matplotlib',
              help='Visualization library to use')
@click.option('--export-type', type=click.Choice(['image', 'html']), default='image',
              help='Export format')
@click.option('--save/--no-save', default=True, help='Save generated data')
@click.option('--filename', help='Custom output filename')
def random_walk(library: str, export_type: str, save: bool, filename: Optional[str]):
    """Generate random walk visualization."""
    click.echo("Generating random walk data...")
    
    # Generate data
    generator = RandomWalkGenerator()
    data = generator.generate(save_to_file=save)
    
    # Create visualization
    if library == 'matplotlib':
        plotter = RandomWalkMatplotlibPlot()
        fig = plotter.plot(data)
        
        if export_type == 'image':
            output_path = plotter.save(fig, filename)
            click.echo(f"Saved matplotlib plot to: {output_path}")
        else:
            click.echo("HTML export not supported for matplotlib. Use plotly instead.")
    
    elif library == 'plotly':
        # Import here to avoid loading plotly if not needed
        from src.plots.random_walk_plotly import RandomWalkPlotlyPlot
        plotter = RandomWalkPlotlyPlot()
        fig = plotter.plot(data)
        
        if export_type == 'html':
            output_path = plotter.save(fig, filename)
            click.echo(f"Saved plotly plot to: {output_path}")
        else:
            output_path = plotter.save_image(fig, filename)
            click.echo(f"Saved plotly image to: {output_path}")
    
    click.echo(f"Generated {len(data)} data points for {data['walk_id'].nunique()} walks")


@main.command()
@click.option('--library', type=click.Choice(['matplotlib', 'plotly']), default='matplotlib')
@click.option('--export-type', type=click.Choice(['image', 'html']), default='image')
@click.option('--save/--no-save', default=True)
@click.option('--filename', help='Custom output filename')
def dice(library: str, export_type: str, save: bool, filename: Optional[str]):
    """Generate dice simulation visualization."""
    click.echo("Generating dice simulation data...")
    
    generator = DiceGenerator()
    data = generator.generate(save_to_file=save)
    
    if library == 'matplotlib':
        plotter = DiceMatplotlibPlot()
        fig = plotter.plot(data)
        
        if export_type == 'image':
            output_path = plotter.save(fig, filename)
            click.echo(f"Saved matplotlib plot to: {output_path}")
    
    elif library == 'plotly':
        from src.plots.dice_plotly import DicePlotlyPlot
        plotter = DicePlotlyPlot()
        fig = plotter.plot(data)
        
        if export_type == 'html':
            output_path = plotter.save(fig, filename)
            click.echo(f"Saved plotly plot to: {output_path}")
    
    click.echo(f"Generated {len(data)} data points for dice simulation")


@main.command()
@click.option('--library', type=click.Choice(['matplotlib', 'plotly']), default='matplotlib')
@click.option('--export-type', type=click.Choice(['image', 'html']), default='image')
@click.option('--save/--no-save', default=True)
@click.option('--filename', help='Custom output filename')
def weather(library: str, export_type: str, save: bool, filename: Optional[str]):
    """Generate weather data visualization."""
    click.echo("Generating weather data...")
    
    generator = WeatherGenerator()
    data = generator.generate(save_to_file=save)
    
    if library == 'matplotlib':
        plotter = WeatherMatplotlibPlot()
        fig = plotter.plot(data)
        
        if export_type == 'image':
            output_path = plotter.save(fig, filename)
            click.echo(f"Saved matplotlib plot to: {output_path}")
    
    click.echo(f"Generated {len(data)} days of weather data")


@main.command()
@click.option('--library', type=click.Choice(['matplotlib', 'plotly']), default='matplotlib')
@click.option('--export-type', type=click.Choice(['image', 'html']), default='image')
@click.option('--save/--no-save', default=True)
@click.option('--filename', help='Custom output filename')
def quakes(library: str, export_type: str, save: bool, filename: Optional[str]):
    """Generate earthquake data visualization."""
    click.echo("Generating earthquake data...")
    
    generator = EarthquakeGenerator()
    data = generator.generate(save_to_file=save)
    
    if library == 'matplotlib':
        plotter = EarthquakeMatplotlibPlot()
        fig = plotter.plot(data)
        
        if export_type == 'image':
            output_path = plotter.save(fig, filename)
            click.echo(f"Saved matplotlib plot to: {output_path}")
    
    click.echo(f"Generated {len(data)} earthquake data points")


@main.command()
@click.option('--library', type=click.Choice(['matplotlib', 'plotly']), default='matplotlib')
@click.option('--export-type', type=click.Choice(['image', 'html']), default='image')
@click.option('--save/--no-save', default=True)
@click.option('--filename', help='Custom output filename')
def github(library: str, export_type: str, save: bool, filename: Optional[str]):
    """Generate GitHub statistics visualization."""
    click.echo("Generating GitHub statistics...")
    
    generator = GitHubGenerator()
    data = generator.generate(save_to_file=save)
    
    if library == 'matplotlib':
        plotter = GitHubMatplotlibPlot()
        fig = plotter.plot(data)
        
        if export_type == 'image':
            output_path = plotter.save(fig, filename)
            click.echo(f"Saved matplotlib plot to: {output_path}")
    
    click.echo(f"Generated {len(data)} repository data points")


@main.command()
def list_configs():
    """List available configuration files."""
    from src.utils.io import list_available_configs
    
    configs = list_available_configs()
    if configs:
        click.echo("Available configurations:")
        for config in configs:
            click.echo(f"  - {config}")
    else:
        click.echo("No configuration files found in config/ directory")


@main.command()
@click.argument('config_name')
def show_config(config_name: str):
    """Show configuration file contents."""
    from src.utils.io import load_config
    import yaml
    
    try:
        config = load_config(config_name)
        click.echo(f"Configuration for {config_name}:")
        click.echo(yaml.dump(config, default_flow_style=False, indent=2))
    except FileNotFoundError:
        click.echo(f"Configuration '{config_name}' not found")


@main.command()
def demo():
    """Run a quick demo generating all visualizations."""
    click.echo("Running PCC VizForge demo...")
    
    demos = [
        ('random_walk', 'matplotlib', 'image'),
        ('dice', 'matplotlib', 'image'),
        ('weather', 'matplotlib', 'image'),
    ]
    
    for data_type, lib, export in demos:
        click.echo(f"\nGenerating {data_type} with {lib}...")
        try:
            # Use click's invoke to call other commands
            from click.testing import CliRunner
            runner = CliRunner()
            result = runner.invoke(main, [data_type, '--library', lib, '--export-type', export])
            if result.exit_code == 0:
                click.echo(f"✓ {data_type} completed successfully")
            else:
                click.echo(f"✗ {data_type} failed: {result.output}")
        except Exception as e:
            click.echo(f"✗ {data_type} failed: {str(e)}")
    
    click.echo("\nDemo completed!")


if __name__ == '__main__':
    main()