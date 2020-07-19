#
# Kubernetes Master Node Setup
#
APISERVER_ADVERTISE_ADDRESS=$(ip a | grep eth1 | awk '{ print $2 }' | awk -F "/" '{print $1}' | sed '2q;d')

echo "* Initialize Kubernetes"
# We need to specify the cidr network, otherwise coredns will be stuck on ContainerCreating
sudo kubeadm init --apiserver-advertise-address=${APISERVER_ADVERTISE_ADDRESS} --pod-network-cidr=10.244.0.0/16

# TODO:
# We will also need the setup of the advertised address on the public network
echo "* Regular user command setup"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "* Apply pod network"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

# Get Control Node Token
sudo kubeadm token list | awk '{ print $1 }' | sed '2q;d' >/vagrant/share/control_token.txt
# Get Control Node Hash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //' >/vagrant/share/control_hash.txt
# Get Control Node exposed IP
echo ${APISERVER_ADVERTISE_ADDRESS} >/vagrant/share/control_ip.txt

# Worker node setup example:
#kubeadm join 10.0.2.15:6443 --token lgismc.yoqt2kiz71wt4ome --discovery-token-ca-cert-hash sha256:6ac9877febcc980b244283a222e35a2b3d6b8a231caa64a40bb4e5874fe41cee
