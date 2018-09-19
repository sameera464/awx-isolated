#/bin/bash

mkdir -p ./data/awx
mkdir -p ./data/postgres

DOCKER_IMAGE=devops/awx
DOCKER_TAG=develop

# Remove previous image and recreate new image
docker rmi -f $DOCKER_IMAGE-isolated:$DOCKER_TAG
docker build -t $DOCKER_IMAGE-isolated:$DOCKER_TAG -f Dockerfile.isolated .

docker rmi -f $DOCKER_IMAGE-task:$DOCKER_TAG
docker build -t $DOCKER_IMAGE-task:$DOCKER_TAG -f Dockerfile.task .

docker rmi -f $DOCKER_IMAGE-web:$DOCKER_TAG
docker build -t $DOCKER_IMAGE-web:$DOCKER_TAG -f Dockerfile.web .