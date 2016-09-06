#! /usr/bin/env sh
# root permission required
if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   exit
fi
# tool chain setup
add-apt-repository universe
apt-get update
apt-get install cmake git aptitude screen g++ libboost-all-dev \
libgflags-dev libgoogle-glog-dev protobuf-compiler libprotobuf-dev \
bc libblas-dev libatlas-dev libhdf5-dev libleveldb-dev liblmdb-dev \
libsnappy-dev libatlas-base-dev python-numpy libgflags-dev \
libgoogle-glog-dev python-skimage python-protobuf python-pandas
if [ -z `pkg-config --modversion opencv` ]; then
  echo "opencv already existed"
  apt-get install libopencv-dev
fi
# git clone caffe
if [ $# = 2 ]; then
  git clone https://github.com/NVIDIA/caffe.git -b experimental/fp16 $1
  cd $1
else
  echo "git clone to current dir" 
  git clone https://github.com/NVIDIA/caffe.git -b experimental/fp16
fi
# modify Makefile.config of caffe
mv Makefile.config.sample Makefile.config
sed -i -e "s/# USE_CUDNN := 1/USE_CUDNN := 1" Makefile.config
sed -i -e "s/# NATIVE_FP16 := 1/NATIVE_FP16 := 1" Makefile.config
sed -i -e "s/-gencode arch=compute_50,code=compute_50/-gencode arch=compute_53,code=sm_53 -gencode arch=compute_53,code=compute_53" Makefile.config

