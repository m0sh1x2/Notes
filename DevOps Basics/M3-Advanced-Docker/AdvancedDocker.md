# Docker Family

- Docker Engine
- Docker Machine
- Docker Compose
- Docker Swarm

# Docker Machine

- Tool for provisioning and managing Dockerized hosts
- Dockerized hosts can be local or remote VMs
- Supports VirtualBox, VMware products, AWS, and etc.

## docker-machine create

- Purpose
    - Create a machine
- Syntax 
    - docker-machine create [OPTIONS] [arg...]
- Example
    - # create dev machine with default virtualbox driver
    - docker-machine create dev

```
# create dev machine with vmwarevsphere driver
# environment variables could be used i.e. $VSPHERE_NETWORK
docker-machine create --driver vmwarevsphere \
   --vmwarevsphere-username=<username> \
   --vmwarevsphere-password=<password> \
   --vmwarevsphere-vcenter=<ip-address> \
   --vmwarevsphere-network=<network-name>\
   --vmwarevsphere-datastore=<ds-name> \
# applicable only to vCenter
#  --vmwarevsphere-datacenter=<dc-name> \
#  --vmwarevsphere-hostsystem=<cluster-name> \
   dev
```

## docker-machine env

- Purpose
    - Display the commands to setup the environment
- Syntax 

```
docker-machine env [OPTIONS] [arg...]
```

- Example

```
# display the environment setup for the dev machine
docker-machine env dev
# display and unset the environment setup
docker-machine env -u
```

docker-machine ls

- Purpose
    - List docker machines

# Communication - Networks: Overview and Usage

## Цomponents

- Three components
    - CNM(Specification)
    - Libnetwork(Networking logic, Api,...)
    - Drivers(Bridge, Overlay, ...)

# Persistent Data: Volumes: Overview and Usage

## Volume Overview

- Allow for external data in containers
- Two types
    - Data volumes
    - Data volume containers
- Created upfront, during run or build phase(VOLUME command)
- Data volumes can be shared
- Data volumes persist

# Practice

First set up:

- Vagrant/Virtualbox with nested virtualization server
- Install docker-machine on the ubuntu server
- Install VirtualBox on the server(with nested virtualization)

```
docker container run -it -v /test-vol --name c1 ubuntu /bin/bash
docker container run -it --volumes-from c1 --name c2 /bin/bash

```


# Distributed Applications

## Web Apps
    - Server  
        - UI
        - Business Logic
        - Database Layer
    - Containerized apps
        - UI Container
        - Business Logic Container
        - Database Layer Container

## Link Containers

```
docker container run -d ... -p 8080:80 --link c-mysql:dob-mysql ...
```

## Isolated Network

- Work in an isolated environment

```
docker container run -d ... -p 8080:80 --net dob-network ...
```

# Docker Compose

- Define and run multi-container Docker applications
- Multiple isolated environments on a single host
- Preserve volume data when containers are created
- Only recreate containers that have changes
- Supports variables
- Use cases
    - Development environments
    - Automated testing
    - Single host deployments

# Practice

```
# Copy from WIndows to the VM
scp -r DOB-M3/ vagrant@192.168.1.235:/home/vagrant/

# Copy from the VM to docker-machine

scp -r DOB-M3/ docker@192.168.99.100:/home/docker/

# pass is tcuser

# SSH back to the machine

docker-machine ssh default

cd 

docker image build -t img-php .
docker image build -t img-mysql .

docker container run -d --name c-mysql -e MYSQL_ROOT_PASSWORD=12345 img-mysql
docker container run -d --name c-php -p 8080:80 -v /home/docker/M3-2a/index.php:/var/www/html --link c-mysql:dob-mysql img-php

docker network create --driver bridge dob-network
docker container run -d --net dob-network --name dob-php -p 8080:80 -v /home/docker/M3-2a:/var/www/html img-php

# Alternative method to connect to the database


docker cotnainer run -d --net dob-network --name dob-mysql -e MYSQL_ROOT_PASSWORD=123456 img-mysql

```

## Docker Compose Practice

```
# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo -i
chmod +x /usr/local/bin/docker-compose

# Delete all running containers

docker container rm $(docker container ps -aq) --force

```

# Docker Swarm

- Docker engines joined in a cluster
- Commands are executed by the swarm manager
- There could be more than one manager, but only one is Leader
- Nodes that are not managers are called workers
- Both managers and workers are running containers
- There are different strategies to run containers
- Nodes can be physical or virtual

## Intialization

- Initialize cluster
    - docker swarm init
- Join to a cluster
    - docker swarm join
- Leave a cluster
    - docker swarm leave

## Deployment Options

- Options
    - Cloud (Azure, AWS, …)
    - On-premise - VM, Bare-metal
- Deployment Strategy (on-premise)
    - docker-machine
    - Vagrant

# Stacks and Compose - Deployment automation

## Tasks, Services, and Stacks

- Tasks are units of work distributed to nodes
- Service is an application deployed on swarm
- In fact service is the definition of the tasks to execute
- Replicated and global services distribution model
- Stacks are groups of interrelated services
- Stacks are deployed with docker-compose