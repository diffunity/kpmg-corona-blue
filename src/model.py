# code partially from: https://github.com/fabiocarrara/visual-sentiment-analysis
import os
import sys
import json
import yaml

import torch
import numpy as np
from tqdm import tqdm
import torchvision.transforms as t
from torch.utils.data import Dataset, DataLoader
from torchvision.datasets.folder import default_loader

from vgg19 import KitModel as VGG19
from alexnet import KitModel as AlexNet

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
        if self.transform:
            x = self.transform(x)
        
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

        result = dict()

        data = ImageListDataset(message["file_list"], root=message["db_directory"], transform=self.transform)
        dataloader = DataLoader(data, batch_size=10, num_workers=8, pin_memory=True)
        with torch.no_grad():
            for e,x in enumerate(tqdm(dataloader)):
                p = self.model(x.to('cpu')).cpu().numpy().tolist()  # order is (NEG, NEU, POS)
                result[f"output{e}"] = p

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
