#!/bin/bash
echo "Updating and upgrading the system"
sudo apt update -y
# sudo apt upgrade -y

echo "Installing curl"
sudo apt install curl -y

echo "Running the docker install script"
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "Adding the current user to the docker group"
sudo usermod -aG docker $USER

echo "Installing Docker Compose"
sudo apt install docker-compose -y