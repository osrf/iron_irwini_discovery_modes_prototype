#!/bin/bash
. /ros/install/setup.bash
echo "Same host publisher setting is $ROS_AUTOMATIC_DISCOVERY_RANGE, static peers is ${ROS_STATIC_PEERS}"

mkdir -p /results/no_discovery_no_static
ROS_AUTOMATIC_DISCOVERY_RANGE=OFF ROS_STATIC_PEERS="" ros2 topic echo --timeout 15 --once /test_topic std_msgs/String > /results/no_discovery_no_static/subscriber &

mkdir -p /results/localhost_no_static
ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST ROS_STATIC_PEERS="" ros2 topic echo --timeout 15 --once /test_topic std_msgs/String |& tee /results/localhost_no_static/subscriber &

mkdir -p /results/subnet_no_static
ROS_AUTOMATIC_DISCOVERY_RANGE=SUBNET ROS_STATIC_PEERS="" ros2 topic echo --timeout 15 --once /test_topic std_msgs/String > /results/subnet_no_static/subscriber &

mkdir -p /results/no_discovery_static
ROS_AUTOMATIC_DISCOVERY_RANGE=OFF ROS_STATIC_PEERS="10.0.0.2" ros2 topic echo --timeout 15 --once /test_topic std_msgs/String > /results/no_discovery_static/subscriber &

mkdir -p /results/localhost_static
ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST ROS_STATIC_PEERS="10.0.0.2" ros2 topic echo --timeout 15 --once /test_topic std_msgs/String > /results/localhost_static/subscriber &

mkdir -p /results/subnet_static
ROS_AUTOMATIC_DISCOVERY_RANGE=SUBNET ROS_STATIC_PEERS="10.0.0.2" ros2 topic echo --timeout 15 --once /test_topic std_msgs/String > /results/subnet_static/subscriber &

ros2 topic pub -t 10 -w 0 /test_topic std_msgs/String "data: Hello"
