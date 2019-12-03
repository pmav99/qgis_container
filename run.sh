#!/usr/bin/env bash
#
# Create or run a container which is able to run X applications
#

# strict mode
set -euo pipefail

# make it possible to run the GUI
xhost +local:docker

# variables
image_name='my_qgis:latest'
container_name='qgis_container'

if [ "$(docker container ls -a | grep $container_name | awk -F ' ' '{print $NF}')" == $container_name ]; then
    echo 'The container exists. Starting it and attaching a bash session to it'
    docker start $container_name
    #docker exec -it $container_name bash
    docker exec -it -u root $container_name bash
else
    echo 'The container does not exist! Creating it'
    docker run \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /tmp:/tmp \
        -u root \
        -v ${HOME}:/home/$(whoami) \
        --name "${container_name}" \
        -it "${image_name}" \
        bash
fi
