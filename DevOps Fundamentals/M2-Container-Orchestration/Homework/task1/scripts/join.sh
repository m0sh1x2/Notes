#!/bin/bash

echo "* Joining the Kubenetes cluster"
CONTROL_TOKEN=$(cat /vagrant/share/control_token.txt)
CONTROL_HASH=$(cat /vagrant/share/control_hash.txt)
CONTROL_IP=$(cat /vagrant/share/control_ip.txt)

sudo kubeadm join ${CONTROL_IP}:6443 --token ${CONTROL_TOKEN} --discovery-token-ca-cert-hash sha256:${CONTROL_HASH}