#!/bin/bash

# Autoware options
IMAGE_NAME="autoware"
AUTOWARE_TAG=${AUTOWARE_TAG:-local} # bleedingedge
ROS_DISTRO=${ROS_DISTRO:-melodic}
SUFFIX="-carla"
IMAGE=$IMAGE_NAME:$AUTOWARE_TAG-$ROS_DISTRO$SUFFIX

#RUNTIME="--runtime=nvidia"
RUNTIME="--gpus all"

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.Xauthority

SHARED_DOCKER_DIR=/home/autoware/shared_dir
SHARED_HOST_DIR=/home/$USER/shared_dir

VOLUMES="--volume=$XSOCK:$XSOCK:rw
         --volume=$XAUTH:$XAUTH:rw
         --volume=$SHARED_HOST_DIR:$SHARED_DOCKER_DIR:rw"

# Run Autoware
echo "Running ${IMAGE}"
docker run \
    -it --rm \
    $VOLUMES \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY=${DISPLAY}" \
    --privileged \
    --net=host \
    --user="autoware" \
    $RUNTIME \
    $IMAGE \
    /bin/bash