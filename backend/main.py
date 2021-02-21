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


@app.post("/emotion-check/image", response_model=JobRequestResponse)
def emotion_check_image(
        request_body: JobRequestBody
):
    logger.info(f"Request info: {request_body} ")
    registered_time = time.strftime('%Y-%m-%d %H:%M:%S')

    try:
        project_id = analysis.make_project("photo", registered_time)
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


@app.post("/emotion-check/stt-text", response_model=JobRequestResponse)
def emotion_check_text(
        request_body: STTRequestBody
):
    logger.info(f"STT Request info: {request_body} ")
    registered_time = time.strftime('%Y-%m-%d %H:%M:%S')

    try:
        request_id = analysis.make_job(request_body.project_id,
                                       "call",
                                       registered_time,
                                       request_body.data)

    except Exception as e:
        logger.error(e)
        raise HTTPException(
            status_code=400,
            detail=f"Making STT analysis request FAILED: {request_body}",
        )

    return JobRequestResponse(project_id=request_id)


@app.post("/emotion-check/status", response_model=StatusCheckResponse)
def get_status(request_body: StatusCheckRequest):
    status = analysis.get_project_status(request_body.project_id)
    return StatusCheckResponse(status=status)


@app.post("/emotion-result/text", response_model=ResultResponse)
def get_result(request_body: StatusCheckRequest):
    project_id = request_body.project_id
    result = analysis.get_text_result(project_id)

    return json.loads(result)


@app.post("/emotion-result/photo", response_model=ResultResponse)
def get_result(request_body: StatusCheckRequest):
    project_id = request_body.project_id
    result = analysis.get_photo_result(project_id)

    return json.loads(result)


@app.post("/emotion-result/call", response_model=ResultResponse)
def get_result(request_body: StatusCheckRequest):
    project_id = request_body.project_id
    result = analysis.get_call_result(project_id)
    text_result = result[0]
    audio_result = result[1]

    return json.loads({"text_analysis": text_result, "tone_analysis": audio_result})


# update
@app.get("/update/emotion-result/text")
def get_update_result(request_body: UpdateRequest):

    result = analysis.get_update_result()

    return result
