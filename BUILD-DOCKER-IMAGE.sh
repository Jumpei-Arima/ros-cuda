#!/bin/bash

IMAGE_NAME=$1
if [ -z "${IMAGE_NAME}" ]; then
    IMAGE_NAME=ros-cuda
fi
CUDA_VERSION=$2
if [ -z "${CUDA_VERSION}" ]; then
    CUDA_VERSION=11.1
fi
ROS_DISTRO=$3
if [ -z "${ROS_DISTRO}" ]; then
    ROS_DISTRO=melodic
fi

if [ "$ROS_DISTRO" == "noetic" ]; then
    UBUNTU_VERSION=20.04
    PYTHON_VERSION=python3
elif [ "$ROS_DISTRO" == "melodic" ]; then
    UBUNTU_VERSION=18.04
    PYTHON_VERSION=python
elif [ "$ROS_DISTRO" == "kinetic" ]; then
    UBUNTU_VERSION=16.04
    PYTHON_VERSION=python
fi

TAG_NAME=${CUDA_VERSION}-runtime-${ROS_DISTRO}

echo "IMAGE_NAME=${IMAGE_NAME}"
echo "TAG_NAME=${TAG_NAME}"

docker build . \
    -t ${IMAGE_NAME}:${TAG_NAME} \
    --build-arg nvidia_cuda_version=${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION} \
    --build-arg ros_distro=${ROS_DISTRO} \
    --build-arg python_version=${PYTHON_VERSION}