#!/bin/bash

# unittest
echo "Begin unittest"
python3 ./src/test.py

# deployment
echo -e "Unittest finished"
echo "========================================================="
echo "Begin deployment"

# export requirements
pip install --upgrade pip
pipreqs . --print >> ./conf/requirements.txt

# export python version
pyver=$(python --version)
echo -e "Python version ${pyver} detected"
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

echo "========================================================="
echo "Pushing to git"
git add .
git commit -m "!pushed for deployment!"
git push
echo "!!!pushed to git!!!"
echo "   Commit message: pushed for deployment"
echo "========================================================="

echo "Building Dockerfile"
echo "** Note: If you are deploying this on your local computer, you may ignore the messages below"
echo "**       The below process is for the purposes of actual deployment"

# build and run dockerfile
if [ "${1}" == "" ]
then
  echo "ERROR: please give the image name as the first argument"
  echo "! exiting due to no given image name !"
  exit 1
else
  echo "building image ${1}"
  sudo docker build -t "${1}" .
  if [ "${2}" == "" ]
  then
    echo -e "NOTE: container name was not given.\nto give container name, pass it as the second argument" 
    sudo docker run "${1}"
  else
    echo "! containerizing image ${1} as ${2} !"
    sudo docker run --name "${2}" "${1}"
  fi
fi

echo "Successfully Deployed"
echo "========================================================="
