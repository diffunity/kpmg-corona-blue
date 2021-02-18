FROM python:3.7.5-alpine3.10

ENV LANG C.UTF-8

RUN apk update && \
    apk add --no-cache bash postgresql-dev postgresql-client build-base gcc linux-headers libffi-dev \
    jq curl-dev openssl-dev

WORKDIR /home
COPY . .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
CMD ["gunicorn", "-w", "1", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8000", "main:app"]