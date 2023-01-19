#!/bin/bash

. /ros/install/setup.bash
ros2 topic echo --timeout 10 --once /test_topic std_msgs/String > $RES_DIR