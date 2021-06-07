#!/bin/bash
echo "* Updating mirrors urls"
sudo sed -i 's/us/bg/g' /etc/apt/sources.list
echo "* Updating mirrors"
sudo apt update

echo "* Upgrading packages"
sudo apt upgrade -y

echo "* Disable swap"
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab


# Install containerd

sudo apt-get install containerd -y

sudo mkdir -p /etc/containerd
sudo su -
containerd config default  /etc/containerd/config.toml

# Install k8s

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get install kubeadm kubelet kubectl -y

# Fix containerd issues

echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf

sudo -s
sudo echo '1' > /proc/sys/net/ipv4/ip_forward
exit

sudo sysctl --system

# Enable required modules

sudo modprobe overlay
sudo modprobe br_netfilter

# Pull k8s images

sudo kubeadm config images pull

# TODO: Initialization
