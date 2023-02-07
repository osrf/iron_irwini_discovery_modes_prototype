#!/bin/bash
echo "Subnet setting is $RMW_AUTOMATIC_DISCOVERY_RANGE_SUBNET and setting name is ${RES_DIR}"
. /ros/install/setup.bash

ros2 topic echo --timeout 15 --once /test_topic std_msgs/String > /results/subscriber
