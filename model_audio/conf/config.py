import yaml
import os
import sys
from pathlib import Path

dir_path = os.path.dirname(os.path.abspath(__file__))

sys.path.append(dir_path)
print("dir_path:", dir_path)

with Path(f"{dir_path}/config.yaml").open() as config_file:
    CONFIG = yaml.load(config_file, Loader=yaml.FullLoader)
