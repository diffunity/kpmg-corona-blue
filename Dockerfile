FROM python:3.8.3

COPY . /worker
WORKDIR /worker

RUN pip install --upgrade pip

RUN pip install -r ./conf/requirements.txt

RUN echo "export PYTHONPATH=/worker:${PYTHONPATH}" >> ~/.profile

CMD ["python3", "./src/model.py"]
