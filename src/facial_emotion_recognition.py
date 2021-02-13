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

def video(input_video_path):
    """
    Receives the full path to a video file and recognizes
    facial expressions of the closets face in a frame-based approach.
    """

    display = False
    grad_cam = False
    output_csv_file = None ## review for what to save
    screen_size = 2
    device = torch.cuda.is_available()
    frames = 5
    branch = False
    no_plot = False

    fer_demo = None
    write_to_file = not (output_csv_file is None)

    if not uimage.initialize_video_capture(input_video_path):
        raise RuntimeError("Error on initializing video capture." +
                           "\nCheck whether working versions of ffmpeg or gstreamer is installed." +
                           "\nSupported file format: MPEG-4 (*.mp4).")

    uimage.set_fps(5)

    # Initialize screen
    if display:
        fer_demo = FERDemo(screen_size=screen_size,
                           display_individual_classification=branch,
                           display_graph_ensemble=(not no_plot))

    try:
        if write_to_file:
            ufile.create_file(output_csv_file, input_video_path)

        # Loop to process each frame from a VideoCapture object.
        while uimage.is_video_capture_open() and ((not display) or (display and fer_demo.is_running())):
            # Get a frame
            img, timestamp = uimage.get_frame()

            # Video has been processed
            if img is None:
                break
            else:  # Process frame
                fer = None if (img is None) else cvision.recognize_facial_expression(img,
                                                                                     device,
                                                                                     face_detection,
                                                                                     gradcam)

                # Display blank screen if no face is detected, otherwise,
                # display detected faces and perceived facial expression labels
                if display:
                    fer_demo.update(fer)
                    fer_demo.show()

                if write_to_file:
                    ufile.write_to_file(fer, timestamp)
