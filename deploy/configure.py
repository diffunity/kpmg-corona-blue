import yaml

with open("./deploy/requirements.txt", "r") as f:
  pip = f.readlines()

pip = [i.replace("_", "-").strip() for i in pip]
conda = yaml.load(open("./deploy/environment.yml","r"), Loader=yaml.SafeLoader)
conda["dependencies"][-1]["pip"] = pip
open("./deploy/environment.yml", "w").write(yaml.dump(conda))
print(pip)
print(conda)
