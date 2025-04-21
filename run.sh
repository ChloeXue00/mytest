#!/bin/bash

set -e

IMAGE_NAME="my-helloworld"
TAG="latest"

echo "clean old building cache(optional)... "
docker builder prune -f > /dev/null

echo "building img ${IMAGE_NAME}:${TAG} ..."
docker build -t ${IMAGE_NAME}:${TAG} .

echo "build complete, executing..."
docker run --rm -it --net=host ${IMAGE_NAME}:${TAG}
