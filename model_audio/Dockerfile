FROM python:3.8.6-alpine

RUN apk update && \
    apk add --no-cache bash postgresql-dev postgresql-client build-base gcc linux-headers libffi-dev \
    jq curl-dev openssl-dev

COPY . /worker
WORKDIR /worker

RUN pip install --upgrade pip

RUN pip install -r ./conf/requirements.txt

RUN echo "export PYTHONPATH=/worker:${PYTHONPATH}" >> ~/.profile

CMD ["python3", "./src/model.py"]
