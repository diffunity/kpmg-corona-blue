apt-get upgrade && sudo apt-get install update

apt-get install make
apt-get install gcc
apt-get install build-essential

pip install pipreqs PyYAML
pip install --upgrade pip

# extract requirements used in the repository
pipreqs . --print >> ./deploy/requirements.txt

# export conda environment used in the repository and convert into yml
python3 ./deploy/configure.py

# update conda env
conda env update -n base -f ./deploy/environment.yml

# uvicorn for fastAPI 
pip install uvicorn
