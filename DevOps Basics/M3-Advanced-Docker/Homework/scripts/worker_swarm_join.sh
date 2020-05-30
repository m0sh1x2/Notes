#!/bin/bash
echo "Joining the swarm"
MASTER_IP=$(cat /vagrant/master_ip)
SWARM_TOKEN=$(cat /vagrant/worker_token)
sudo docker swarm join --token "${SWARM_TOKEN}" "${MASTER_IP}":2377