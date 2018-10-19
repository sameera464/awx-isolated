# AWX Docker

This is a custom project, which creates modified docker containers to allow AWX
to run with isolated nodes. The isolated nodes is a full custom installation
using the AWX 1.0.7 standards and leveraging the `awx/tools/docker-isolated`
documentation and Dockerfile.

# Getting Started

To create all needed containers by the docker-compose file, rung the build.sh
script

`./build.sh`

This script will generate 3 containers each with a `develop` tag. The script
if ran multiple times will delete the previous created containers.

## Docker Compose

To run all containers, execute docker-compose which will create the following
containers.

- devops/awx-web
- devops/awx-task
- devops/awx-isolated
- ansible/awx_rabbitmq
- memcached
- postgres

##  Starting Docker Compose

To start docker-compose with no isolated run
```console
$ docker-compose up
```

To start docker-compose with isolated image run
```console
$ docker-compose -f docker-compose.yml -f docker-isolated-override.yml up
```

## Accessing AWX

To access AWX you can hit the url `http://localhost:8052`. Defautl username/password
are `admin/password`

The API is available at `http://localhost:8052/api/`

# Data location

A data location has been provided to hold dat a for the conatiners. This data
location is mounted as volumes to the container.

It maintains state for Postgres database as well as creating unsecure ssh keys
for task container to have access to the isolated container.

# Running Jobs on Isolated Nodes

To run a job on an isolated node you must specify it at a template level. Under the
template configuration select that instance group called `thepentagon` and save the
job template. This tells the teamplate that it must run an an instance for the group
`thepentagon`.

# Known Issues

1. After all containers are started the isolated container shows as unavailable, to
enabled the connection follow these steps
  - Go to `Instance Groups`
  - Select `INSTANCES` under `thepentagon` group
  - Switch the `isolated` instance to `OFF`
  - Switch the `isolated` instance to `ON`
  - `USED CAPACITY` should no longer reflect `unavailable`
