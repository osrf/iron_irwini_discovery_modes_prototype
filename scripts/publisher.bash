#!/bin/bash
. /ros/install/setup.bash
echo "Discovery setting is $ROS_AUTOMATIC_DISCOVERY_RANGE, scenario is ${RES_DIR}"

ros2 topic pub -t 10 --max-wait-time 5 /test_topic std_msgs/String "data: Hello"  > /results/publisher
#& ros2 topic echo --timeout 10 --once /test_topic std_msgs/String > /results/publisher
