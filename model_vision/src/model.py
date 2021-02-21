# code partially from: https://github.com/fabiocarrara/visual-sentiment-analysis
# code partially from: https://github.com/siqueira-hc/Efficient-Facial-Feature-Learning-with-Wide-Ensemble-based-Convolutional-Neural-Networks
import os
import sys
import json
import yaml
import logging
import requests
import logging
import time

import torch
import numpy as np
from tqdm import tqdm
import face_recognition
from PIL import Image, ImageOps, UnidentifiedImageError
import torchvision.transforms as t
from torch.utils.data import Dataset, DataLoader
from torchvision.datasets.folder import default_loader
from facial_emotion_recognition import facial_emotion_recognition_image

from vgg19 import KitModel as VGG19
from alexnet import KitModel as AlexNet

from utils.config import CONFIG
from utils.db_connector import Connector
from utils.sqs import SQS

sqs = SQS()
conn = Connector()
logger = logging.getLogger(__name__)

user_image_URL = "https://kpmg-ybigta-image.s3.ap-northeast-2.amazonaws.com/user_image.jpg"

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

        self.columns = CONFIG["Columns"]

    def inference(self, message:json):

        result = dict()

        # user image encoding
        user_image = Image.open(requests.get(user_image_URL, stream=True).raw)
        user_image = ImageOps.exif_transpose(user_image)
        user_image_enc = face_recognition.face_encodings(np.array(user_image))[0]

        # for individual files from url
        x = Image.open(requests.get(message["input"], stream=True).raw)
        with torch.no_grad():

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
                    Image.fromarray(fer_result.face_image).save(f"./face_results/output.jpg","JPEG")
                    result[f"output"] = {"results": {"emotions": fer_result.list_emotion, "affects": list(fer_result.list_affect)[-1]},
                                             "method": "FER"}
                    return result

                # inference for non-facial image (inferenced also when face was detected but no face matched user's face)
            x = self.transform(x).unsqueeze(0)
            p = self.model(x.to('cpu')).cpu().numpy().tolist()  # order is (NEG, NEU, POS)
            result[f"output"] = {"contents": p,
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
            response = SQS.receive_message(CONFIG["SQS"]["request"]["photo"])
            if response is not None:
                request_id = response['Body']
                logger.info(f"Analysing {request_id} starting...")
                query = conn.get_data_query("job_photo", request_id)
                cur = conn.execute_query(query)

                try:
                    data_info = dict(cur.fetchall()[0])
                    data = data_info["img_url"]

                    message = dict()
                    message["input"] = data
                    vision_result = model.inference(message)["output"]
                    logger.info(f"Executing {request_id} Done: {vision_result}")

                    project_id = data_info["project_id"]
                    job_id = data_info["id"]
                    result_time = time.strftime('%Y-%m-%d %H:%M:%S')
                    create_date_time = data_info["create_date_time"]

                    if vision_result["method"] == "FER":
                        face = 'true'
                        model_result = vision_result["results"]
                    else:
                        face = 'false'
                        model_result = vision_result["contents"]
                    value_list = [project_id, job_id, result_time, create_date_time, "photo", face, model_result]
                    values = conn.values_query_formatter(value_list)
                    query = conn.insert_query("result_photo", self.columns, values)
                    conn.execute_query(query)
                    conn.execute_query(conn.update_status_query("project", project_id, "DONE"))
                    logger.info(f"Analysis for image Done. project_id: {project_id}")

                except IndexError:
                    logger.error(f"No id {request_id} in job_photo table")
                    continue

                except UnidentifiedImageError:
                    logger.error(f"Invalid images!!! id: {request_id}")
                    conn.execute_query(conn.update_status_query("project", request_id, "FAILED"))

                sqs.delete_message(CONFIG["SQS"]["request"]["photo"], response["ReceiptHandle"])
                logger.info(f"Sqs message for request_id {request_id} is deleted.")

            else:
                time.sleep(1)
                continue


if __name__ == "__main__":
    model = model()
    model.run()
