from preprocess import *

import os
import json
import yaml
import gdown
import requests

import pandas as pd
import numpy as np

import librosa
from sklearn.preprocessing import StandardScaler, OneHotEncoder
import keras
from sklearn.model_selection import train_test_split

from pydub import AudioSegment, effects

import boto3
from google.oauth2 import service_account

import warnings
warnings.filterwarnings(action='ignore')

url = 'https://drive.google.com/uc?id=1m2NDz9MBvKIh5E26i_4ke_tgPRd9ZmZc'
output = 'features.csv'
gdown.download(url, output, quiet=False)

r = requests.get("https://kpmg-ybigta-image.s3.ap-northeast-2.amazonaws.com/audio_config.json")
with open("audio_config.json", "w") as f:
    json.dump(r.json(), f)
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "audio_config.json"

class model:
    def __init__(self):

        # load model
        self.config = yaml.load(open("./conf/config.yml", "r"), Loader=yaml.SafeLoader)
        self.model = keras.models.load_model(self.config["model_settings"]["pretrained_filepath"])

        # train set scaling
        self.Features = pd.read_csv("./features.csv")
        self.X = self.Features.values

        self.X = self.Features.iloc[: ,:-1].values
        self.Y = self.Features['labels'].values

        self.x_train, self.x_test, self.y_train, self.y_test = train_test_split(self.X,
                                                                                self.Y,
                                                                                random_state=0,
                                                                                shuffle=True)

        self.scaler = StandardScaler()
        self.x_train = self.scaler.fit_transform(self.x_train)


    def inference(self, message:json):
        # temp directory
        os.makedirs('./chunk', exist_ok=True)
        os.makedirs("./stt_chunk", exist_ok=True)

        # mock data
#        message = dict()
#        message["audio_file"] = "sample.txt"

#        f = open('sample.txt', 'rb')
        # f = open(message["input"], 'rb')
        # encoded_string = f.read()  # bytes
        # f.close()

        decoded_audio = decode_audio(message["input"])

        save_audio(decoded_audio, "sample.wav")

        split_audio("sample.wav")

        for wav in os.listdir("./chunk"):
            normalize_audio("./chunk/" + wav)

        output_list = []
        for wav in os.listdir("./chunk"):
            try:
                feature_vector = []
                sample_rate = 16000
                feature = get_features("./chunk/" + wav)

                for ele in feature:
                    feature_vector.append(ele)

                feature_vector = np.array(feature_vector, dtype="object")[:1]
                feature_vector = self.scaler.transform(feature_vector)
                feature_vector = np.expand_dims(feature_vector, axis=2)

                Y = np.array(['Depressed', 'Non-depressed'], dtype=object)
                encoder = OneHotEncoder()
                Y = encoder.fit_transform(np.array(Y).reshape(-1, 1)).toarray()

                pred_test = self.model.predict(feature_vector)
                y_pred = encoder.inverse_transform(pred_test)

                output_list.append(y_pred[0][0])

            except:
                pass

        # depressed_rate = num_depressed/(num_depressed+num_non_depressed)

        model_output = dict()
        num_depressed = output_list.count('Depressed')
        num_non_depressed = output_list.count('Non-depressed')
        model_output["output"] = {"Depressed": num_depressed, "Non-depressed": num_non_depressed}

        ##############################################################
        # Speech to text
        ##############################################################
        split_by_30s("sample.wav")

        text_list = []
        for wav in os.listdir("./stt_chunk"):
            text_list.append(transcribe_file("./stt_chunk/" + wav))

        model_output["text"] = {"count": num_depressed+num_non_depressed, "text": " ".join(text_list)}

        shutil.rmtree("./chunk")
        shutil.rmtree("./stt_chunk")

        return model_output

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
