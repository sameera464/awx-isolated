#!/bin/bash

mkdir -p ./data/awx
mkdir -p ./data/postgres

DOCKER_IMAGE=devops/awx
DOCKER_TAG=develop

AWX_VERSION=2.0.1

# Remove previous image and recreate new image
docker rmi -f $DOCKER_IMAGE-isolated:$DOCKER_TAG
docker build -t $DOCKER_IMAGE-isolated:$DOCKER_TAG -f Dockerfile.isolated --build-arg  AWX_VERSION=$AWX_VERSION .

docker rmi -f $DOCKER_IMAGE-task:$DOCKER_TAG
docker build -t $DOCKER_IMAGE-task:$DOCKER_TAG -f Dockerfile.task --build-arg  AWX_VERSION=$AWX_VERSION .

docker rmi -f $DOCKER_IMAGE-web:$DOCKER_TAG
docker build -t $DOCKER_IMAGE-web:$DOCKER_TAG -f Dockerfile.web --build-arg  AWX_VERSION=$AWX_VERSION .