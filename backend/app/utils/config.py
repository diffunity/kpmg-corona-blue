import yaml
from pathlib import Path

with Path("config.yaml").open() as config_file:
    CONFIG = yaml.load(config_file, Loader=yaml.FullLoader)
