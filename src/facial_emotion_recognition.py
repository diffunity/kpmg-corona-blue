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

def facial_emotion_recognition_image(input_image, path=False, output_csv_file=None):

    # FER for image (SNS)
    img = uimage.read(input_image) if path else input_image

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
