# AWX Ansible Automation Findings

This document will go over the design and validation of using AWX on the Royal Caribbean LTD.
organization. It will focus on configurations, important findings and also on recommendations.
A section will also be dedicated on action items that still need improvement.

# Configuration

AWX will require the use of a Docker containers to run easily and successfully. Currently there
are only a hand full of supported installation platforms

Support Platforms (Easy Installation)
- OpenShift
- Kubernetes Cluster
- Docker Cluster

DC/OS is not a supported platform available in the installation scripts. For my testing I took
the Docker Cluster installation and converted it to marathon.json.

## DC/OS Convertion Proccess

- First install AWX locally on system to generate Docker Compose scripts
- Convert Docker Compose services to Marathon JSON objects
- Change docker containers to official available ones under the ansible/ docker-hub account
- Create shared volume needs for PostgreSQL
- Create needed secrets for containers on DC/OS

## Start Sequence

The containers were started in the following sequene using the same sequence that docker-compose
would trigger.

- PostgresSQL
- RabbitMQ
- MemcacheD
- Task Container
- Web Container

## Special Configurations Needs

- The task container needs the docker host parameter to be set as aws, i.e. `hostname=awx`
- AWX requires an ELB and can't to triggred through context on url, i.e. `http://hostname.com/awx`
will not work because AWX uses url's starging with `/static` for many resources
- Containers will need to have sysctl configured for setting `net.ipv4.tcp_keepalive_time=600` if
this is not done websocket connections will continue to time out and task container restart is
required
- To remove instances from AWX we need to execute `awx-manage` commands from task nodes

## Action Items still to investigate

- Healthceck for task and web container need to be validated as currently it is disabled because api
healthcheck endpoint was returning bad HTTP error code

# Ship Design

For Ship's to properly work under the bandwith, latency and connectivity issues that we expirience
when using satellite internet we will need to implement what is called Isolated nodes on each ship.
Currently Isolated nodes are not officially supported under AWX.

However all implementation and cli commands needed to connect isolated nodes are already implemented.
However ther is no current automated way to deploy these nodes.

## Isolated Nodes

A container will need to be created and SSH key's that are stored in the AWX Task container AWX user
will need to be added to the authorized key's in the container. The isolated node will require deployment
on the ship on top of docker and will need to be configured to allow ssh.

The isolated node will then require the triggering of several `awx-manage` commands to connect to the
AWX cloud cluster.

The AWX cloud cluster will need to have a Instance Group created for the isolated node described above.
Each job template that needs to be triggered on the isolated node needs to have the Instance Group
created for the isolated node configured.

# Local Environment Sandbox

Inside of the `docker` directory a local environment sandbox has been created using custom docker
containers and leveraging docker-compose.

Please read the README located in `docker/README.md` to understand how to configure and set up.
