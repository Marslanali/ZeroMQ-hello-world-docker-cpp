#!/bin/sh

EXEC_NAME="$0"

show_usage() {
  echo "Usage: $EXEC_NAME [-h]"
  echo ""
  echo "Build and run the docker image. See /README.md for more"
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


NAME="zmq-hello-world-server-cpp"
docker network create zmq
docker build -t $NAME . && \
echo "*************************************************************" && \
echo "Docker Containner with ZeroMQ Hello World Server" && \
echo "zmq-hello-world-server-cpp"            && \
echo "*************************************************************" && \
docker run -it --network=zmq --net-alias=$NAME $NAME /bin/bash
