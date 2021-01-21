from typing import Optional

from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/versions")
def pip_list():
    with open("./deploy/requirements.txt", "r") as f:
        pips = f.readlines()
        print(pips)
        pips = [i.strip().split("==") for i in pips]


    pip_list = []
    for pip in pips:
        print(pip)
        pip_list.append(\
            {"package": pip[0],\
             "version": pip[-1]}\
        )
    return pip_list
