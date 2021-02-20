#!/bin/bash

# unittest
echo -e "Begin unittest... \n"
python3 ./src/test.py

# deployment
echo -e "Unittest finished \n"
echo "========================================================="
echo -e "Begin deployment... \n"

# export requirements
pip install --upgrade pip
pipreqs . --print > ./conf/requirements.txt
python3 conf/pipreqs_bugfix.py

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
echo -e "Pushing to git \n"
git add .
git commit -m "!pushed for deployment!"
git push
echo "!!!!!!!!!!!!!!!!!!!"
echo "!!!pushed to git!!!"
echo "!!!!!!!!!!!!!!!!!!!"
echo -e "   Commit message: pushed for deployment\n"
echo "========================================================="

echo -e "Building Dockerfile \n"
echo "** Note: If you are deploying this on your local computer, you may ignore the messages below"
echo -e "**       The below process is for the purposes of actual deployment \n"

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

echo -e "\n!Successfully Deployed!\n"
echo "========================================================="
