import os
import requests

os.chdir("./src/fer_model/ml/trained_models/esr_9")
sr = "Base-Shared_Representations"
url = f"https://kpmg-ybigta-image.s3.ap-northeast-2.amazonaws.com/Net-{sr}.pt"
r = requests.get(url, allow_redirects=True)

open(f"Net-{sr}.pt", "wb").write(r.content)
print(f"{sr} saved")

for i in range (1, 10):
    branch = f"Branch_{i}.pt"
    url = f"https://kpmg-ybigta-image.s3.ap-northeast-2.amazonaws.com/Net-{branch}"
    r = requests.get(url, allow_redirects=True)
    open(f"Net-{branch}", "wb").write(r.content) 
    print(f"{branch} saved")

