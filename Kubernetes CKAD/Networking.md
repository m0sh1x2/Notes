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