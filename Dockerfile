FROM continuumio/miniconda3

RUN conda install python
# RUN sudo apt-get upgrade && sudo apt-get update
# RUN sudo apt-get install make && sudo apt-get install gcc && sudo apt-get install build-essential

COPY . /worker
WORKDIR /worker

RUN ./deploy/deploy.sh

COPY ./app /app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]

#ENTRYPOINT uvicorn demo:app
