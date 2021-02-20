import time
from typing import List, Dict
import logging
import json
import psycopg2.extras

from fastapi import Depends

# from config import CONFIG
# from db_connector import Connector
# from sqs import SQS
# for my local
import sys
sys.path.append("/Users/sieun/Desktop/kpmg-corona-blue")
from backend.app.utils.config import CONFIG
from backend.app.utils.db_connector import Connector
from backend.app.utils.sqs import SQS
from backend.app.schema import InputData


logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s : %(message)s',
                    datefmt="%Y-%m-%d %H:%M:%S")
logger = logging.getLogger(__name__)


class MakeRequest:
    def __init__(self):
        self.db_conn = Connector()
        self.sqs = SQS()
        self.job_text_columns = CONFIG["Columns"]["job_text"]
        self.job_call_columns = CONFIG["Columns"]["job_call"]
        self.job_photo_columns = CONFIG["Columns"]["job_photo"]
        self.columns = CONFIG["Columns"]
        self.sqs_path = CONFIG["SQS"]["request"]

    def make_job(self, project_type: str, request_time: str, data: List[InputData]) -> List[int]:
        """ user의 요청내용을 분석하고 기록한 뒤 자료형에 맞게 sqs 메시지를 보낸다. """
        request_ids = []
        for d in data:
            d = dict(d)
            try:
                value_list = [request_time, d["create_date_time"], project_type, "REGISTERED", d["content"]]
                values = self.db_conn.values_query_formatter(value_list)
                query = self.db_conn.insert_query(f"job_{d['type']}", self.columns[f"job_{d['type']}"], values)

                request_id = self.db_conn.execute_query(query).fetchall()[0][0]
                request_ids.append(request_id)
                self.sqs.send_message(self.sqs_path[d["type"]], request_id)

            except Exception as e:
                logger.error(e)

        logger.info(f"New request is registered: {request_ids}, {len(data)} inputs")

        return request_ids


if __name__ == '__main__':
    r = MakeRequest()
    r.make_job('test', time.strftime('%Y-%m-%d %H:%M:%S'), [{"create_date_time": time.strftime('%Y-%m-%d %H:%M:%S'), "content": "test data", "type": "call"}])
