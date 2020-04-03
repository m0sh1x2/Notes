# Виртуализация и контейнеризация

```
# Enable nested virtualization in Hyper-V
 	
Set-VMProcessor <VMName> -ExposeVirtualizationExtensions $true
Set-VMProcessor "Cenots 8" -ExposeVirtualizationExtensions $true
```

Check type of virtualization


vmx - Intel
sdm - AMD

# Check hardware assited virtualization
```shell
egrep -c -wo 'vmx|svm' /proc/cpuinfo
```

## Install virtualizaiton

```shell
sudo dnf install libvirt qemu-kvm virt-install

```

## Check libvirtd status
``` 
systemctl status libvirtd
```

## Libvrt configuration path
```
# Default libvrt network configuration
sudo vi /etc/libvrt/qemu/networks/default.xml

# Check libvert configurations
sudi ls -al /etc/libvrt/qemu/networks/autostart

```

- libvrt generates two network adapters by default virbr0 and virbr0-nic

## virsh

- Shell for control of the virtual infrastructure


Check virsh network lists

``` 
sudo virsh net-list

# Configure the virsh network

sudo virsh net-dumpxml --network default

```

## Dump the default network configuration into a file

```
sudo virsh net-dumpxml --network default > hostonly.xml
```
Edit the configuration

```
vi hostonly.xml
```

From 

```xml
<network>
  <name>default</name>
  <uuid>d226e29e-c5c9-4983-b0a1-b290e0b19e35</uuid>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:c4:6c:02'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

To

```xml
<network>
  <name>hostonly</name>
  <bridge name='virbr2' stp='on' delay='0'/>
  <mac address='52:54:00:c4:6c:03'/>
  <ip address='192.168.100.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.100.100' end='192.168.100.254'/>
    </dhcp>
  </ip>
</network>
```

- 52:54:00 is the KVM default mac address identificator.


## Define the new network

```
sudo virsh net-define --file hostonly.xml
```

- After the definition, the network will be inactive.

```
sudo virsh net-list --inactive

# Set autostart of the network
sudo virsh net-autostart --network hostonly

# Start the network
sudo virsh net-start --network hostonly

# Check the network status again

sudo virsh net-list --inactive
```

-What is the defaut network manager for RedHat?

## Check network connections

```
nmcli conn show
```

### Add an additional connection

```
sudo nmcli connection add type bridge ifname virbr1 autoconnect yes con-name virbr1 stp off
```

### Add connection to the eth1 interface

```
sudo nmcli conn add type bridge-slave autoconnect yes con-name eth1 ifname eth1 master virbr1
```

### Restart the network Network Manager
```
sudo systemctl restart NetworkManager
```

### Restart libvirtd
```
sudo systemctl restart libvirtd
```

### Now we have 3 ways of connection

- Nat only
- Host only
- External connection

### The default location of the libvirt images is:

```
/var/lib/libvirt/images/
```

### Install virt-viewer

```
sudo dnf install virt-viewer
```

### Set up the virtual machine
```
sudo virt-install \
--hvm \
--name=vm01 \
--vcpus=1 \
--ram=1042 \
--os-type=linux \
--os-variant=centos7.0 \
--disk path=/var/lib/libvirt/images/vm1.qcow2,size=12 \
--cdrom=/var/lib/libvirt/images/CentOS-7-x86_64-Minimal-1908.iso \
--network=bridge:virbr0 --graphics spice --noautoconsole
```
- Additional info: https://unix.stackexchange.com/questions/309788/how-to-create-a-vm-from-scratch-with-virsh


### Create disk manually

```
# Thin disk
sudo qemu-img create -f qcolw2 /var/lib/libvirt/images/thin-disk.qcow2 -o size=12G,preallocation=off

# Preallocated disk
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/t-disk-1.qcow2 -o size=12G,preallocation=full
```

- The difference between a thin disk and a fully preallocated one is related to performance.

### List the virtualmachine conn info

```
sudo virsh domdisplay --domain vm01
```

### Set up the virtual machine with remote access

```
sudo virt-install --hvm --name=vm02 --vcpus=1 --ram=1042 --os-type=linux --os-variant=centos7.0 --disk path=/var/lib/libvirt/images/thin-disk.qcow2 --cdrom=/var/lib/libvirt/images/CentOS-7-x86_64-Minimal-1908.iso --network=bridge:virbr0 --graphics spice,listen=0.0.0.0 --noautoconsole
```

### Check the port for the VM

```
sudo virsh domdisplay --domain vm01
```

### Open the port for the VM

```
sudo firewall-cmd --add-port 5901/tcp --permanent
sudo firewall-cmd --reload
```

### We are running virsh locally

- But we can do this on remote hosts

```
sudo virsh net-list
# is equal to
sudo virsh -c qemu:///system net-list
```

### Connect remotely to virsh

```
sudo virsh -c qemu+ssh://root@IP_ADDRESS_OF_REMOTE_FIRSH/system
```