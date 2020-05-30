# Get the IP address of the machine
MASTER_IP=$(ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
# Initiate the swarm
sudo docker swarm init --advertise-addr=$MASTER_IP
# Save the Swarm Token and Master IP from eth1
echo $MASTER_IP > /vagrant/master_ip
sudo docker swarm join-token --quiet worker > /vagrant/worker_token
# Allow port 2377 
# sudo ufw allow 2377
# sudo ufw reload