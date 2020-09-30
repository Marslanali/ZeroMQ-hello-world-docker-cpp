#!/bin/sh

# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

EXEC_NAME="$0"

show_usage() {
  echo "Usage: $EXEC_NAME [-h]"
  echo ""
  echo "Build and run the docker image. See infer/docker/README.md for more"
  echo "information."
  echo ""
  echo "Options:"
  echo "  -h, --help   Show this message and exit"
}

while [ -n "$1" ]; do
  arg="$1"
  case $arg in
  "-h" | "--help" )
    show_usage;
    exit 0;
    ;;
  *)
    echo "unknown argument $1"
    show_usage;
    exit 1;
    ;;
  esac
done

if ! docker --version > /dev/null; then
  echo "docker install not working"
  exit 1
fi

if [ ! -f Dockerfile ]; then
  echo "Dockerfile not found. Are you in the right directory?"
  echo "Please see infer/docker/README.md for more information."
  exit 1
fi


NAME="zmq-hello-world-publisher-cpp"
docker network create zmq
docker build -t $NAME . && \
echo "*************************************************************" && \
echo "Docker Containner with ZeroMQ Hello World Publisher"           && \
echo "zmq-hello-world-publisher-cpp"                                 && \
echo "*************************************************************" && \
docker run -it --network=zmq --net-alias=$NAME $NAME /bin/bash
