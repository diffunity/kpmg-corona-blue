# code partially from: https://github.com/fabiocarrara/visual-sentiment-analysis
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
from PIL import Image, ImageOps
import torchvision.transforms as t
from torch.utils.data import Dataset, DataLoader
from torchvision.datasets.folder import default_loader
from facial_emotion_recognition import facial_emotion_recognition_image

from vgg19 import KitModel as VGG19
from alexnet import KitModel as AlexNet

logger = logging.getLogger(__name__)

class ImageListDataset (Dataset):

    def __init__(self, list_filename, root=None, transform=None):
        super(ImageListDataset).__init__()
    
        with open(list_filename, 'r') as list_file:
            self.list = list(map(str.rstrip, list_file))
        
        self.root = root
        self.transform = transform
        
    def __getitem__(self, index):
        path = self.list[index]
        if self.root:
            path = os.path.join(self.root, path)
            
        return default_loader(path)
    
    def __len__(self):
        return len(self.list)

class model:
    def __init__(self):
        
        machine = "cuda" if torch.cuda.is_available() else "cpu"
        self.config = yaml.load(open("./conf/config.yml", "r"), Loader=yaml.SafeLoader)

        self.transform = t.Compose([
            t.Resize((224, 224)),
            t.ToTensor(),
            t.Lambda(lambda x: x[[2,1,0], ...] * 255),  # RGB -> BGR and [0,1] -> [0,255]
            t.Normalize(mean=[116.8007, 121.2751, 130.4602], std=[1,1,1]),  # mean subtraction
        ])

        models = ('hybrid_finetuned_fc6+',
                  'hybrid_finetuned_all',
                  'vgg19_finetuned_fc6+',
                  'vgg19_finetuned_all')

        # last model selected
        self.model = AlexNet if 'hybrid' in models[-1] else VGG19
        print('./saved_models/{}.pth'.format(models[-1]))
        self.model = self.model('./saved_models/{}.pth'.format(models[-1])).to(machine)
        self.model.eval()

    def inference(self, message:json):

        result = dict()

        # user image encoding
        user_image = face_recognition.load_image_file(message["user_image"])
        user_image_enc = face_recognition.face_encodings(user_image)[0]

        # retrieve image data to be analyzed
        data = ImageListDataset(message["file_list"], root=message["db_directory"], transform=self.transform)

        # for individual files from url
        # im = Image.open(requests.get(url, stream=True).raw)
        # get rid of enumerate(tqdm(data)) for individual url

        with torch.no_grad():
            for e, x in enumerate(tqdm(data)):

                x = ImageOps.exif_transpose(x) 
                x_np = np.array(x)
                image_enc = face_recognition.face_encodings(x_np)

                face_locations = face_recognition.face_locations(x_np)

                if len(face_locations) > 0:

                    fer_result = facial_emotion_recognition_image(x_np, 
                                                                  user_image_enc,
                                                                  face_locations,
                                                                  path=False)
                    if fer_result is not False:
                        Image.fromarray(fer_result.face_image).save(f"./face_results/output_{e}.jpg","JPEG")
                        result[f"output_{e}"] = {"results": {"emotions": fer_result.list_emotion, "affects": fer_result.list_affect},
                                                 "method": "FER"}
                        continue

                # inference for non-facial image (inferenced also when face was detected but no face matched user's face)
                x = self.transform(x).unsqueeze(0)
                p = self.model(x.to('cpu')).cpu().numpy().tolist()  # order is (NEG, NEU, POS)
                result[f"output_{e}"] = {"contents": p,
                                         "method": "VSA"}

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