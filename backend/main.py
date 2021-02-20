from typing import List
import json
import time
import logging

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.utils.log import setup_logger
from app.dependencies.Analysis import Analysis

from app.schema import *

setup_logger()
logger = logging.getLogger(__name__)

app = FastAPI()
analysis = Analysis()

app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])


@app.get("/health")
def health_check():
    return {"ok": True}


@app.post("/emotion-check/text", response_model=JobRequestResponse)
def emotion_check_text(
        request_body: JobRequestBody
):
    logger.info(f"Request info: {request_body} ")
    registered_time = time.strftime('%Y-%m-%d %H:%M:%S')

    try:
        project_id = analysis.make_project("text", registered_time)
        request_id = analysis.make_job(project_id,
                                       request_body.project_type,
                                       registered_time,
                                       request_body.data)

    except Exception as e:
        logger.error(e)
        raise HTTPException(
            status_code=400,
            detail=f"Making text analysis request FAILED: {request_body}",
        )

    return JobRequestResponse(project_id=project_id)


@app.post("/emotion-check/call", response_model=JobRequestResponse)
def emotion_check_audio(
        request_body: JobRequestBody
):
    logger.info(f"Request info: {request_body} ")
    registered_time = time.strftime('%Y-%m-%d %H:%M:%S')
    try:
        project_id = analysis.make_project("call", registered_time)
        request_id = analysis.make_job(project_id,
                                       request_body.project_type,
                                       registered_time,
                                       request_body.data)

    except Exception as e:
        logger.error(e)
        raise HTTPException(
            status_code=400,
            detail=f"Making text analysis request FAILED: {request_body}",
        )

    return JobRequestResponse(project_id=project_id)


