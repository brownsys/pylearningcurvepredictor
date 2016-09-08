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

# Compile caffe
cd caffe
cp Makefile.config.example Makefile.config

# Adjust Makefile.config (for example, if using Anaconda Python, or if cuDNN is desired)
sed -i 's/# CPU_ONLY := 1/CPU_ONLY := 1/g' Makefile.config

# prereq for pylearningcurvepredictor
sudo apt-get -y install gfortran python-tk

# install pycaffe dependencies
cd python
for req in $(cat requirements.txt); do sudo pip install $req; done

num_cores=`nproc`
make all -j${num_cores}
if [ $? != 0 ]; then echo "error: $?"; exit 1; fi
make test
if [ $? != 0 ]; then echo "error: $?"; exit 1; fi
make runtest
if [ $? != 0 ]; then echo "error: $?"; exit 1; fi
make pycaffe
if [ $? != 0 ]; then echo "error: $?"; exit 1; fi

export CAFFE_ROOT=/home/bs/caffe
export PYTHONPATH=${CAFFE_ROOT}/python:$PYTHONPATH
