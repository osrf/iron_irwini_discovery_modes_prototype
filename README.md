# Simple networking testbed

> :warning: This is experimental code and not likely to be stable for some time.

This repo provides a simple networking test bed using [docker](https://www.docker.com/) 
and [docker-compose](https://docs.docker.com/compose/). You will need to have both of these tools set up.
Additionally it assumes a checkout from the "discovery_modes_full.repos"

## Usage

One can test various scenarios use cases using the script and the `docker-compose.yml`. To get started simply run:
```
./test_scenario.bash <path to your ros2 checkout>
```
This will build a docker image and run a test scenario where a container
publishes a "Hello" message from a test set up. All containers listen on this setup and report their results to a `results` folder. In this repository. You will see the output of `rostopic echo /test_topic` from each container in the results folder.
