# Linux Networking Basics

- Switching and Routing
    - Switching
    - Routing
    - Default Gateway
- DNS
    - DNS Configurations on Linux
    - CoreDNS Introduction
- Network Namespaces
- Docker Networking

## Switching

```
ip link
ip addr add 192.168.1.10/24 dev eth0
```

Display kernel routing table
```
route
```

In order to make network 192.168.1.0/24 to reach 192.168.2.0/24 we must add a route:

```
ip route add 192.168.2.0/24 via 192.168.1.1
```

The routes must be added on all systems:

```
ip route add 192.168.1.0/24 via 192.168.2.1
```

In order to route external traffic and reach other addresses/domains/sites we have to add a default gateway:

```
ip route add default via 192.168.2.1 # we can also use 0.0.0.0 instead of default
```
In order to forward packets to the internal network we must enable IP Forwarding:

```
cat /proc/sys/net/ipv4/ip_forward
0
```

Just set it to 1

We must modify this in the /etc/sysctl.conf in order to make it perisstent.

```
ip link - lists the interfaces on the host
ip addr - lists the addresses of the interfaces
ip addr add 192.168.1.10/24 dev eth0 - set ip address
ip route - gets the routing address
ip route add 192.168.1.0/24 via 192.168.2.1 - route the network traffic
cat /proc/sys/net/ipv4/ip_forward - forward network traffic
```

# DNS Configurations

/etc/resolv.conf - the default nameservers for name resolution

# Network Namespaces

Create a new network namespace  
```
ip netns add red
ip netns add blue
ip netns list # List network namespaces
ip netns exec red ip link # execute ip link in the namespace
ip -n red link # Same command as above
```

```
arp
ip netns exec arp
```

Connect network namespaces:
```
ip link add veth-red type veth peer name veth-blue
ip link set veth-red netns red
ip link set vet-blue netns blue
ip -n red addr add 192.168.15.1 dev veth-red
ip -n blue addr add 192.168.15.2 dev veth-blue
ip -n red link set veth-red up
ip -n blue link set veth-blue up
ip netns exec red arp
ip netns exec blue arp
```

Create a virtual switch

```
# Linux bridge
ip link add v-net-0 type bridge
ip link # appers as a normal interface
ip link set dev v-net-0 up
```

Delete the old cable
```
ip -n red link del veth-red # The other cable is deleted automatically
```

```
ip link add veth-red type veth peer name veth-red-br
ip link add veth-blue type veth peer name veth-blue-br
lip link set veth-red netns red
ip link set veth-red-br master v-net-0
ip link set veth-blue netns blue
ip link set veth-blue-br master v-net-0
ip -n red addr add 19
# Set IP addresses
ip -n red addr add 192.168.15.1 dev veth-red
ip -n blue addr add 192.168.15.2 dev veth-blue
ip -n red link set veth-red up
ip -n blue link set veth-blue up 
```

ping 192.168.15.1 - will fail

```
ip addr add 192.168.15.5/24 dev v-net-0
```
and the ping will work

Connect to the LAN network

```
ping 192.168.13 # The ping will fail
# The interface will check its routing table:
ip netns exec blue route
# We have to add a gateway to the outside world:
ip netns exec blue ip route add 192.168.1.0/24 via 192.168.15.5
# Ping will fail again
# We have to enable NAT
iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUARADE
# And ping will work
ip netns exec blue ping 8.8.8.8 # Will fail, we need a default gateway
ip netns exec blue route 
ip netns exec blue ip route add default via 192.168.15.5 # And the ping will work
```

If we want to make the internal NS network available we must set ip an IPTABLES rule to forward the traffic:

```
iptables -t nat -A PREROUTING --dport 80 --to-destination 192.168.15.2:80 -j DNAT
```

# Docker Networking

## The none network
```
docker run --network none nginx # The container is not connected to any network
```

## The host network
```
docker run --network host nginx
```
The application will be available on the host network

## The bridge network

```
docker run nginx
```

This is the default network.

docker network ls - the network is named bridge
ip link - docker0 
It uses namespaces for naming:

```
ip link add docker0 type bridge
```

# CNI - Container Networking Interface

Basically it is a standard in setup and connecting containers to the network.

CNI comes with a default set of plugins:
- BRIDGE
- VLAN
- IPVLAN
- MACVLAN
- WINDOWS
- DHCP
- host-local

Other solutions are:
- weaveworks
- flannel
- cilium
- NSX(Vmware)
- Calico

Docker does not implement CNI it implements CNM(Container Network Model). 

But we can hack it and use the ```bridge``` plugin to connect to one of the plugins:

```
docker run --network=none nginx
bridge add CONTAINER_ID /var/run/netns/CONTAINER_ID
```

By default kubernetes creates the containers in the ```none``` network.

# Cluster networking

Every node must be connected to at least one network interface.

The master node must listen to port 6443
Worker nodes and kubelet listen on port 10250
Kube-scheduler - port 10251
Kube-controller-manager - port 10252
The worker nodes expose services from port 30000 to 32767
ETCD listens on 2379
For multiple master nodes port 2380 must be open so that ETCD can talk with each other.

Get amount of connections for a service:

```
netstat -anp | grep etcd
```

Port 2380 is for peer-to-peer connectivity for ETCD.

# Pod Networking

Kubernetes does not have a default networking solution but it expects:

- Every POD should have an IP Address
- Every POD should be able to communicate with every other POD on the same node.
- Every POD should be able to communicate with every other POD on any other node without NAT.

We can solve this with the following commands(before we try to use the complete solutions):

```
ip link add v-net-0 type bridge
ip link set dev v-net-0 up
ip addr add 192.168.15.5/24 dev v-net-0
ip link add veth red type veth peer name veth-red-br
ip link set veth-red netns red
ip -n red addr add 192.168.15.1 dev veth-red
ip -n red link set veth-red up
ip link set veth-red-br master v-net-0
ip netns exec blue ip route add 192.168.1.0/24 via 192.168.15.5
iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUARADE
```

# Configuring CNI

The CNI plugin is configured in the kubelet service.

The Weave CNI plugin:

- Deployes an agent on every node in the cluster
- Every sent packet is encapsulated and sent to the other node
- Then the agent on that node manages the request and forwards the requests to the appropriate container.
- Each agent/peer stores a copy of the topology and setup
- Weave is deployed as a deamon set on each node.
- To debug check the logs of the pods.


## Identify the CNI plugin

```
ls /etc/cni/net.d/
```

# IPAM - IP Address Managment

```
# This is the configuration that tells which network plugin to be used.
cat /et/cni/net.d/net-script.conf
```

WeaveNet uses 10.32.0.0./24 - around 1,048,574 IP addresses
- IPs are split across the nodes

Get pod default gateway:

```
# Run busybox and run
ip r
```


# Service Networking

In order to make pods communicate with each other we must create a service so that we can expose the network/ports.

When a service is created is accessible across the cluster(it is not bound to a specific node) - ClusterIP

NodePort - Makes the ports accessible on a port for all nodes.

Our focus is more on services and not on ports.

How does this work:

1. Kubelet manages the pods and creates them on every node.
2. Each Kubelet sericice then invokes(after the kube-apiserver) the CNI plugin to set up an IP Address for every pod.
3. Each node runs the kube-proxy and every time a new service is created kube-proxy creates the service across the nodes.
4. Services are a virtual object - they do not exist as a service/process or a pod.
5. When a service is created they are being assigned an IP address from a specific range. 
    - by default kube-proxy uses iptables otherwise it can use ipvs and userspace.

```
kube-api-server --service-cluster-ip=-range ipNet - default ip is 10.0.0.0/24
ps aux | grep kube-api-server
```

## Get more info about the service with iptables

```
iptables -L -t net | grep db-service
```

Those entries are also logged in to the kube-proxy.log:

```
cat /var/log/kube-proxy.log
```

## Get IP defautl IP range of pods:

```
The network is configured with weave. Check the weave pods logs using command kubectl logs <weave-pod-name> weave -n kube-system and look for ipalloc-range
```

## Get IP Range of services in the cluster:

```
# Inspect the setting on kube-api server by running on command cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep cluster-ip-range:
```

## Get the type of kube-proxy configuration

```
# By default it is iptables
# get the logs of the kube-proxy and check what is being used
```

# Cluster DNS

http://web-service - the main domain when in the same namespace
http://web-service.apps - apps is the name of the namespace and creates the pod as a subdomain
http://web-service.apps.svc - you can reach the app with the service "extension"
http://web-service.apps.svc.cluster.local - this is how services are resolved within the cluster.

```
KubeDNS -> Hostname(web-service) -> Namespace(apps) -> Type(svc) -> Root(cluster.local) -> IP Address
```

## Identify the configuration for CoreDNS service

```
kubectl -n kube-system describe deployments.apps coreds | grep -A2 Args | grep Corefile
```

# CoreDNS

- Deployed as 2 pods in the cluster as a replica set in a deployemtn.
- /etc/coredns/Corefile
- The Coredns config is set up as a ConfigMap object
    - ```kubectl get configmap -n kube-system```

# Ingress

