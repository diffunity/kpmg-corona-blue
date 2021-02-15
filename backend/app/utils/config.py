import yaml
import os
import sys
from pathlib import Path
cwd = os.getcwd()
print(cwd)

sys.path.append(f"{cwd}/app")

with Path(f"./config.yaml").open() as config_file:
    CONFIG = yaml.load(config_file, Loader=yaml.FullLoader)
