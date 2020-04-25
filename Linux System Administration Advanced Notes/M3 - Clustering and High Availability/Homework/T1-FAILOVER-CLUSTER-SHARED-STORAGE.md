# Task 1
Research and implement two node failover cluster that hosts a web site served by shared (any form) clustered storage

# Used Sources

- [How To Set Up an Apache Active-Passive Cluster Using Pacemaker on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-apache-active-passive-cluster-using-pacemaker-on-centos-7)
- [How to install Apache on RHEL 8 / CentOS 8 Linux](https://linuxconfig.org/installing-apache-on-linux-redhat-8)
- 

# Solution

## Arechitecture

- CentOS Server as Load Balancer
    - IP: 192.168.1.140
- CentOS Server as Node 1
    - IP: 192.168.1.141
- CentOS Server as Node 2
    - IP: 192.168.1.142

/etc/hosts
```
192.168.1.140 centos01
192.168.1.141 centos02
192.168.1.142 centos03
```

Install Apache on the 2nd and 3rd server:

```
sudo yum install httpd -y
```

Configure /service-status for the 2nd and 3rd server:

```bash
sudo vi /etc/httpd/conf.d/status.conf
# File Contents:
<Location /server-status>
   SetHandler server-status
</Location>
```

Enable httpd:

```bash
sudo systemctl enable httpd --now
sudo firewall-cmd --add-service http –permanent
sudo firewall-cmd --reload
```

