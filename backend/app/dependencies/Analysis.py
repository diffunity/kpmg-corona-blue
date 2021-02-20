import time
from typing import List, Dict, Optional
import logging
import json
import psycopg2.extras

from fastapi import Depends

# for my local
# import sys
# sys.path.append("/Users/sieun/Desktop/kpmg-corona-blue/backend")
# # for container
from app.utils.config import CONFIG
from app.utils.db_connector import Connector
from app.utils.sqs import SQS
from app.schema import InputData, Error


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


if __name__ == '__main__':
    r = Analysis()
    projectid = r.make_project('test', time.strftime('%Y-%m-%d %H:%M:%S'))
    r.make_job(projectid, 'test', time.strftime('%Y-%m-%d %H:%M:%S'), {"create_date_time": time.strftime('%Y-%m-%d %H:%M:%S'), "content": "test data", "type": "call"})
    print(r.wait_project_done(projectid))