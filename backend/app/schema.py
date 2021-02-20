from typing import List, Optional, Dict
from enum import Enum
from pydantic import BaseModel, Field


class TypeEnum(str, Enum):
    call = 'call'
    text = 'text'
    photo = 'photo'


class InputData(BaseModel):
    type: TypeEnum = TypeEnum.text
    create_date_time: str
    content: str


class JobRequestBody(BaseModel):
    project_type: str = Field(..., example="twitter, call")
    request_time: str
    data: List[InputData]


class JobRequestResponse(BaseModel):
    request_ids: List[int]


class Error:
    error_message: str

    def to_json(self) -> Dict:
        return {"error_message": self.error_message}


class ErrorBody(BaseModel):
    error_message: str

    @classmethod
    def from_error(cls, error: Error):
        return cls(error_message=error.error_message)


