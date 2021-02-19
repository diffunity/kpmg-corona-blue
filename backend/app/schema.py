from typing import List, Optional, Dict
from enum import Enum
from pydantic import BaseModel, Field


class TypeEnum(str, Enum):
    call = 'call'
    text = 'text'
    photo = 'photo'


class InputData(BaseModel):
    data_type: TypeEnum = TypeEnum.text
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


print(InputData(data_type='call', create_date_time='now', content='test'))
print(InputData(data_type='other', create_date_time='now', content='test'))
