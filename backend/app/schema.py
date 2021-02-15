from typing import List, Optional, Dict
from pydantic import BaseModel, Field


class InputData(BaseModel):
    data_type: str = Field(..., example="call, text, photo")
    create_date_time: str
    content: str


class JobRequest(BaseModel):
    project_type: str = Field(..., example="twitter, call")
    request_time: str
    data: List[InputData]


class Error:
    error_message: str

    def to_json(self) -> Dict:
        return {"error_message": self.error_message}


class ErrorBody(BaseModel):
    error_message: str

    @classmethod
    def from_error(cls, error: Error):
        return cls(error_message=error.error_message)

