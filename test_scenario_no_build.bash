#!/bin/bash

CURR_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#if [ "$#" != "1" ]; then
#    echo "Usage: ./test_scenario.bash <ros2 checkout workspace>"
#    exit 1
#fi

# Build the docker image
#mkdir -p $1/.ros_network_playground
#cp $SCRIPT_DIR/Dockerfile $1/.ros_network_playground
#cd $1
#docker build --build-arg SOURCE_DIR=. -t ros2_test_env -f .ros_network_playground/Dockerfile .


cd $SCRIPT_DIR
mkdir -p results
docker-compose up
docker-compose down

cd $CURR_DIR
