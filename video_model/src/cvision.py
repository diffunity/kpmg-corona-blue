#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
This module implements computer vision methods.
"""

__author__ = "Henrique Siqueira"
__email__ = "siqueira.hc@outlook.com"
__license__ = "MIT license"
__version__ = "1.0"

## further modified by team YBIGTA for KPMG competition

# External Libraries
import numpy as np
import torch
from torchvision import transforms
from PIL import Image
import cv2
import dlib

# Modules
from fer_model.ml.fer import FER
from fer_model.utils import uimage, udata
from fer_model.ml.esr_9 import ESR
from fer_model.ml.grad_cam import GradCAM

import face_recognition

# Haar cascade parameters
_HAAR_SCALE_FACTOR = 1.2
_HAAR_NEIGHBORS = 9
_HAAR_MIN_SIZE = (60, 60)

# Haar cascade parameters
_DLIB_SCALE_FACTOR_SMALL_IMAGES = [0.5, 1.0]
_DLIB_SCALE_FACTOR_LARGE_IMAGES = [0.2, 0.5]
_DLIB_SCALE_FACTOR_THRESHOLD = (500 * 500)

# Face detector methods
_ID_FACE_DETECTOR_DLIB = 1
_ID_FACE_DETECTOR_DLIB_STANDARD = 2
_FACE_DETECTOR_DLIB = None

_ID_FACE_DETECTOR_HAAR_CASCADE = 3
_FACE_DETECTOR_HAAR_CASCADE = None

# Facial expression recognition network: Ensemble with Shared Representations (ESR)
_ESR_9 = None

# Saliency map generation: Grad-CAM
_GRAD_CAM = None

# Public methods >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

def recognize_facial_expression(image, on_gpu, face_detection_method, grad_cam, user_image_enc):
    """
    Detects a face in the input image.
    If more than one face is detected, the biggest one is used.
    Afterwards, the detected face is fed to ESR-9 for facial expression recognition.
    The face detection phase relies on third-party methods and ESR-9 does not verify
    if a face is used as input or not (false-positive cases).

    :param on_gpu:
    :param image: (ndarray) input image.
    :return: An FER object with the components necessary for display.
    """

    to_return_fer = None
    saliency_maps = []

    # Detect face
    face_coordinates = face_recognition.face_locations(image)
    matched = False

    # if face_coordinates is None:
    if not face_coordinates:
        to_return_fer = FER(image)
    else:
        for face_coordinate in face_coordinates:
            face = image[face_coordinate[0]:face_coordinate[2], face_coordinate[3]:face_coordinate[1]]
            face_enc = face_recognition.face_encodings(face)
            if len(face_enc) > 0:
                if face_recognition.compare_faces([user_image_enc], face_enc[0])[0]:
                    matched = True
                    break

        if not matched:
            print("NOT MATCHED!")
            return FER(image)

        # Get device
        device = torch.device("cuda" if on_gpu else "cpu")

        # Pre_process detected face
        input_face = _pre_process_input_image(face)
        input_face = input_face.to(device)

        # Recognize facial expression
        # emotion_idx is needed to run Grad-CAM
        emotion, affect, emotion_idx = _predict(input_face, device)

        # Grad-CAM
        if grad_cam:
            saliency_maps = _generate_saliency_maps(input_face, emotion_idx, device)

        # Initialize GUI object
        to_return_fer = FER(image, face, face_coordinates, emotion, affect, saliency_maps)

    return to_return_fer

# Public methods <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


# Private methods >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

def _pre_process_input_image(image):
    """
    Pre-processes an image for ESR-9.

    :param image: (ndarray)
    :return: (ndarray) image
    """

    image = uimage.resize(image, ESR.INPUT_IMAGE_SIZE)
    image = Image.fromarray(image)
    image = transforms.Normalize(mean=ESR.INPUT_IMAGE_NORMALIZATION_MEAN,
                                 std=ESR.INPUT_IMAGE_NORMALIZATION_STD)(transforms.ToTensor()(image)).unsqueeze(0)

    return image


def _predict(input_face, device):
    """
    Facial expression recognition. Classifies the pre-processed input image with ESR-9.

    :param input_face: (ndarray) input image.
    :param device: runs the classification on CPU or GPU
    :return: Lists of emotions and affect values including the ensemble predictions based on plurality.
    """

    global _ESR_9

    if _ESR_9 is None:
        _ESR_9 = ESR(device)

    to_return_emotion = []
    to_return_emotion_idx = []
    to_return_affect = None

    # Recognizes facial expression
    emotion, affect = _ESR_9(input_face)

    # Computes ensemble prediction for affect
    # Converts from Tensor to ndarray
    affect = np.array([a[0].cpu().detach().numpy() for a in affect])

    # Normalizes arousal
    affect[:, 1] = np.clip((affect[:, 1] + 1)/2.0, 0, 1)

    # Computes mean arousal and valence as the ensemble prediction
    ensemble_affect = np.expand_dims(np.mean(affect, 0), axis=0)

    # Concatenates the ensemble prediction to the list of affect predictions
    to_return_affect = np.concatenate((affect, ensemble_affect), axis=0)

    # Computes ensemble prediction concerning emotion labels
    # Converts from Tensor to ndarray
    emotion = np.array([e[0].cpu().detach().numpy() for e in emotion])

    # Gets number of classes
    num_classes = emotion.shape[1]

    # Computes votes and add label to the list of emotions
    emotion_votes = np.zeros(num_classes)
    for e in emotion:
        e_idx = np.argmax(e)
        to_return_emotion_idx.append(e_idx)
        to_return_emotion.append(udata.AffectNetCategorical.get_class(e_idx))
        emotion_votes[e_idx] += 1

    # Concatenates the ensemble prediction to the list of emotion predictions
    to_return_emotion.append(udata.AffectNetCategorical.get_class(np.argmax(emotion_votes)))

    return to_return_emotion, to_return_affect, to_return_emotion_idx


def _generate_saliency_maps(input_face, emotion_outputs, device):
    """
    Generates saliency maps for every branch in the ensemble with Grad-CAM.

    :param input_face: (ndarray) input image.
    :param device: runs the classification on CPU or GPU
    :return: (ndarray) Saliency maps.
    """

    global _GRAD_CAM, _ESR_9

    if _GRAD_CAM is None:
        _GRAD_CAM = GradCAM(_ESR_9, device)

    # Generate saliency map
    return _GRAD_CAM.grad_cam(input_face, emotion_outputs)

# Private methods <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
