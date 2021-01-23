FROM continuumio/miniconda3
  
COPY ./app /app

COPY . /worker
WORKDIR /worker

RUN pip install --upgrade pip
RUN pip install fastapi uvicorn pipreqs PyYAML

RUN bash ./deploy/deploy.sh

EXPOSE 80

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
