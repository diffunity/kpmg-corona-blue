FROM tensorflow/tensorflow:latest

#RUN apt-get upgrade -y
RUN apt-get update && \
	apt-get install -y gcc make apt-transport-https ca-certificates build-essential \
	alsa-utils ffmpeg libsndfile1

#RUN  conda install -c conda-forge pysoundfile
#RUN apk update && \
#    apk add --no-cache bash postgresql-dev postgresql-client build-base gcc linux-headers libffi-dev \
#    jq curl-dev openssl-dev

#RUN apk add --no-cache --update \
#    python3 python3-dev gcc \
#    gfortran musl-dev g++ \
#    libffi-dev openssl-dev \
#    libxml2 libxml2-dev \
#    libxslt libxslt-dev \
#    libjpeg-turbo-dev zlib-dev
COPY . /worker
WORKDIR /worker

RUN pip install --upgrade pip

RUN pip install -r ./conf/requirements.txt

#RUN echo "export PYTHONPATH=/worker:${PYTHONPATH}" >> ~/.profile

CMD ["python3", "./src/model.py"]
