from typing import List
import json
import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.utils.log import setup_logger
from app.dependencies.Analysis import MakeRequest
from app.schema import *

setup_logger()
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s : %(message)s',
                    datefmt="%Y-%m-%d %H:%M:%S")
logger = logging.getLogger(__name__)

app = FastAPI()
make_request = MakeRequest()

app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])


@app.get("/health")
def health_check():
    return {"ok": True}


@app.post("/emotion-check", response_model=JobRequestResponse)
def emotion_check(
        request_body: JobRequestBody
):
    logger.info(f"Request info: {request_body} ")

    result = make_request.make_job(request_body.project_type,
                                   request_body.request_time,
                                   request_body.data)

    return JobRequestResponse(request_ids=result)
