import json
import yaml

import torch
import numpy as np
import tensorflow as tf 

from facial_emotion_recognition import video

class model:
    def __init__(self):
        
        ###########
        # model initialization (modeller)
        # 
        # 
        # 
        # 
        ###########

        ########### example
        self.config = yaml.load(open("./conf/config.yml", "r"), Loader=yaml.SafeLoader)
        self.model = torch.load(self.config["model_settings"]["pretrained_filepath"])
        self.model.eval()
        ###########

    def inference(self, message:json):
        ###########
        # jsonify model results (modeller)
        # 
        # 
        # 
        # 
        ###########

        ########### example
        frame = message["input"]
        output = self.model(torch.Tensor(frame))
        return {"output": output.detach().numpy().tolist()}
        ###########

    def deploy(self):

        ###########
        # sqs queue initialization (backend)
        # 
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