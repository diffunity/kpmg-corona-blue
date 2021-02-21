import time
from typing import List, Dict, Optional
import logging
import json
import psycopg2.extras

from fastapi import Depends
import numpy as np

# for my local
# import sys
# sys.path.append("/Users/sieun/Desktop/kpmg-corona-blue/backend")
# # for container
from app.utils.config import CONFIG
from app.utils.db_connector import Connector
from app.utils.sqs import SQS
from app.schema import InputData, Error

import datetime as dt
from datetime import datetime
from collections import Counter

logger = logging.getLogger(__name__)


class Analysis:
    def __init__(self):
        self.db_conn = Connector()
        self.sqs = SQS()
        self.job_text_columns = CONFIG["Columns"]["job_text"]
        self.job_call_columns = CONFIG["Columns"]["job_call"]
        self.job_photo_columns = CONFIG["Columns"]["job_photo"]
        self.columns = CONFIG["Columns"]
        self.sqs_path = CONFIG["SQS"]["request"]

    def make_project(self, project_type: str, request_time: str) -> int:
        value_list = [project_type, request_time, 'REGISTERED']
        value = self.db_conn.values_query_formatter(value_list)
        query = self.db_conn.insert_query("project", self.columns["project"], value)
        project_id = self.db_conn.execute_query(query).fetchall()[0][0]

        logger.info(f"New Project Registered. {type}, id: {project_id}")
        return project_id

    def make_job(self, project_id: int, project_type: str, request_time: str, data: InputData) -> Optional[int]:
        """ user의 요청내용을 분석하고 기록한 뒤 자료형에 맞게 sqs 메시지를 보낸다. """
        d = dict(data)
        try:
            value_list = [project_id, request_time, d["create_date_time"], project_type, "REGISTERED", d["content"]]
            values = self.db_conn.values_query_formatter(value_list)
            query = self.db_conn.insert_query(f"job_{d['type']}", self.columns[f"job_{d['type']}"], values)

            request_id = self.db_conn.execute_query(query).fetchall()[0][0]
            self.sqs.send_message(self.sqs_path[d["type"]], request_id)
            logger.info(f"New request is registered: {d['type']}, project_id: {project_id}, job_id: {request_id}")

        except Exception as e:
            logger.error(e)
            return None

        self.db_conn.execute_query(self.db_conn.update_status_query("project", project_id, "PROCESSING"))

        return request_id

    def wait_project_done(self, project_id: int):
        wait_time = 60
        while wait_time > 0:
            status = self.db_conn.get_project_status("project", project_id)
            if status == 'DONE':
                return 'DONE'
            else:
                wait_time -= 1
                time.sleep(1)

        return 'FAILED'

    def get_project_status(self, project_id):
        status = self.db_conn.get_project_status("project", project_id)

        return status

    def get_text_result(self, project_id):
        query = f"""SELECT 5,6,7,8,9 from result_text WHERE project_id = {project_id}"""
        curr = self.db_conn.execute_query(query)
        data = dict(curr.fetchall()[0])

        return data

    def get_photo_result(self, project_id):
        query = f"""SELECT 5,6,7,8 FROM result_photo WHERE project_id = {project_id}"""
        curr = self.db_conn.execute_query(query)
        data = dict(curr.fetchall()[0])

        return data

    def get_call_result(self, project_id):
        query = f"""SELECT 5,6,7,8,9 from result_text WHERE project_id = {project_id}"""
        curr = self.db_conn.execute_query(query)
        text_data = dict(curr.fetchall()[0])
        query = f"""SELECT 5,6,7,8 FROM result_call WHERE project_id = {project_id}"""
        curr = self.db_conn.execute_query(query)
        audio_data = dict(curr.fetchall()[0])

        return [text_data, audio_data]


    def get_update_result(self):

        now = datetime.now()

        text_results = {"text_days": [],
                        "text_values": [],
                        "text_emotions":[],
                        "text_emotion_values":[],
                        "text_count":[]}

        voice_results = {"voice_content_days": [],
                         "voice_content_values": [],
                         "voice_content_emotions": [],
                         "voice_content_emotion_values": [],
                         "voice_content_count": []}

        voice_tone_results = {"voice_tone_days": [],
                              "voice_tone_values": [],
                              "voice_tone_count": []}

        photo_results = {"photo_days":[],
                         "photo_values":[],
                         "photo_count":[]}

        photo_facial_results = {"photo_facial_url":[],
                                "photo_facial_result":[]}

        photo_nonfacial_results = {"photo_nonfacial_url": [],
                                   "photo_nonfacial_result":[]}

        cumulated_text_emotion_values = Counter([])
        cumulated_voice_content_emotion_values = Counter([])
        cumulated_voice_tone_contents = Counter([])

        for i in range(7):
            if i == 0:
                tomorrow = now.replace(hour=0, minute=0, second=0, microsecond=0)
            else:
                tomorrow -= dt.timedelta(days=1)

            text_results["text_days"].append(tomorrow.strftime("%m/%d"))
            voice_results["voice_content_days"].append(tomorrow.strftime("%m/%d"))
            voice_tone_results["voice_tone_days"].append(tomorrow.strftime("%m/%d"))
            photo_results["photo_days"].append(tomorrow.strftime("%m/%d"))
            
            ############
            # text
            query = f"""SELECT model_result, word_count, sentence_count, create_data_time FROM result_text WHERE '{tomorrow}' <= create_date_time < '{now}' and type="text";"""
            curr = self.db_conn.execute_query(query)

            # results_today = list(filter(curr, key=lambda x: tomorrow < x[-1] <= now))
            results_today = curr
            labels = [x[0]["labels"] for x in results_today]

            sentence_counts = sum([x[2] for x in results_today])

            text_results["text_values"].append(self.convert_7to2(labels))
            text_results["text_count"].append(sentence_counts)
            cumulated_text_emotion_values += Counter(labels)

            ############
            # voice content
            query = f"""SELECT model_result, sentence_count, create_data_time FROM result_text WHERE '{tomorrow}' <= create_date_time < '{now}' and type="call"; """
            curr = self.db_conn.execute_query(query)

            # results_today = list(filter(curr, key=lambda x: tomorrow < x[-1] <= now))
            results_today = curr
            labels = [x[0]["labels"] for x in results_today]

            sentence_counts = sum([x[1] for x in results_today])

            voice_results["voice_content_values"].append(self.convert_7to2(labels))
            voice_results["voice_content_count"].append(sentence_counts)
            cumulated_voice_content_emotion_values += Counter(labels)


            ############
            # voice tone
            query = f"""SELECT model_result, create_data_time FROM result_call WHERE '{tomorrow}' <= create_date_time < '{now}'; """

            curr = self.db_conn.execute_query(query)

            results_today = curr
            labels = [x[0] for x in results_today]

            cumulated_voice_tone_contents += Counter(labels)
            N = sum(labels.values())
            voice_tone_results["voice_tone_values"].append(
                (labels["Non-depressed"]) / N
            )
            voice_tone_results["voice_tone_count"].append(N)

            ############
            # photo 
            query = f"""SELECT r.model_result, r.face, r.create_data_time, j.img_url
                        FROM result_photo r, job_photo j 
                        JOIN ON r.job_id=j.id
                        WHERE {tomorrow} <= r.create_date_time < {now} ; """
            curr = self.db_conn.execute_query(query)

            photo_negative = photo_positive = 0

            # facial photos
            facial_photos = list(filter(curr, key=lambda x: x[1]))
            for facial_photo in facial_photos:
                photo_facial_results["photo_facial_url"].append(facial_photo[-1])
                photo_facial_results["photo_facial_result"].append({
                    "label": facial_photo[0]["emotions"],
                    "valence": facial_photo[0]["affects"][0],
                    "arousal": facial_photo[0]["affects"][1]
                })
            

            # daily tally of caramels
            photo_positive, photo_negative = self.convert_FERto2(facial_photos)


            # nonfacial photos
            nonfacial_photos = list(filter(curr, key=lambda x: x[0]["method"]=="VSA"))
            for nonfacial_photo in nonfacial_photos:
                photo_nonfacial_results["photo_nonfacial_url"].append(nonfacial_photo[-1])
                photo_nonfacial_results["photo_nonfacial_result"].append({
                    "negative": nonfacial_photo[0][0][0],
                    "neutral": nonfacial_photo[0][0][1],
                    "positive": nonfacial_photo[0][0][2]
                })

            # daily tally of caramels
            VSAresults = self.convert_VSAto2(nonfacial_photos)
            photo_positive += VSAresults[0]
            photo_negative += VSAresults[1]
            N = (photo_negative+photo_positive)
            photo_results["photo_values"].append(photo_positive/N)
            photo_results["photo_count"].append(N)

            now = tomorrow

        # top emotions by each week
        text_emotion_values_count = sum(cumulated_text_emotion_values.values())
        for key, value in cumulated_text_emotion_values.items():
            text_results["text_emotions"].append(key)
            text_results["text_emotion_values"].append(value / text_emotion_values_count)

        voice_content_emotion_values_count = sum(cumulated_voice_content_emotion_values.values())
        for key, value in cumulated_voice_content_emotion_values.items():
            voice_results["voice_content_emotions"].append(key)
            voice_results["voice_content_emotion_values"].append(value / voice_content_emotion_values_count)


        final_output = dict()
        final_output.update(text_results)
        final_output.update(voice_results)
        final_output.update(voice_tone_results)
        final_output.update(photo_results)
        final_output.update(photo_facial_results)
        final_output.update(photo_nonfacial_results)

        return final_output

    def convert_7to2(self, emotions):
        positive = ["anger", "disgust","fear", "sadness"]
        negaitve = ["joy", "surprise", "neutral"]
        n = len(emotions)
        neg_val = pos_val = 0
        for i in emotions:
            if i in positive:
                pos_val += 1
            else:
                neg_val += 1

        return (pos_val) / (pos_val+neg_val)
        
    def convert_VSAto2(self, emotions):
        neg_val = pos_val = 0
        for emotion in emotions:
            if np.argmax(emotion[0]) == 0:
                neg_val += 1
            else:
                pos_val += 1
        return pos_val, neg_val

    def convert_FERto2(self, emotions):
        positive = ["Happiness", "Contempt", "Neutral", "Surprise"]
        negative = ["Anger", "Disgust", "Fear", "Sadness"]
        neg_val = pos_val = 0
        for emotion in emotions:
            if emotion["emotions"] in positive:
                pos_val += 1
            else:
                neg_val += 1
        
        return pos_val, neg_val

if __name__ == '__main__':
    r = Analysis()
    projectid = r.make_project('test', time.strftime('%Y-%m-%d %H:%M:%S'))
    r.make_job(projectid, 'test', time.strftime('%Y-%m-%d %H:%M:%S'), {"create_date_time": time.strftime('%Y-%m-%d %H:%M:%S'), "content": "test data", "type": "call"})
    print(r.wait_project_done(projectid))