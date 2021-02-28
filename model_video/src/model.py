# code partially from: https://github.com/siqueira-hc/Efficient-Facial-Feature-Learning-with-Wide-Ensemble-based-Convolutional-Neural-Networks
import os
import sys
import json
import yaml
import logging
import requests

import torch
import numpy as np
from tqdm import tqdm
import face_recognition
import torchvision.transforms as t
from torch.utils.data import Dataset, DataLoader
from torchvision.datasets.folder import default_loader

from facial_emotion_recognition import facial_emotion_recognition_video

logger = logging.getLogger(__name__)

class model:
    def __init__(self):
        self.user_image_URL = "https://kpmg-ybigta-image.s3.ap-northeast-2.amazonaws.com/user_image.jpg"

    def inference(self, message:json):

        result = facial_emotion_recognition_video(message["video_path"], self.user_image_URL)
        
        fname = message["video_path"]+"_result.json"
        json.dump(result, open(fname, "w"))
        print(f"Results dumped in JSON in {fname}")

        return result
        

    def deploy(self):
        
        look_at_queue = {"input": np.ndarray(self.config["unittest_settings"]["input_dimension"])}
        output = self.inference(look_at_queue)

    def run(self):
        print("Model successfully deployed")
        while True:
            self.deploy()

if __name__=="__main__":

    model = model()

    model.run()
