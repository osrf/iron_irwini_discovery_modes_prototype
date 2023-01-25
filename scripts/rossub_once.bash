#!/bin/bash
echo "Subnet setting is $RMW_AUTOMATIC_DISCOVERY_RANGE_SUBNET and results are in /results/$RES_DIR/$(hostname)"
. /ros/install/setup.bash
ros2 topic echo --timeout 10 --once /test_topic std_msgs/String > /results/$RES_DIR/$(hostname)