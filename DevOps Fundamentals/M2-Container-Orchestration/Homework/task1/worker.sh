#!/bin/bash
echo "* Updating mirrors urls"
sudo sed -i 's/us/bg/g' /etc/apt/sources.list
echo "* Updating mirrors"
sudo apt update

#echo "* Upgrading packages"
#sudo apt upgrade -y

echo "* Installing docker"
sudo apt install docker.io -y

echo "* Start and enable docker"
sudo systemctl start docker
sudo systemctl enable docker

echo "* Install apt-transport-https and curl"
sudo apt install apt-transport-https curl -y

echo "* Add Kubernetes signing key"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

echo "* Add Kubernetes repo"
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

echo "* Install Kubernetes"
sudo apt install kubeadm kubelet kubectl kubernetes-cni -y

echo "* Disable swap"
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab