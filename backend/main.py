from typing import List
import json
import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.utils.log import setup_logger
from app.dependencies.make_request import MakeRequest
from app.schema import *

setup_logger()
logger = logging.getLogger(__name__)


app = FastAPI()

app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])


@app.get("/health")
def health_check():
    return {"ok": True}
