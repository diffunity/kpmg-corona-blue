# code partially from: https://github.com/siqueira-hc/Efficient-Facial-Feature-Learning-with-Wide-Ensemble-based-Convolutional-Neural-Networks
import cvision
import torch
from fer_model.utils import uimage, ufile


import os
import torch
import numpy as np
from tqdm import tqdm
import face_recognition
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


def facial_emotion_recognition_image(input_image, path=False, output_csv_file=None):

    # FER for image (SNS)
    img = uimage.read(input_image) if path else input_image

    print(f"Looks like this: {img}")

    fer = cvision.recognize_facial_expression(image=img,
                                              on_gpu=torch.cuda.is_available(), 
                                              face_detection_method=1, 
                                              grad_cam=False)

    write_to_file = not (output_csv_file is None)

    if write_to_file:
        ufile.create_file(output_csv_file, input_image_path)
        ufile.write_to_file(fer, 0.0)
        ufile.close_file()
        return saved
    else:
        return fer



if __name__=="__main__":
    # fer = facial_emotion_recognition_image("../known_image.jpg", path=True)

    message = dict()

    message["db_directory"] = "../TestData"
    message["file_list"] = "../image_list.txt"
    message["user_image"] = "../known_image.jpg"    

    transform = t.Compose([
            t.Resize((224, 224)),
            t.ToTensor(),
            t.Lambda(lambda x: x[[2,1,0], ...] * 255),  # RGB -> BGR and [0,1] -> [0,255]
            t.Normalize(mean=[116.8007, 121.2751, 130.4602], std=[1,1,1]),  # mean subtraction
    ])

    data = ImageListDataset(message["file_list"], root=message["db_directory"], transform=transform)
    dataloader = DataLoader(data, batch_size=10, num_workers=8, pin_memory=True)

    for e,x in enumerate(tqdm(dataloader)):
        
    #     # image_enc = face_recognition.face_encodings(x)
    #     # model for facial emotion recognition
        print(f"Looks like this {x}")
        fer_result = facial_emotion_recognition_image(x, path=False)
        result[f"output{e}"] = fer_result

    print(f"FER result: {fer.__dict__}")