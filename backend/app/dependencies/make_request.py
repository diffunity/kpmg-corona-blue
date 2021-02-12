from time import sleep
from typing import List, Optional, Tuple
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
        self.db_con = Connector().conn()
        self.db_cur = self.db_con.cursor(cursor_factory=psycopg2.extras.DictCursor)

    def make_project(self, input_type: str, create_date_time: str, content: List[Dict]) -> int:
        """ user의 요청내용을 분석하고 기록한 뒤 자료형에 맞게 sqs 메시지를 보낸다. """
        project_id = 0
        logger.info(f"New request is registered: {project_id}, {create_date_time}, {input_type}, {content}")
        return project_id

    @staticmethod
    def insert_to_db(table, values):
        """ table에 values를 넣고 auto generated primary key를 return """
        return 0

    @staticmethod
    def send_to_sqs(input_type: str, value: str):
        """send created project_id and job_id to text/photo/voice SQS """
        logger.info(f"New project is inserted to {input_type} sqs: {value}")
        return 0
