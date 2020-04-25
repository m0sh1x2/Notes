# Clustering and High Availability

- Node is a single physical virtual machine that runs services in a cluster
- Cluster is a group of two or more nodes that work together
- High availability is a set of techniques that aim to provide 100% availability or service
- Failover is a concept of switching over to a backup node
- Cluster resource is any resource that must be highly available
- Cluster service is any resource that is made available by the cluster
- Redundancy is having multitude of something. For example, nodes or resources
- Replication is related to redundancy but is focused on the synchronization of resources

## Measures

- Mean Time Before Failiure (MTBF) the average operational only time between system failures
- Main Time To Repair (MTTR) is the average amount of time needed to troubleshoot and repair a failed system and bring it back to operational state
- Service Level Agreement (SLA) is a contract between a provider and a consumer that sets the service reliability expectations
- Disaster Recovery (DR) - is a set of measures that are used in case of a resource or service becomes unavailable

# Cluster Types

- High Performance clusters are a se of different machines working together hosting one or more tasks that require lots of computing resources
- Load Balancing clusters serve as front-end and receive client requests which then get distributed to different member servers.
- High Availability (Failover) clusters aim on reducing the downtime of critical resources to a minimum

## Cluster Architectures

- Active/Passive usually consists of one active node that serves client requests and one or more backup nodes. Usually implemented as a failover cluster

Active/Active clusters typically consist of two identical nodes both servicing client requests. Usually achieved via a load balancing

## Recovery

- Split Brain Cluster is a situation when there is a loss of cummunication between the nodes and a node acts as if it is the only node in the cluster
- Fencing is a way to deal with the split-brain cluster. THe offending node is restricted(fenced) from accessing the shared resource. It could be as simple as shutting of the nodes as with the STONITH(shoot the other node in the head)
- Fencing can be implemented via quorum
- Hearbeat is another way of solving/preventing cluster issues. It is a service running on nodes that monitors and reports their state

# Load Balancing

## Linux Virtual Server(LVS)

- It is a high available and scalabel server built out of real servers and a load balancer.
- It is transparent to the end users
- Real servers are the backend (of member) servers that make up the virtual server
- The load balancer is often called a director
- Implements IP-level load balancing. The services of the real servers appear as a single IP adress

## Load Balancing Methods

- Virtual Server via NAT (-m)
    - One IP address for the balancer, servers ca use private addresses, request and response packets are sent through the balancer
- Virtual Server via IP Tunneling (-i)
    - Requests are scheduled to the members and they respond directly to the clients. Members must have IP tunneling protocol enabled
- Virtual Sever via Direct Routing (-g)
    - Balancer only handles the client requests, virtual address is shared by the load balancer and members, multiple interfaces required.
- Virtual Server Local Node
    - Allows testing of LVS on a single machine

## Scheduling Algorithms*

- Round-Robin (rr)
- Weighted Round-Robin (wrr)
- Least-Connection (lc)
- Weighted Least-Connection (wlc)
- Destination Hashing (dh)
- Source Hashing (sh)

## keepalived and ldirectord

- keepalived
    - Provides health checking and failover for load-balanced pools in LVS
    - Uses Virtual Router Redundancy Protocol (VRRP)
    - Ensures high availability of the virtual IP address
-  ldirectord
    - Daemon that monitors and administers real servers in LVS cluster
    - Real servers are listed in a configuration file
    - They are checked periodically and in case of issues are temporary removed from the pool

## HPRoxy

- Provides load balancing, high availability and proxying for TCP and HTTP-based applications
- Its speed and reliability made it de facto a preferred solution
- Simplified architecture and configuration
- Four proxy configurations
    - defaults section set common parameters for all sections
    - frontend defines any sockets accepting client connection
    - backend defines set of servers to which client connections will be redirected
    - listen allows combination of information about the frontend and backend servers

## High Availability Practice

```
sudo dnf install ipvsadm
```

Set the connection Zones

```
[m0sh1x2@centos01 ~]$ sudo nmcli connection modify eth0 connection.zone external
[m0sh1x2@centos01 ~]$ sudo nmcli connection modify eth1 connection.zone internal
```

Check the zones

```
[m0sh1x2@centos01 ~]$ sudo firewall-cmd --get-active-zones 
external
  interfaces: eth0
internal
  interfaces: eth1
```

ipvsadm config file location:

```
sudo cat /etc/sysconfig/ipvsadm-config
```

Set the main config file
```
touch /etc/sysconfig/ipvsadm:
```

Start the service
```
sudo systemctl enable --now ipvsadm
```

Install Apache on centos02 and centos03

```
sudo dnf install httpd
```

Set up Round-Robin balancing
```
sudo ipvsadm -A -t 192.168.66.1:80 -s rr
```

192.168.66.159 - centos02
192.168.66.160 - centos03

Add the servers

```
[m0sh1x2@centos01 ~]$ sudo ipvsadm -a -t 192.168.66.1:80 -r 192.168.66.159:80 -m
[m0sh1x2@centos01 ~]$ sudo ipvsadm -a -t 192.168.66.1:80 -r 192.168.66.160:80 -m
```

Open port 80 for internal and external zones

```
[m0sh1x2@centos01 ~]$ sudo firewall-cmd --add-service http --permanent --zone external
success
[m0sh1x2@centos01 ~]$ sudo firewall-cmd --add-service http --permanent --zone internal
success
[m0sh1x2@centos01 ~]$ sudo firewall-cmd --reload
success
```

Set up some test files in centos02 and centos03

```
echo "Hello from centos02|centos03 | sudo tee /var/lib/html/index.html
```

## TODO: Make the Haproxy task

```
Haproxy task here
```

# Failover Clusters


## Pacemaker
- Pacemaker is a highly-available cluster resource manager
- Partial list of Pacemaker's features:
    - Detection of and recovery from node- and service-level failures
    - Ability to ensure data integrity by fencing faulty nodes
    - Support for one or more nodes per cluster
    - Support for multiple resource interface standards (anything that can be scripted can be clustered)
    - Support (but no requirement) for shared storage
    - Support for practically any redundancy configuration (active/passive, N+1, etc.)

## Cluster Architecture

- Resources are the services that need to be kept highly available
- Resource agents are scripts or operating system components that start, stop, and monitor resources, given a set of resource parameters. These provide a uniform interface between Pacemaker and the managed services
- Fence agents are scripts that execute node fencing actions, given a target and fence device parameters
- Cluster membership layer component provides reliable messaging, membership, and quorum information about the cluster. Currently, Pacemaker supports Corosync as this layer
- Pacemaker being a cluster resource manager provides the brain that processes and reacts to events that occur in the cluster. These events may include nodes joining or leaving the cluster; resource events caused by failures, maintenance, or scheduled activities; and other administrative actions. To achieve the desired availability, Pacemaker may start and stop resources and fence nodes
- Cluster tools provide an interface for users to interact with the cluster. Various command-line and graphical (GUI) interfaces are available

## Pacemaker Stack

- Pacemaker
    - Resource Agents
    - Corosvnc

- Most managed service are not cluster-aware
- Many popular open-source cluster filesystems make use of a common Distributed Lock Manager(DML)

## Pacemaker Architecture

- The Pacemaker master process (pacemakerd) spawns all the other daemons and respawns them if they unexpectedly exit
- The Cluster Information Base (CIB) is an XML representation of the cluster’s configuration and the state of all nodes and resources. The CIB manager (pacemaker-based) keeps the CIB synchronized across the cluster and handles requests to modify it
- The attribute manager (pacemaker-attrd) maintains a database of attributes for all nodes, keeps it synchronized across the cluster, and handles requests to modify them. These attributes are usually recorded in the CIB
Given a snapshot of the CIB as input, the scheduler (pacemaker-schedulerd) determines what actions are necessary to achieve the desired state of the cluster
- The local executor (pacemaker-execd) handles requests to execute resource agents on the local cluster node and returns the result
- The fencer (pacemaker-fenced) handles requests to fence nodes. Given a target node, the fencer decides which cluster node(s) should execute which fencing device(s), and calls the necessary fencing agents (either directly, or via requests to the fencer peers on other nodes) and returns the result
- The controller (pacemaker-controld) is Pacemaker’s coordinator, maintaining a consistent view of the cluster membership and orchestrating all the other components
- Pacemaker centralizes cluster decision-making by electing one of the controller instances as the Designated Controller (DC). Should the elected DC process (or the node it is on) fail, a new one is quickly established. The DC responds to cluster events by taking a current snapshot of the CIB, feeding it to the scheduler, then asking the executors (either directly on the local node, or via requests to controller peers on other nodes) and the fencer to execute any necessary actions

## Corosync Cluster Engine 

- A Group Communication System with additional features for implementing high availability within applications
- It provides four C Application Programming Interface features:
- A closed process group communication model with extended virtual synchrony guarantees for creating replicated state machines
- A simple availability manager that restarts the application process when it has failed
- A configuration and statistics in-memory database that provide the ability to set, retrieve, and receive change notifications of information
- A quorum system that notifies applications when quorum is achieved or lost
- It is used as a High Availability framework by projects such as Pacemaker and Asterisk

## High Availability in Enterprise Distributions

- RHEL High Availability Add-On
    - Supports most applications and virtual guests in up to 16 nodes
    - Includes a cluster manager, lock management, fencing, command-line cluster configuration, and a Conga administration tool
- SLES High Availability Extension
    - Supports mixed clustering of both physical and virtual Linux servers to boost flexibility while improving service availability and resource utilization
    - Offers menu-driven setup process for rapidly deploying a base cluster, geo-clustering, templates and wizards, powerful unified interface (HAWK), cluster-wide shell (PSSH), etc.

## Practice - Failover Clusters










## TODO: Practice test

# Distributed Storage

## Open-iSCSI

- High-performance, transport independent, implementation of RFC 3720 iSCSI for Linux
- It is partitioned into user and kernel parts
- The kernel part implements iSCSI data path (iSCSI Read and iSCSI Write), and consists of several loadable kernel modules and drivers
- The user space contains the entire control plane: configuration manager, iSCSI - Discovery, Login and Logout processing, connection-level error processing, Nop-In and Nop-Out handling, etc.
- The user space component consists of a daemon process called iscsid, and a management utility iscsiadm

## iSCSI Terminology

- iSCSI Initiator is a client that authenticate to an iSCSI target and get the authorization of block level storage access
- iSCSI Target is a server that provides storage to an iSCSI Initiator
- Logical Unit Number (LUN) is used to divide the storage into sizable chunks. A LUN is a logical representation of a physical disk. Storage which has been assigned to the iSCSI initiator will be the LUN
- iSCSI qualified name (IQN) is a unique name that is assigned to the iSCSI target and iSCSI initiator to identify each other. It has the format iqn.yyyy-mm.<domain or naming>:unique name
- Portal is a network portal within the iSCSI network where the iSCSI network initiates. iSCSI works over TCP/IP, so the portal can be identified by IP address. There can be one or more Portal
- Access Control List (ACL) will allow the iSCSI initiator to connect to an iSCSI target. The ACL will restrict access for the iSCSI target so unauthorized initiators cannot connect

## GNU Cluster Filesystem (GlusterFS)

- GlusterFS is a scale-out network-attached storage file system
- Aggregates various storage servers over Ethernet or Infiniband RDMA interconnect into one large parallel network file system
- Servers are deployed as storage bricks, with each server running a glusterfsd daemon to export a local file system as a volume
- glusterfs client process creates composite virtual volumes from multiple remote servers using stackable translators
- By default files are stored whole, but striping of files across multiple remote volumes is also possible

## Global File System 2 (GFS2)

- It is native filesystem that interfaces with the kernel’s Virtual File System (VFS) layer
- Intended for cluster usage but can work on a single node also
- Uses distributed metadata and multiple journals
- Uses distributed lock manager to provide concurrent access
- Scales up to 16 nodes and allows up to 100 TB filesystem size

## Oracle Cluster File System 2 (OCFS2)

- It is a shared-disk filesystem created by Oracle
- Intended for cluster usage but can work on a single node also
- Has its own cluster stack (O2CB) which provides a distributed lock manager

## Distributed Replicated Block Device (DRBD)

- Replicated storage solution for Linux
- Block devices are mirrored over a communication link
- Requires kernel 2.6.33+
- Defined via resource records with the following structure
    - Resource name
    - Volumes
    - DRDB device
    - Connection
- Resource metadata is stored internally or externally

## DRBD Roles and Modes

- Resources roles
    - Primary – devices are given unrestricted access for read and write operations
    - Secondary – devices are restricted from read and write operations but still receive updates from the primary device
- Resource modes
    - Single-primary mode allows a single resource to function in the primary role on one member. Used with filesystems like ext3, ext4, etc.
    - In dual-primary mode both resources unction in the primary role on cluster nodes. Typically used with filesystems that implement distributed block manager, like GFS2 and OCFS2

## DRBD Replication Modes

- Protocol A (Asynchronous) – local write operations on the primary node are considered complete once the action finishes and the replication packet is placed on the TCP send buffer. Used with long-distance replication
- Protocol B (Semi-synchronous) – local write operation on the primary node are considered complete once the action finishes and the replication packet reaches the peer node
- Protocol C (Synchronous) – local write operations on the primary node are considered complete once the primary and peer node have completed the write operation

## DRDB Tools

- drdbsetup
    - Command line tool used to configure the DRDB kernel module
- drdbmeta
    - Used for managing DRDB meta-data structures
- drdbadm 
    - The main administration tool. It allows us to configure and manage DRDB resources. Acts like frontend to the other two tools.

# iSCSI Practice

Configure m1

```bash
sudo dnf install targetcli
sudo mkdir /var/lib/iscsi-images
sudo targetcli
cd backstores/fileio
create D1 /var/lib/iscsi-images/D1.img 10G
cd /iscsi
create iqn.2020-04.lab.lsaa:m1.tgt1
cd iqn.2020-04.lab.lsaa:m1.tgt1/tpg1/luns
create /backstores/fileio/D1
cd ../acls
create iqn.2020-04.lab.lsaa:m2.init1
create iqn.2020-4.lab.lsaa:m3.init1

# Set auth for m2

cd iqn.2020-04.lab.lsaa:m2.init1/
set auth userid=demo
set auth password=demo

# Set auth for m1

cd iqn.2020-04.lab.lsaa:m3.init1/
set auth userid=demo
set auth password=demo

# Enable the service over the firewall

sudo firewall-cmd --add-service iscsi-target --permanent
sudo firewall-cmd --reload
sudo systemctl enable --now target
```

Configure m2 and m3

```
sudo dnf install -y iscsi-initiator-utils
# Set the initiatorName
sudo vi /etc/iscsi/initiatorname.iscsi
# m2 - InitiatorName=iqn.2020-04.lab.lsaa:m2.init1
# m3 - InitiatorName=iqn.2020-04.lab.lsaa:m3.init1

sudo vi /etc/iscsi/iscsid.conf
# Uncomment line 58
# Set up auth on line 62 and 63

# Add the service on m2 and m3
sudo iscsiadm -m discovery -t sendtargets -p 192.168.1.140

# Check if everything is ok
sudo iscsiadm -m node -o show

# Login
sudo iscsiadm -m node login
sudo iscsiadm -m node --login

# Session check
sudo iscsiadm -m session show

# Run lsblk to check the new 10G drive/lum
$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda           8:0    0   25G  0 disk
├─sda1        8:1    0  600M  0 part /boot/efi
├─sda2        8:2    0    1G  0 part /boot
└─sda3        8:3    0 23.4G  0 part
  ├─cl-root 253:0    0 21.4G  0 lvm  /
  └─cl-swap 253:1    0    2G  0 lvm  [SWAP]
sdb           8:16   0   10G  0 disk
sr0          11:0    1    7G  0 rom
```

Set up HighAvailability

```
sudo dnf config-manager --set-enabled HighAvailability
sudo dnf install -y pacemaker pcs
sudo systemctl enable --now pcsd

# Set hacluster pass
sudo passwd hacluster

sudo firewall-cmd --add-service high-availability --permanent
sudo firewall-cmd --reload
```


Install and authorize m2 and m3 for cluster configuration

```
sudo dnf config-manager --set-enabled HighAvailability
sudo dnf install -y pacemaker pcs
sudo systemctl enable --now pcsd
sudo pcs host auth centos02 centos03
sudo pcs cluster start --all
sudo pcs cluster enable --all


```

Set up the cluster

```
sudo pcs cluster setup demo centos02 centos03
sudo pcs cluster start --all

```

Configure LVM

```bash
sudo vim /etc/lvm/lvm.conf
# Set system_id from none to uname

sudo parted -s /dev/sdb -- mklable msdos mkpart primary 16384s -0m set 1 lvm on
sudo parted -s /dev/sdb -- mklabel msdos mkpart primary 16384s -0m set 1 lvm on

[m0sh1x2@centos02 ~]$ sudo parted -s /dev/sdb -- mklabel msdos mkpart primary 16384s -0m set 1 lvm on
[m0sh1x2@centos02 ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda           8:0    0   25G  0 disk
├─sda1        8:1    0  600M  0 part /boot/efi
├─sda2        8:2    0    1G  0 part /boot
└─sda3        8:3    0 23.4G  0 part
  ├─cl-root 253:0    0 21.4G  0 lvm  /
  └─cl-swap 253:1    0    2G  0 lvm  [SWAP]
sdb           8:16   0   10G  0 disk
└─sdb1        8:17   0   10G  0 part
[m0sh1x2@centos02 ~]$ sudo pvc^C
[m0sh1x2@centos02 ~]$ sudo pvcreate /dev/sdb1
  Physical volume "/dev/sdb1" successfully created.
[m0sh1x2@centos02 ~]$ sudo vgcreate vg_ha /dev/sdb1
  Volume group "vg_ha" successfully created with system ID centos02
[m0sh1x2@centos02 ~]$ sudo vgs
  VG    #PV #LV #SN Attr   VSize  VFree
  cl      1   2   0 wz--n- 23.41g    0
  vg_ha   1   0   0 wz--n-  9.98g 9.98g
[m0sh1x2@centos02 ~]$ sudo vgs -o+systemid
  VG    #PV #LV #SN Attr   VSize  VFree System ID
  cl      1   2   0 wz--n- 23.41g    0
  vg_ha   1   0   0 wz--n-  9.98g 9.98g centos02
[m0sh1x2@centos02 ~]$ sudo lvcreate -l 100%FREE -n lv_ha vg_ha
  Logical volume "lv_ha" created.
[m0sh1x2@centos02 ~]$ sudo mkfs.ext4 /dev/vg_ha/lv_ha
mke2fs 1.44.6 (5-Mar-2019)
Creating filesystem with 2617344 4k blocks and 655360 inodes
Filesystem UUID: d6c527ff-b776-4be4-8325-a9c9cfcfe01e
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

Additional configs

```
sudo vgchange vg_ha -an 
sudo pvscan --cache --activate ay
sudo pcs resource create lvm_ha ocf:heartbeat:LVM-activate vgname=vg_ha vg_access_mode=system_id --group ha_group
```

Test the mount:

```
[m0sh1x2@centos02 ~]$ sudo mount /dev/vg_ha/lv_ha /mnt/
[m0sh1x2@centos02 ~]$ sudo touch /mnt/readme.txt

# Move the resource to m3
[m0sh1x2@centos02 ~]$ sudo pcs resource move lvm_ha centos03
```
