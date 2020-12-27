ARG nvidia_cuda_version=11.1-runtime-ubuntu18.04
ARG ros_distro=melodic
ARG python_version=python

FROM nvidia/cuda:${nvidia_cuda_version}

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        wget \
        curl \
        git \
        lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ROS
ARG ros_distro
ENV ROS_DISTRO=${ros_distro}
## https://wiki.ros.org/${ROS_DISTRO}/Installation/Ubuntu
### Setup source.list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
### Setup keys
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
###  Install ros-${ROS_DISTRO}-base
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        ros-${ROS_DISTRO}-ros-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
###  Dependencies for building packages
ARG python_version
ENV PYTHON_VERSION=${python_version}
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        ${PYTHON_VERSION}-pip \
        ${PYTHON_VERSION}-rosdep \
        ${PYTHON_VERSION}-rosinstall \
        ${PYTHON_VERSION}-rosinstall-generator \
        ${PYTHON_VERSION}-wstool \
        build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.bash && exec "$@"' \
    > /root/ros_entrypoint.sh

WORKDIR /root
ENTRYPOINT ["bash", "/root/ros_entrypoint.sh"]