#!/bin/bash
. /ros/install/setup.bash
echo "Discovery setting is $ROS_AUTOMATIC_DISCOVERY_RANGE, and scenario name is ${RES_DIR}"
# sleep 5
ros2 topic echo --timeout 15 --once /test_topic std_msgs/String |& tee /results/subscriber
