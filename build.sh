#!/usr/bin/env bash

set -xeuo pipefail

docker build \
  --build-arg USER_NAME=$(whoami) \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  -t my_qgis \
  ./
