#!/bin/bash
sudo apt-get update

# caffe: prereqs
sudo apt-get -y install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
sudo apt-get -y install --no-install-recommends libboost-all-dev

# caffe: blas
sudo apt-get -y install libatlas-base-dev

# caffe: pycaffe
sudo apt-get -y install python-dev

# caffe: ubuntu 14.4 prereqs
sudo apt-get -y install libgflags-dev libgoogle-glog-dev liblmdb-dev

# caffe: clone repo
git clone https://github.com/BVLC/caffe.git
cd caffe

# adjust Makefile.config to only use CPU and not GPU 
cp Makefile.config.example Makefile.config
sed -i 's/# CPU_ONLY := 1/CPU_ONLY := 1/g' Makefile.config

# install pycaffe dependencies
cd python
for req in $(cat requirements.txt); do sudo pip install $req; done
cd -

# prereq for pylearningcurvepredictor
sudo apt-get -y install gfortran python-tk

# make and test caffe and pycaffe
make all -j`nproc`
if [ $? != 0 ]; then echo "error: $?"; exit 1; fi
make test
if [ $? != 0 ]; then echo "error: $?"; exit 1; fi
make runtest
if [ $? != 0 ]; then echo "error: $?"; exit 1; fi
make pycaffe
if [ $? != 0 ]; then echo "error: $?"; exit 1; fi

export CAFFE_ROOT=`pwd`
export PYTHONPATH=${CAFFE_ROOT}/python:$PYTHONPATH
echo "Set global var PYTHONPATH=$PYTHONPATH"
