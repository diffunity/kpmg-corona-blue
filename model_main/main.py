import logging

from utils.config import CONFIG
from utils.db_connector import Connector
from utils.sqs import SQS
from model_audio.src.model import model

# Getting SQS Message

sqs = SQS()
conn = Connector()
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s : %(message)s',
                    datefmt="%Y-%m-%d %H:%M:%S")
logger = logging.getLogger(__name__)

while True:
    response = SQS.receive_message(CONFIG["SQS"]["request"]["call"])
    if response is not None:
        request_id = response['Body']
        query = conn.get_data_query("job_call", request_id)
        cur = conn.execute_query(query)

        try:
            data_info = dict(cur.fetchall()[0])
            data = data_info["data"]

            # TODO: data는 db에서 받아올 request data, model에 들어갈 형식으로 맞춰주세요.
            analysis_result = model.inference(data)

            message = dict()
            message["input"] = data

            # inference for audio 
            audio_result = model.inference(message)

            # inference for nlp
            nlp_result = model.inference(message)
        
            # inference for vision task
            vision_result = model.inference(message)

        except IndexError:
            logger.error(f"No id {request_id} in job_call table")
            continue

        #TODO: 분석 결과 sqs, db에 넣기
