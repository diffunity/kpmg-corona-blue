apt-get upgrade && apt-get install update

apt-get install make
apt-get install gcc
apt-get install build-essential

# extract requirements used in the repository
pipreqs . --print >> ./deploy/requirements.txt

# export conda environment used in the repository and convert into yml
python3 ./deploy/configure.py
echo "configure.py successful"

# update conda env
conda env update -n base -f ./deploy/environment.yml
echo "conda env update successful"

pip install -r ./deploy/requirements.txt

echo "export PYTHONPATH=/worker:${PYTHONPATH}" >> ~/.profile
