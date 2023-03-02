#!/bin/bash
. /ros/install/setup.bash
echo "Discovery setting is $ROS_AUTOMATIC_DISCOVERY_RANGE, and scenario is ${RES_DIR}"

ros2 topic pub -t 10 -w 1 --max-wait-time-secs 10 /test_topic std_msgs/String "data: Hello"
