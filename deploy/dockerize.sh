# export current conda settings
conda env export > ./deploy/environment.yml

# run docker
sudo docker build . -t example
sudo docker run example
