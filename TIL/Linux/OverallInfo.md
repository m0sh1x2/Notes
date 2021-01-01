# Overall

Source: https://opensource.com/article/20/12/linux-server


```shell
cat /etc/redhat-release
uname -a
hostnamectl
uptime
```

# Check other users

```shell
who
who -Hu
grep sh$ /etc/passwd
```

# Physical or virtual machine

```shell
dmidecode -s system-manufacturer
dmidecode -s system-product-name
lshw -c system | grep product | head -1
cat /sys/class/dmi/id/product_name
cat /sys/class/dmi/id/sys_vendor
```

# Hardware


```shell
lscpu or cat /proc/cpuinfo
lsmem or cat /proc/meminfo
ifconfig -a
ethtool <devname>
lshw
lspci
dmidecode
```

# Installed Software

```shell
rpm -qa
rpm -qa | grep <pkgname>
rpm -qi <pkgname>
yum repolist
yum repoinfo
yum install <pkgname>
ls -l /etc/yum.repos.d/
```

# Running processes and services

```shell
pstree -pa 1
ps -ef
ps auxf
systemctl
```

# Network Connections

```shell
netstat -tulpn
netstat -anp
lsof -i
ss
iptables -L -n
cat /etc/resolv.conf
```

# Kernel

```shell
uname -r
cat /proc/cmdline
lsmod
modinfo <module>
sysctl -a
cat /boot/grub2/grub.cfg
```

# Logs

```shell
dmesg
tail -f /var/log/messages
journalctl
```