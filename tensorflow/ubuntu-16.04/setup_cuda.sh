#!/usr/bin/env bash
set -x
set -e
# cuda driver so: /usr/lib/x86_64-linux-gnu/libcuda.so.1

CUDA_PATH="/usr/local/cuda-$CUDA_VERSION"

# Setup Cuda URL
if [ "$CUDA_VERSION" = "9.0" ]; then
    CUDA_URL="https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run"
elif [ "$CUDA_VERSION" = "9.1" ]; then
    CUDA_URL="https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux"
elif [ "$CUDA_VERSION" = "9.2" ]; then
    CUDA_URL="https://developer.nvidia.com/compute/cuda/9.2/Prod/local_installers/cuda_9.2.88_396.26_linux"
else
    echo "Error: You need to set CUDA_VERSION to 9.0, 9.1 or 9.2."
    exit -1
fi

# Setup cuDNN URL
if [ "$CUDNN_VERSION" = "7.0" ]; then
    if [ "$CUDA_VERSION" = "9.0" ]; then
        CUDNN_VERSION_DETAILED="7.0.5.15"
    elif [ "$CUDA_VERSION" = "9.1" ]; then
        CUDNN_VERSION_DETAILED="7.0.5.15"
    elif [ "$CUDA_VERSION" = "9.2" ]; then
        echo "Error: CUDNN 7.0 is not compatible with CUDA 9.2."
        exit -1
    fi
elif [ "$CUDNN_VERSION" = "7.1" ]; then
    if [ "$CUDA_VERSION" = "9.0" ]; then
        CUDNN_VERSION_DETAILED="7.1.4.18"
    elif [ "$CUDA_VERSION" = "9.1" ]; then
        CUDNN_VERSION_DETAILED="7.1.3.16"
    elif [ "$CUDA_VERSION" = "9.2" ]; then
        CUDNN_VERSION_DETAILED="7.1.4.18"
    fi
else
    echo "Error: You need to set CUDNN_VERSION to 7.0 or 7.1."
    exit -1
fi
CUDNN_URL="https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7_${CUDNN_VERSION_DETAILED}-1+cuda${CUDA_VERSION}_amd64.deb"
CUDNN_URL_DEV="https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7-dev_${CUDNN_VERSION_DETAILED}-1+cuda${CUDA_VERSION}_amd64.deb"

# Install Cuda
wget -c $CUDA_URL -O "/download/$(basename $CUDA_URL)"
bash "/download/$(basename $CUDA_URL)" --silent --toolkit --override --toolkitpath $CUDA_PATH
ln -s $CUDA_PATH "$(dirname $CUDA_PATH)/cuda/"

# Install cuDNN .so files
wget -c $CUDNN_URL -O "/download/$(basename $CUDNN_URL)"
mkdir -p /download/cudnn
cd /download/cudnn
ar x ../$(basename $CUDNN_URL)
tar -xJf data.tar.xz
mv usr/lib/x86_64-linux-gnu/libcudnn* $CUDA_PATH/lib64/
rm -fr /download/cudnn
cd /

# Install cuDNN .h and static lib files
wget -c $CUDNN_URL_DEV -O "/download/$(basename $CUDNN_URL_DEV)"
mkdir -p /download/cudnn
cd /download/cudnn
ar x ../$(basename $CUDNN_URL_DEV)
tar -xJf data.tar.xz
mv usr/include/x86_64-linux-gnu/cudnn_v7.h $CUDA_PATH/include/cudnn.h
mv usr/lib/x86_64-linux-gnu/libcudnn_static_v7.a $CUDA_PATH/lib64/libcudnn_static.a
rm -fr /download/cudnn
cd /
