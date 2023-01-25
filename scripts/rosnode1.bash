#!/bin/bash

. /ros/install/setup.bash
echo "Subnet setting is $ROS_AUTOMATIC_DISCOVERY_RANGE and results are in /results/$RES_DIR/$(hostname)"

# Only set static peers if it is passed in environment config
if [[ ! -z "${RMW_STATIC_PEERS}" ]]; then
    echo "Setting static peers"
    export ROS_STATIC_PEERS=${RMW_STATIC_PEERS}
fi

ros2 topic pub -t 10 --max-wait-time 30 /test_topic std_msgs/String "data: Hello" & ros2 topic echo --timeout 40 --once /test_topic std_msgs/String > /results/$RES_DIR/$(hostname)
