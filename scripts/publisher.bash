#!/bin/bash
. /ros/install/setup.bash
echo "Discovery setting is $ROS_AUTOMATIC_DISCOVERY_RANGE, and scenario is ${RES_DIR}"
# sleep 5
# ros2 topic echo --timeout 10 --once /test_topic std_msgs/String > /results/publisher &
ros2 topic pub -t 10 -w 1 --max-wait-time 10 /test_topic std_msgs/String "data: Hello"
