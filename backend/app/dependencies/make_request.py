from time import sleep
from typing import List, Dict
import logging
import json
import psycopg2.extras

from fastapi import Depends

from app.utils.config import CONFIG
from app.utils.db_connector import Connector
from app.schema import *

logger = logging.getLogger(__name__)


class MakeRequest:
    def __init__(self):
        self.db_conn = Connector()
        self.job_text_columns = CONFIG["Columns"]["job_text"]
        self.job_call_columns = CONFIG["Columns"]["job_call"]
        self.job_photo_columns = CONFIG["Columns"]["job_photo"]
        self.sqs_path = CONFIG["SQS"]["request"]

    def make_job(self, project_type: str, request_time: str, data: List[Dict]) -> List[int]:
        """ user의 요청내용을 분석하고 기록한 뒤 자료형에 맞게 sqs 메시지를 보낸다. """
        request_ids = []
        for d in data:
            value_list = [request_time, d["create_date_time"], project_type, "REGISTERED", d["content"]]
            values = self.db_conn.values_query_formatter(value_list)

            if d["type"] == "text":
                query = self.db_conn.insert_query(f"job_text", self.job_text_columns, values)
            elif d["type"] == "call":
                query = self.db_conn.insert_query("job_call", self.job_text_columns, values)
            elif d["type"] == "photo":
                query = self.db_conn.insert_query("job_photo", self.job_text_columns, values)

            request_id = self.db_conn.execute_query(query).fetchall()[0][0]
            request_ids.append(request_id)
            self.send_to_sqs(d["type"], request_id)

        logger.info(f"New request is registered: {request_ids}, {request_time}, {len(data)} inputs")

        return request_ids

    def send_to_sqs(self, input_type: str, value: str):
        """send created project_id and job_id to text/photo/voice SQS """
        if input_type in ["text", "call", "photo"]:
            sqs_url = self.sqs_path[input_type]
        else:
            return None

        #TODO: send sqs message to sqs_url
        logger.info(f"New project is inserted to {input_type} sqs: {value}")
        return 0
