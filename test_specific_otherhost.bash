#!/bin/bash

## Check usage
if [ "$#" -lt "3" ]; then
    echo "Usage: ./test_specific_otherhost.bash <ros2 build workspace> <env_file_publisher> <env_file_subsciber> [rmw_middleware]"
    exit 1
fi

if [ ! -d "$1/install" ];
then
    echo "Path must contain prebuilt colcon work space"
    exit 1
fi

rmw_implementation=$4

## Common environment variables
CURR_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR

## Build image
docker build . -t ros2_test_env

mkdir -p results

scenario1=$2
dirname1=`grep RES_DIR $scenario1`
dirname1=$(echo $dirname1 | sed s/RES_DIR=//g)
mkdir -p results/$dirname1

scenario2=$3
dirname2=`grep RES_DIR $scenario2`
dirname2=$(echo $dirname2 | sed s/RES_DIR=//g)

cat template/otherhost-docker-compose.yml.template | sed s+ROS_BUILD_WS+$1+g > docker-compose.yml
sed -i s+SCENARIO1_FILE+$scenario1+g docker-compose.yml
sed -i s+SCENARIO2_FILE+$scenario2+g docker-compose.yml
sed -i s+SCENARIO_NAME+$dirname1/$dirname2+g docker-compose.yml
sed -i s+CHOSEN_RMW_IMPLEMENTATION+$rmw_implementation+g docker-compose.yml

mkdir -p results/$dirname1/$dirname2/
echo "Loading scenario $scenario1 and $scenario2"
docker-compose up
docker-compose down


rm -rf docker-compose.yml
python3 report_gen.py

cd $CURR_DIR
