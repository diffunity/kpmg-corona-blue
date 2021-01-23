if [$1 == ""] || [$2 == ""]
then
  echo "insert first argument for image name and second argument for container name"
else
  # export current conda settings
  conda env export > ./deploy/environment.yml
  echo "conda environment exported"

  # run docker
  echo "buliding image (name: $1)"
  sudo docker build -t "$1" .
  echo "containerize image $1 (container name: $2)"
  sudo docker run -dp 80:80 "$2" "$1"
fi

