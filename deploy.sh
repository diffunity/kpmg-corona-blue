#!/bin/bash

# unittest
echo "begin unittest"
python3 ./src/test.py

# deployment
echo -e "unittest finished\nbegin deployment"

# export requirements
pip install --upgrade pip
pipreqs . --print >> ./conf/requirements.txt

# export python version
pyver=$(python --version)
img="FROM python:${pyver:7:${#pyver}}"

# set dockerfile
dockerLines=$(cat Dockerfile)
if [[ "${dockerLines:0:17}" != "${img:0:17}" ]]
then 
  if [[ "${dockerLines:0:4}" == "FROM" ]]
  then
    echo -e "${img}\n${dockerLines:18:${#dockerLines}}" > Dockerfile
    echo "Python version updated in dockerfile"
  else
    echo -e "${img}\n${dockerLines}" > Dockerfile
    echo "Python version inserted in dockerfile"
  fi
fi

# build and run dockerfile
if [ "${1}" == "" ]
then
  echo "please give the image name as the first argument"
  echo "exiting due to no given image name"
  exit 1
else
  echo "building image ${1}"
  sudo docker build -t "${1}" .
  if [ "${2}" == "" ]
  then
    echo -e "container name was not given.\nto give container name, pass it as the second argument" 
    sudo docker run "${1}"
  else
    echo "containerizing image ${1} as ${2}"
    sudo docker run --name "${2}" "${1}"
  fi
fi
