import yaml
import torch
import numpy as np
import tensorflow as tf
from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel

import custom_model

config = yaml.load(open("./deploy/config.yml", "r"), Loader=yaml.SafeLoader)["model_settings"]

device = "cuda" if config["gpu"] and torch.cuda.is_available() else "cpu"

if config["load_directly"]:
    if config["package"] == "tensorflow":
        model = tf.keras.models.load_model(config["pretrained_filepath"])
        model = model.predict
        to_tensor = tf.convert_to_tensor
    else:
        model = torch.load(config["pretrained_filepath"])
        model.eval()
        to_tensor = lambda x: torch.Tensor(x).to(device)
else:
    model = getattr(custom_model, custom_model)
    to_tensor = lambda x: x

app = FastAPI()

class InferenceInput(BaseModel):
    inp: list

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

@app.post("/test_run")
def test_run(inference_input: InferenceInput):
    result = model(to_tensor(inference_input.inp))
    return {"result": result.tolist()}
