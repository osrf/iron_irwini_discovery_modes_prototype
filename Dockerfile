FROM ubuntu:22.04

ARG SOURCE_DIR=src

RUN locale  # check for UTF-8

RUN  apt-get update &&  apt-get install -y locales
RUN  locale-gen en_US en_US.UTF-8
RUN  update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8
ENV  DEBIAN_FRONTEND=noninteractive

RUN sed --in-place --regexp-extended "s/(\/\/)(archive\.ubuntu)/\1sg.\2/" /etc/apt/sources.list && \
	apt-get update && apt-get upgrade --yes

RUN  apt-get install -y  software-properties-common
RUN  add-apt-repository universe

RUN  apt-get update &&  apt-get install -y curl
RUN  curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" |  tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN  apt-get update &&  apt-get install -y \
  python3-flake8-docstrings \
  python3-pip \
  python3-pytest-cov \
  ros-dev-tools

RUN  apt-get install -y \
  python3-flake8-blind-except \
  python3-flake8-builtins \
  python3-flake8-class-newline \
  python3-flake8-comprehensions \
  python3-flake8-deprecated \
  python3-flake8-import-order \
  python3-flake8-quotes \
  python3-pytest-repeat \
  python3-pytest-rerunfailures

RUN mkdir -p /ros

WORKDIR /ros

COPY ${SOURCE_DIR} /ros/src

RUN  rosdep init
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers" 

RUN colcon build --symlink-install
