#
# Kubernetes Master Node Setup
#

echo "* Initialize Kubernetes"
# We need to specify the cidr network, otherwise coredns will be stuck on ContainerCreating
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# TODO:
# We will also need the setup of the advertised address on the public network
echo "* Regular user command setup"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "* Apply pod network"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

# Slave node setup

#kubeadm join 10.0.2.15:6443 --token lgismc.yoqt2kiz71wt4ome --discovery-token-ca-cert-hash sha256:6ac9877febcc980b244283a222e35a2b3d6b8a231caa64a40bb4e5874fe41cee