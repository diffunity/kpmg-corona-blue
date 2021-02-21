# code partially from: https://github.com/siqueira-hc/Efficient-Facial-Feature-Learning-with-Wide-Ensemble-based-Convolutional-Neural-Networks
import json
import cvision
import torch
import requests
from fer_model.utils import uimage, ufile


import os
import torch
import numpy as np
from tqdm import tqdm
from PIL import Image, ImageOps
import face_recognition
import torchvision.transforms as t
from torch.utils.data import Dataset, DataLoader
from torchvision.datasets.folder import default_loader

def facial_emotion_recognition_video(input_video_path, user_image_path):
    """
    Receives the full path to a video file and recognizes
    facial expressions of the closets face in a frame-based approach.
    """

    display = False
    gradcam = False
    output_csv_file = None ## review for what to save
    screen_size = 2
    device = torch.cuda.is_available()
    frames = 1
    branch = False
    no_plot = False
    face_detection = 1

    fname = input_video_path.split(".")[0]+"_result.json"
    saved_results = {"video_path": input_video_path}
    json.dump(saved_results, open(fname, "w"))

    # user image encoding
    user_image = Image.open(requests.get(user_image_path, stream=True).raw)
    user_image = ImageOps.exif_transpose(user_image)
    user_image_enc = face_recognition.face_encodings(np.array(user_image))[0]

    fer_demo = None
    write_to_file = not (output_csv_file is None)

    cumulated_fer = []
    result = dict()
    if not uimage.initialize_video_capture(input_video_path):
        raise RuntimeError("Error on initializing video capture." +
                           "\nCheck whether working versions of ffmpeg or gstreamer is installed." +
                           "\nSupported file format: MPEG-4 (*.mp4).")

    uimage.set_fps(frames)

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
                                                                                     gradcam,
                                                                                     user_image_enc)
 
                
                # save images
                if fer.list_emotion is not None:
                    Image.fromarray(fer.face_image).save(f"./face_results/frame_{timestamp}.jpg","JPEG")
                    saved_results = json.load(open(fname, "r"))
                    result[f"output_{timestamp}"] = {"results": {"emotions": fer.list_emotion[-1], "affects": fer.list_affect.tolist()[-1]},
                                                     "method": "FER"}
                    saved_results.update(result)
                    print(saved_results)
                    json.dump(saved_results, open(fname, "w"))
                    print(f"Result dumped in JSON in {fname}")

                # Display blank screen if no face is detected, otherwise,
                # display detected faces and perceived facial expression labels

                if write_to_file:
                    ufile.write_to_file(fer, timestamp)

    except Exception as e:
        print("Error raised during video mode.")
        raise e
    finally:
        uimage.release_video_capture()

        if display:
            fer_demo.quit()

        if write_to_file:
            ufile.close_file()

    return result
