#! /usr/bin/env sh
if [ $# != 1 ]; then
   echo "usage: ./install_caffe_dep.sh dir"
fi
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
if [ -n $1 ]; then
  if [ ! -d "$1/caffe" ]; then
    echo "git clone to $1/caffe dir" 
    mkdir -p "$1/caffe"
    su - ubuntu -c git clone https://github.com/NVIDIA/caffe.git -b experimental/fp16 "$1/caffe"
  fi
  if [ ! -d "$1/cub" ]; then
    echo "git clone to $1/cub dir" 
    mkdir -p "$1/cub"
    su - ubuntu -c git clone https://github.com/NVlabs/cub.git "$1/cub"
  fi
  cd "$1/caffe"
else
  echo "git clone to current dir" 
  su - ubuntu -c git clone https://github.com/NVIDIA/caffe.git -b experimental/fp16
  su - ubuntu -c git clone https://github.com/NVlabs/cub.git
  cd "caffe"
fi
# modify Makefile.config of caffe
cp Makefile.config.example Makefile.config
sed -i -e "s/# USE_CUDNN := 1/USE_CUDNN := 1/" Makefile.config
sed -i -e "s/# NATIVE_FP16 := 1/NATIVE_FP16 := 1/" Makefile.config
sed -i -e "s/-gencode arch=compute_50,code=compute_50/-gencode arch=compute_53,code=sm_53 -gencode arch=compute_53,code=compute_53/" Makefile.config

