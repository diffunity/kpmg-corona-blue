import os
import requests

# path = "./src/fer_model/ml/trained_models/esr_9/"
path = "./"
sr = "Net-Base-Shared_Representations"
url = f"https://kpmg-ybigta-image.s3.ap-northeast-2.amazonaws.com/{sr}.pt"
r = requests.get(url, allow_redirects=True)

open(path+f"{sr}.pt", "wb").write(r.content)
print(path+f"{sr}.pt saved")

for i in range (1, 10):
    branch = f"Net-Branch_{i}"
    url = f"https://kpmg-ybigta-image.s3.ap-northeast-2.amazonaws.com/{branch}.pt"
    r = requests.get(url, allow_redirects=True)
    open(path+f"{branch}.pt", "wb").write(r.content) 
    print(path+f"{branch}.pt saved")

