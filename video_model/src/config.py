import os
import yaml
from pathlib import Path

cwd = os.getcwd()
print(cwd)
with Path(f"{cwd}/conf/config.yaml").open() as config_file:
    CONFIG = yaml.load(config_file, Loader=yaml.FullLoader)
