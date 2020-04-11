# Tasks 1
Both of the taken solutions are located in this file.

# Research and implement an environment allowing for PXE installation of a VM under KVM

## Main Infrastructure - Hyper-V
- Hyper-V with Nested Virtualization
- Centos 8 Server GUI with Enabled KVM

## Nested Virtualization infrastructure
- KVM Host - TFTP and NetBoot Server
- vm1 - PXE Boot Ubuntu with [NetBoot](http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/)
- vm2 - PXE Boot Ubuntu with [NetBoot](http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/)
- vm3 - PXE Boot with - [netboot.xyz](https://netboot.xyz/downloads/)
- Internal default Nat Network - 192.168.122.2 - 192.168.122.254

## Research outcome:

There are a few architectures that can be used in order to implement the solution:

1. dnsmasq + tftp on the host machine or a machine on the network
2. tftp server on the main KVM Host and default/custom NAT configuration allowing tftp boot

I didn't manage to run the first soltuion but I managed the run the second one with TFTP server on the main Virtualization Host by editing the default network adapter allowing boot from the network.

I used quite a lot of sources in order to understand what is happening.

The top sources that helped me the most were:

- [Chapter 15. Network Booting with libvirt](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/virtualization_host_configuration_and_guest_installation_guide/chap-virtualization_host_configuration_and_guest_installation_guide-libvirt_network_booting)

- [How To Setup a TFTP server on CentOS 8 / RHEL 8 Linux](https://computingforgeeks.com/how-to-setup-a-tftp-server-on-centos-rhel-8/)

- [Configuring PXE Network Boot Server on CentOS 8](https://linuxhint.com/pxe_network_boot_centos8/)

- [KVM Cheat Sheet](https://blog.programster.org/kvm-cheatsheet)

- [The excercise files from the course](https://softuni.bg/trainings/2785/linux-system-administration-advanced%E2%80%93april-2020#lesson-14919)

- And some other useful articles that I have lost 😭

## Basic steps on deploying the solution

1. Basic Virtualization Host Setup
    * Enable Nested Virtualization
    * Install Centos 8 Server + GUI 
    * Install virtualization by follwoing the guide @virt
2. Set up a static IP for the host
    * nmtui-edit eth0
3. Install the TFTP server
    * tftp-server tftp
4. Get the netboot image
    * [Ubuntu Server NetBoot](http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amd64/current/images/netboot/netboot.tar.gz)
    * [Centos 8 NetBoot](http://mirrors.neterra.net/centos/8.1.1911/isos/x86_64/) - \images\pxeboot\
    * [netboot.xyz](https://netboot.xyz/downloads/)
5. Add the Virtual Machines
6. Install the OS via the network
7. Finish and re-organize the documentation of the task


## 1. Basic Virtualization Host Setup

I have just setup a clean Centos 8 Server + GUI under the default Hyper-V Switch:

![Centos 8 Server + GUI Setup](https://m0sh1x2.com/screenshots/mmc_HvBDuxkGPm.png)

## 2. Set up a static IP for the host

For some reason Hyper-V always updates the default IP of the eth0 interface.
Because of that I am setting it up to 172.26.135.104, this is not very important for the next tasks but it will save time if the machine reboots.

```
sudo nmtui-edit eth0
```

![Static IP Configuration](https://m0sh1x2.com/screenshots/vmconnect_wnbcW1TyVQ.png)

Now I continue over SSH.

## 3. Install the TFTP server

Main Source of commands - https://computingforgeeks.com/how-to-setup-a-tftp-server-on-centos-rhel-8/ 

### 3.1 Install the TFTP server

```
sudo dnf install -y tftp-server tftp
```

### 3.2 Copy the systemd to system configurations

```
sudo cp /usr/lib/systemd/system/tftp.service /etc/systemd/system/tftp-server.service
sudo cp /usr/lib/systemd/system/tftp.socket /etc/systemd/system/tftp-server.socket
```

### 3.3 Configure the tftp-server.service
```
sudo tee /etc/systemd/system/tftp-server.service<<EOF
[Unit]
Description=Tftp Server
Requires=tftp-server.socket
Documentation=man:in.tftpd

[Service]
ExecStart=/usr/sbin/in.tftpd -c -p -s /var/lib/tftpboot
StandardInput=socket

[Install]
WantedBy=multi-user.target
Also=tftp-server.socket
EOF
```

Explanation of "ExecStart=/usr/sbin/in.tftpd -c -p -s /var/lib/tftpboot":

```
-c : Allows new files to be created.
-p : Used to have no additional permissions checks performed above the normal system-provided access controls.
-s : Recommended for security and compatibility with older boot ROMs.
```

### 3.4 Start the TFTP server

```
sudo systemctl daemon-reload
sudo systemctl enable --now tftp-server
systemctl status tftp-server
```

Status Screenshot:

![TFTP Server Status](https://m0sh1x2.com/screenshots/MobaXterm_bcYhCWDOun.png)

## 4. Get the netboot image

### 4.1 Ubuntu Server NetBoot

```
cd /var/lib/tftpboot/
mkdir ubuntu && cd ubuntu
wget http://archive.ubuntu.com/ubuntu/dists/bionic-updates/main/installer-amdnetboot/netboot.tar.gz
tar xfz netboot.tar.gz
rm netboot.tar.gz
```

### 4.2 netboot.xyz ipxe config

```
cd cd /var/lib/tftpboot/
wget https://boot.netboot.xyz/ipxe/netboot.xyz.kpxe
```

## 5. Add the Virtual Machines

### 5.1 Add vm1 via Virtual Machine Manager
Video - https://m0sh1x2.com/screenshots/Mn9o5CqUi2.webm

### 5.2 Add vm2 via Cockpit
Video - https://m0sh1x2.com/screenshots/TjkbygrZ0S.webm

### 5.3 Add vm3 via cli

As far as I understand the only param that must be set is the --pxe - [Creating Guests with PXE](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/virtualization_host_configuration_and_guest_installation_guide/sect-virtualization_host_configuration_and_guest_installation_guide-guest_installation-installing_guests_with_pxe)

```
sudo virt-install \
--hvm \
--name=vm3 \
--vcpus=1 \
--ram=1042 \
--os-type=linux \
--os-variant=centos7.0 \
--disk path=/var/lib/libvirt/images/vm3.qcow2,size=12 \
--network=default --pxe --graphics spice --noautoconsole
```

Fortunately it boots without any issues:

![virt-install PXE boot](https://m0sh1x2.com/screenshots/vmconnect_5tugXFCSDu.png)

## 6. Configure the default network to allow DHCP boot over TFTP

### 6.1 Stop the network
```
sudo virsh net-destroy default
```
### 6.2 Edit the network

```
sudo virsh net-edit default
```

### 6.3 Edit the network for netboot.xyz configuration
FROM:
```xml
<network>
  <name>default</name>
  <uuid>0d02cd7c-8135-4775-a78c-eec38ca8d820</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:bc:ed:f4'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```
TO:

```xml
<network>
  <name>default</name>
  <uuid>0d02cd7c-8135-4775-a78c-eec38ca8d820</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:bc:ed:f4'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
      <bootp file='netboot.xyz.kpxe'/>
    </dhcp>
  </ip>
</network>
```

### 6.3 Edit the network for default NetBoot configuration

FROM:
```xml
<network>
  <name>default</name>
  <uuid>0d02cd7c-8135-4775-a78c-eec38ca8d820</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:bc:ed:f4'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```
TO:
```xml
<network>
  <name>default</name>
  <uuid>0d02cd7c-8135-4775-a78c-eec38ca8d820</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:bc:ed:f4'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <tftp root='/var/lib/tftpboot' />
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
      <bootp file='ubuntu/pxelinux.0' />
    </dhcp>
  </ip>
</network>
```

### 6.4 Start the network

```
sudo virsh net-start default
```

## 7. Install the OS via the network

Bacause of my limited storage I will only install a VM only on VM3

### 7.1 - VM1 and VM2 - Ubuntu NetBoot

Absolute miracle:

![VM1 and VM2 NetBoot](https://m0sh1x2.com/screenshots/vmconnect_nG8EUagRXa.png)


### 7.2 - VM3 - netboot.xyz boot

Facinating:
Video: https://m0sh1x2.com/screenshots/1dIvSIswxx.webm

That's all! Thanks!