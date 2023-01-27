FROM ghcr.io/arjo129/ros2_base_rosdeps:main

ARG SOURCE_DIR=src

RUN mkdir -p /ros

WORKDIR /ros

COPY ${SOURCE_DIR} /ros/src

RUN rosdep update
RUN apt-get update && rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers" 

RUN colcon build --symlink-install
