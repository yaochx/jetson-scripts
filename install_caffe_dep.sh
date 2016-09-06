#! /usr/bin/env sh
add-apt-repository universe
apt-get udpate
apt-get install cmake git aptitude screen g++ libboost-all-dev \
libgflags-dev libgoogle-glog-dev protobuf-compiler libprotobuf-dev \
bc libblas-dev libatlas-dev libhdf5-dev libleveldb-dev liblmdb-dev \
libsnappy-dev libatlas-base-dev python-numpy libgflags-dev \
libgoogle-glog-dev python-skimage python-protobuf python-pandas
