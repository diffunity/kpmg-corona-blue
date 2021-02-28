from preprocess import *

import os
import json
import yaml
import gdown
import requests

import pandas as pd
import numpy as np
import logging
import time

import librosa
from sklearn.preprocessing import StandardScaler, OneHotEncoder
import keras
from sklearn.model_selection import train_test_split

from pydub import AudioSegment, effects

import boto3
from google.oauth2 import service_account

from utils.config import CONFIG
from utils.db_connector import Connector
from utils.sqs import SQS
sqs = SQS()
conn = Connector()
logger = logging.getLogger(__name__)

import warnings
warnings.filterwarnings(action='ignore')

s3 = boto3.client("s3")
s3.download_file("kpmg-ybigta-image", "features.csv", "features.csv")

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
        self.columns = CONFIG["Columns"]

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
        logger.info(f"request input data: ", message)
        decoded_audio = decode_audio(message["input"])

        save_audio(decoded_audio, "sample.wav")
        logger.info("save_audio DONE.")

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

                Y = np.array(["Depressed", "Non-depressed"], dtype=object)
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
        logger.info(f"model_output of inference: ", model_output)

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
        logger.info(f"model_output of stt_model: ", model_output)

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
            response = SQS.receive_message(CONFIG["SQS"]["request"]["call"])
            if response is not None:
                project_id = response['Body']
                logger.info(f"Analysing {project_id} starting...")
                query = conn.get_data_query("job_call", project_id)
                cur = conn.execute_query(query)

                try:
                    data_info = dict(cur.fetchall()[0])
                    data = data_info["data"]

                    message = dict()
                    message["input"] = data
                    audio_result = model.inference(message)
                    logger.info(f"Executing {project_id} Done: {audio_result}")

                    project_id = data_info["project_id"]
                    job_id = data_info["id"]
                    result_time = time.strftime("%Y-%m-%d %H:%M:%S")
                    create_date_time = str(data_info["create_date_time"])
                    type = data_info["type"]
                    model_result = audio_result["output"]

                    api_endpoint = "http://ec2co-ecsel-f2k8u3ar7ixb-1602496836.ap-northeast-2.elb.amazonaws.com:8000/emotion-check/stt-text"
                    stt_text = audio_result["text"]["text"]
                    stt_request_body = {"project_id": project_id,
                                        "data": {"type": "text",
                                                 "create_date_time": create_date_time,
                                                 "content": stt_text}}
                    r = requests.post(api_endpoint, data=json.dumps(stt_request_body))
                    logger.info(f"Request for STT analysis done: {r.status_code}")

                    value_list = [project_id, job_id, result_time, create_date_time, type, model_result]
                    values = conn.values_query_formatter(value_list)
                    query = conn.insert_query("result_call", self.columns["result_call"], values)
                    conn.execute_query(query)
                    conn.execute_query(conn.update_status_query("job_call", job_id, "DONE"))

                    logger.info(f"Analysis for image Done. project_id: {project_id}")
                    sqs.delete_message(CONFIG["SQS"]["request"]["call"], response["ReceiptHandle"])
                    logger.info(f"Sqs message for request_id {project_id} is deleted.")

                except IndexError:
                    logger.error(f"No id {project_id} in job_call table")
                    continue




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
