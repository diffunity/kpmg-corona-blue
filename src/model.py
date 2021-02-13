# code partially from: https://github.com/fabiocarrara/visual-sentiment-analysis
# code partially from: https://github.com/siqueira-hc/Efficient-Facial-Feature-Learning-with-Wide-Ensemble-based-Convolutional-Neural-Networks
import os
import sys
import json
import yaml

import torch
import numpy as np
from tqdm import tqdm
import face_recognition
import torchvision.transforms as t
from torch.utils.data import Dataset, DataLoader
from torchvision.datasets.folder import default_loader

from vgg19 import KitModel as VGG19
from alexnet import KitModel as AlexNet

from facial_emotion_recognition import facial_emotion_recognition_image

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
            
        x = default_loader(path)
        # if self.transform:
        #     x = self.transform(x)
        
        # return self.transform(x), np.array(x)

        # self.transform = t.Compose([t.Resize((224,224))])
        # x = self.transform(x)
        return x
    
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

        # mock message from backend
        message["db_directory"] = "./TestData"
        message["file_list"] = "./image_list.txt"
        message["user_image"] = "./known_image.jpg"
 
        result = dict()

        # user image encoding
        user_image = face_recognition.load_image_file(message["user_image"])
        user_image_encoded = face_recognition.face_encodings(user_image)[0]

        data = ImageListDataset(message["file_list"], root=message["db_directory"], transform=self.transform)
        dataloader = DataLoader(data, batch_size=10, num_workers=8, pin_memory=True)
        with torch.no_grad():
            for e, x in enumerate(tqdm(data)):
                
                x_np = np.array(x)
                image_enc = face_recognition.face_encodings(x_np)

                if image_enc != []:
                    for detected_image_enc in image_enc:
                        if face_recognition.compare_faces([user_image], detected_image_enc[0]):
                            
                            # model for facial emotion recognition
                            fer_result = facial_emotion_recognition_image(x_np, path=False)
                            result[f"output{e}_fer"] = fer_result.__dict__
                            continue
                
                if f"output{e}_fer" in result.keys():
                    continue
                # inference for non-facial image (inferenced also when face was detected but no face matched user's face)
                x = self.transform(x).unsqueeze(0)
                p = self.model(x.to('cpu')).cpu().numpy().tolist()  # order is (NEG, NEU, POS)
                result[f"output{e}_vsa"] = p

        return result


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
