#!/bin/bash

CURR_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR
mkdir -p results

for scenario in scenarios/*; do 
    dirname=`grep RES_DIR $scenario`
    dirname=$(echo $dirname | sed s/RES_DIR=//g)
    mkdir -p results/$dirname
    echo "Loading scenario $scenario"
    docker-compose --env-file $scenario up
    docker-compose --env-file $scenario down
done

cd $CURR_DIR
