# code partially from: https://github.com/siqueira-hc/Efficient-Facial-Feature-Learning-with-Wide-Ensemble-based-Convolutional-Neural-Networks
import os
import sys
import json
import yaml
import logging

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

        self.config = yaml.load(open("./conf/config.yml", "r"), Loader=yaml.SafeLoader)
        self.model = torch.load(self.config["model_settings"]["pretrained_filepath"])
        self.model.eval()


    def inference(self, message:json):

        result = facial_emotion_recognition_video(message["video_path"], "./user_image.jpg")

        return result
        

    def deploy(self):

        ###########
        # sqs queue initialization (backend)
        ###########
        
        look_at_queue = {"input": np.ndarray(self.config["unittest_settings"]["input_dimension"])}
        output = self.inference(look_at_queue)

        ###########
        # send back result to API by sqs (backend)
        # 
        ###########

    def run(self):
        print("Model successfully deployed")
        while True:
            self.deploy()

if __name__=="__main__":
    
    ###########
    # sqs queue initialization (backend)
    # 
    # 
    # 
    # 
    ###########
    model = model()

    model.run()
