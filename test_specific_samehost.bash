#!/bin/bash

## Check usage
if [ "$#" -lt "2" ]; then
    echo "Usage: ./test_specific_samehost.bash <ros2 build workspace> <env_file> [rmw_middleware]"
    exit 1
fi

if [ ! -d "$1/install" ]; then
    echo "Path must contain prebuilt colcon work space"
    exit 1
fi

rmw_implementation=$3

CURR_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR

mkdir -p results

scenario=$2
dirname=`grep RES_DIR $scenario`
dirname=$(echo $dirname | sed s/RES_DIR=//g)

cat template/samehost-docker-compose.yml.template | sed s+ROS_BUILD_WS+$1+g > docker-compose.yml
sed -i s+SCENARIO_FILE+$scenario+g docker-compose.yml
sed -i s+SCENARIO_NAME+$dirname+g docker-compose.yml
sed -i s+CHOSEN_RMW_IMPLEMENTATION+$rmw_impementation+g docker-compose.yml

echo "Loading samehost scenario $scenario"
docker-compose up
docker-compose down

rm -rf docker-compose.yml

python3 report_gen.py

cd $CURR_DIR
