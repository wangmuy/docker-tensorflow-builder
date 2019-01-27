#!/bin/sh
export PYTHON_VERSION=3.6
export TF_VERSION_GIT_TAG=v1.9.0
export USE_GPU=1
export CUDA_VERSION=9.0
export CUDNN_VERSION=7.1

export _RUNTIME=$([ $USE_GPU -eq 1 ] && echo -n "nvidia" || echo -n "runc")
