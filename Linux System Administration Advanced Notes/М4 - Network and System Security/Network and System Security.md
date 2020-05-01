# М4 - Network and System Security Notes

# Kernel Parameters

## Current State of a Running Linux System

- Available vai the procfs virtual filesystem mounted at /proc
    - There are both read-only and writable items
    - Writeble items are in /proc/sys
    - Some of the namespaces are kernel, net, etc.
    - Information can be found via man 5 proc

## Working with Kernel Variables

- Can be read and writen via eco and sysctl
- Persistent configuration is stored in /etc/sysctl.conf or /etc/sysctl.d/
- To apply set of all configuration changes we can use sysctl -p or sysctl --system

# Resource Limits

- The pam_limits module sets limits on the system resources that can be obtained in a user-session
    - They can be either soft or hard
    - Can be set for 
        - user
        - group
        - everyone
    - Include open files, file locks, max number of processes, etc
    - Controlled via the bash built in ulimit
    - Persistent configuration is stored in /etc/secuirty/limits.conf and /etc/security/limits.d/ (files are read in alphabetical order)

# Access Control Lists

## File Mode (Standard Premissions)

- Premissions are read, write and execute
- Premissions are for user, group and others
- Represented in octal and symbolic notation
- Everyday tools include ls, stat, chown, chgrp and chmod
- Default premissions are configured via umask

## FIle Mode (Special Premissions)

- Sticky bit - Typically is set on folders
    - chmod o+t /folder
- SGID bit - Can be set on folders and files
    - chmod g+s /folder
- SUID bit - Usually is set on executable files
    - chmod u+s file.sh

Access Control Lists

- Overcome file, mode limitations, i.e. single user and single group
- System module loaded during boot process
- Controlled on filesystem level via options when mounting
- Utilities installed via package


Acess Control Lists Rules

- setfacl -m [d:]principal:[principal-name:]rights /path/to/object
    - Rules can be default (set on folder level) or specific
    - Multiple rules can be set simultaneously
    - Principal can be user (u), group (g), or others (o)
    - Rights are set via symbolic notation and can be r, w, x, - 

## Special Access Control Lists

- NFS ACL
    - nfs4_getfacl / nfs4_setfacl
    - Separate package
    - Implemented by the NFS Server and doesn’t rely on the filesystem

- CIFS ACL
    - getcifsacl / setcifsacl
    - Separate package
    - Easier with winbind
    - Implemented by the Samba Server and doesn’t rely on the filesystem

Those access control lists are for NFS and Samba.


# Practice: Security 101

```
cat /proc/cpuinfo
man 5 procfs # Info
sudo dnf install tree

[m0sh1x2@centos04 ~]$ tree -L 1 /proc/sys
/proc/sys
├── abi
├── crypto
├── debug
├── dev
├── fs
├── kernel
├── net
├── user
└── vm

[m0sh1x2@centos04 ~]$ cat /proc/sys/kernel/{host,domain}name
centos04
(none)

sysctl -a

# Regex check for all values containing name

[m0sh1x2@centos04 ~]$ sysctl -ar name$
kernel.domainname = (none)
kernel.hostname = centos04
kernel.sched_domain.cpu0.domain0.name = MC
kernel.sched_domain.cpu1.domain0.name = MC
kernel.sched_domain.cpu2.domain0.name = MC
kernel.sched_domain.cpu3.domain0.name = MC

[m0sh1x2@centos04 ~]$ sudo sysctl -w kernel.domainname='demo'
kernel.domainname = demo


[m0sh1x2@centos04 sysctl.d]$ ls
99-sysctl.conf
[m0sh1x2@centos04 sysctl.d]$ ll
total 0
lrwxrwxrwx. 1 root root 14 Apr  9 17:52 99-sysctl.conf -> ../sysctl.conf
[m0sh1x2@centos04 sysctl.d]$ vi 99-sysctl.conf 

# The 99 number is because it must be checked last
```

Stop ICMP requests

```
# Find the param for ICMP
[m0sh1x2@centos04 sysctl.d]$ sysctl -ar icmp
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_errors_use_inbound_ifaddr = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.icmp_msgs_burst = 50
net.ipv4.icmp_msgs_per_sec = 1000
net.ipv4.icmp_ratelimit = 1000
net.ipv4.icmp_ratemask = 6168
net.ipv6.icmp.ratelimit = 1000
net.netfilter.nf_conntrack_icmp_timeout = 30
net.netfilter.nf_conntrack_icmpv6_timeout = 30


# IPv4
[m0sh1x2@centos04 sysctl.d]$ sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1
net.ipv4.icmp_echo_ignore_all = 1

# IPv6
[m0sh1x2@centos04 sysctl.d]$ sudo sysctl -w net.ipv6.icmp_echo_ignore_all=1
net.ipv4.icmp_echo_ignore_all = 1

```

Check pam limits locations

```bash
[m0sh1x2@centos04 sysctl.d]$ grep pam_limits.so /etc/pam.d/*
/etc/pam.d/fingerprint-auth:session     required                                     pam_limits.so
/etc/pam.d/password-auth:session     required                                     pam_limits.so
/etc/pam.d/runuser:session              required        pam_limits.so
/etc/pam.d/system-auth:session     required                                     pam_limits.so
```

ulimit

```
ulimit --help
```

Check soft and hard limits:

```
[m0sh1x2@centos04 sysctl.d]$ ulimit -Su
6885
[m0sh1x2@centos04 sysctl.d]$ ulimit -Hu
6885
```

Set soft limit

```
ulimit -Su 4000
```

Set max logins

```
sudo vim /etc/security/limits.conf

# Set max logins:
sudo vi /etc/security/limits.d/10-maxlogins.conf
*       -       maxlogins       2
```

Check premissions 

```
umask
touch file
mkdir dir
ls -l
stat -c %a dir
stat -c %A dir
```

```
[m0sh1x2@centos04 sysctl.d]$ sudo find / -type f -perm -2000
find: ‘/proc/3012/task/3012/fdinfo/6’: No such file or directory
find: ‘/proc/3012/fdinfo/5’: No such file or directory
/usr/bin/write
/usr/bin/locate
/usr/libexec/utempter/utempter
/usr/libexec/openssh/ssh-keysign
```

```
[m0sh1x2@centos04 sysctl.d]$ sudo find / -type f -perm -4000
find: ‘/proc/3015/task/3015/fdinfo/6’: No such file or directory
find: ‘/proc/3015/fdinfo/5’: No such file or directory
/usr/bin/chage
/usr/bin/gpasswd
/usr/bin/newgrp
/usr/bin/su
/usr/bin/mount
/usr/bin/umount
/usr/bin/crontab
/usr/bin/pkexec
/usr/bin/chfn
/usr/bin/chsh
/usr/bin/at
/usr/bin/sudo
/usr/bin/passwd
/usr/sbin/grub2-set-bootflag
/usr/sbin/pam_timestamp_check
/usr/sbin/unix_chkpwd
/usr/lib/polkit-1/polkit-agent-helper-1
/usr/libexec/dbus-1/dbus-daemon-launch-helper
/usr/libexec/cockpit-session
/usr/libexec/sssd/krb5_child
/usr/libexec/sssd/ldap_child
/usr/libexec/sssd/selinux_child
/usr/libexec/sssd/proxy_child
```

[m0sh1x2@centos04 sysctl.d]$ ls -al /usr/bin/passwd 
-rwsr-xr-x. 1 root root 34928 May 11  2019 /usr/bin/passwd

Access control lists 

```
#Checkl them out

grep -i acl /boot/config-4.18.0-147.*

sudo setfacl -m u:m0sh1x2:rwx /secret/
sudo setfacl -m d:u:m0sh1x2:rwx /secret

[m0sh1x2@centos04 sysctl.d]$ getfacl /secret
getfacl: Removing leading '/' from absolute path names
# file: secret
# owner: root
# group: root
user::rwx
user:m0sh1x2:rwx
group::---
mask::rwx
other::---

[m0sh1x2@centos04 sysctl.d]$ sudo setfacl -m d:u:m0sh1x2:rwx /secret
[m0sh1x2@centos04 sysctl.d]$ getfacl /secret
getfacl: Removing leading '/' from absolute path names
# file: secret
# owner: root
# group: root
user::rwx
user:m0sh1x2:rwx
group::---
mask::rwx
other::---
default:user::rwx
default:user:m0sh1x2:rwx
default:group::---
default:mask::rwx
default:other::---

set setfacl -x u:demo1 /secret/file
getfacl /secret/file
```

# Security 102 - Context-based security

## DAC vs MAC

- Discritionary Access Control 
    - Existing OS level access control
    - Object owners have complete control

- Mandatory Access Control
    - Additional layer
    - Object owners are obligated to honor MAC rules
    - Considered after the DAC rules are evaluated

## MAC Solutions

- Security Enchanced Linux (SELinux)
- Application Armor(AppArmor)
- Simplified Mandatory Access Control Kernel (SMACK)
- Tomoyo L  inux

All based on the Linux Security Modules(LSM)

## SELinux Introduction

- Objects
    - Everything on a Linux system
        - Process
        - User
        - Files
        - Folders
        - Sockets, etc.
- Labels(Security context)
    - Attributes of an object and consists of four parts: User: Role: Type: Level
    - Type is known as domain when in context of a process.

- Type Enforcements
    - The type of a source domain of process must be compatible with the target type

## SELinux Modules

- Disabled
    - SELinux turned off
    - No enchancing
    - Only DAC is working

- Permisive
    - SELinux turned on
    - Policy loaded
    - Not enforcing the policy
    - Logs what would have been denied
    - Labels objects

- Enforcing
    - SELinux turned on
    - Policy loaded
    - Enforcing the policy

## SELinux Facts, Files and Tools

    - Main configuration file: /etc/selinux/config
    - Default mode: enforcing
        - Available modes:
        - permissive 
        - disabled
    - Context change tool: chcon
    - Context restore tool: restorecon
    - Main configuration folders:
        - /etc/selinux
        - /usr/share/selinux
        - /var/lib/share/selinux
    - Default policy: target
    - Available policies:
        -minimum 
        - mls
    - Other tools: 
        - getenforce, setenforce
        - sestatus, seinfo, semodule
        - sesearch, etc.

## SELinux Booleans

    - Simple way to adjust behavior of SELinux
    - Values can be read with getsebool and written with setsebool
    - Additionally the semanage command can be user get and set values
    - Help can be retrieved with man semanage-boolean
    - Can be on | off / 1 | 0 / true | false

## SELinux Logs

- auditd != running /var/log/messages
- auditd == running /var/log/audit/audit.log
- auditd == running && setroubleshootd == running
    - /var/log/messages
    - /var/log/audit/audit.log

## SELinux Additional Tools and Functions
- audit2allow - Generates policy allow/dontaudit rules from logs of denied operations
- audit2why - Translates audit messages into  a description of why the access was denied
- sealert - The user interface component to the setroubleshoot system
- Permissive domains - Are a way to debug our system without compromising the whole system

# Application Armor(AppArmor)

## AppArmor Introduction

- Restricts programs’ capabilities with per-program profiles
- Extensible via manually created modules or ones, created in learning mode 
- Works with file paths and it is filesystem agnostic
- Supported by all major distributions


- Profiles are stored in /etc/apparmor.d 
    - Disabled ones are symlinked in /etc/apparmor.d/disable
- Tools are available via apparmor-utils package
    -Extra profiles can be installed via apparmor-profiles-extra
- Some of tools are aa-enforce, aa-status, aa-autodep, etc.
    - There is a second (symlinked) set of tools

# Practice security

## SELinux

```bash
sudo dnf install setools-console policycoreutils-python-utils
sudo getenforce

[m0sh1x2@centos04 ~]$ sudo sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      31
```

Set premissive mode

```
[m0sh1x2@centos04 ~]$ sudo setenforce 0
[m0sh1x2@centos04 ~]$ sudo sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   permissive
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      31
```

/etc/selinux/config 

```
[m0sh1x2@centos04 ~]$ cat /etc/selinux/config 

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected. 
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

Save selinux config after reboot
- We can do this if we set it as an option at boot


```
[m0sh1x2@centos04 ~]$ ls -lZ /etc/hosts
-rw-r--r--. 1 root root system_u:object_r:net_conf_t:s0 158 Sep 10  2018 /etc/hosts
```

```
sudo dnf install selinux-policy-mls

sudo chcon -t user_home_t /var/www/html/index.html
systemctl status auditd

sudo grep AVC /var/log/audit/audit.log

# Partial log contents:
type=AVC msg=audit(1588323249.564:522): avc:  denied  { read } for  pid=4683 comm="httpd" name="index.html" dev="dm-0" ino=143258 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=0

```

Audit tool:

```
[m0sh1x2@centos04 html]$ sudo audit2allow -wa
type=AVC msg=audit(1588322998.793:497): avc:  denied  { read } for  pid=4684 comm="httpd" name="index.html" dev="dm-0" ino=143258 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=0
        Was caused by:
        The boolean httpd_read_user_content was set incorrectly. 
        Description:
        Allow httpd to read user content

        Allow access by executing:
        # setsebool -P httpd_read_user_content 1
type=AVC msg=audit(1588323249.564:522): avc:  denied  { read } for  pid=4683 comm="httpd" name="index.html" dev="dm-0" ino=143258 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=0
        Was caused by:
        The boolean httpd_read_user_content was set incorrectly. 
        Description:
        Allow httpd to read user content

        Allow access by executing:
        # setsebool -P httpd_read_user_content 1
```

Generate a custom package:

```
[m0sh1x2@centos04 html]$ sudo audit2allow -aM httpd.my
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i httpd.my.pp
```

## AppArmor Practice

```
sudo apt install apparmor-utils

```


# Linux Audit Overview

- It is all about who did what and when
- Listens for events reported by the kernel and logs them to a log file
- Allows the tracking of both UID and AUID
    - Can track files and folders access and syscalls

# Linux Audit Files and Tools

- Processed events are stored in /var/log/audit/audit.log
- Configuration information and rules are stored in /etc/audit/auditd.conf and /etc/audit/rules.d/
- Main tools include auditctl, ausearch, etc.

# Packet Filtering

## Linux FIrewall(firewalld)

- Easy to use solution with wide adoption and support for zones, services, rich rules, etc.
- Separate runtime and permanent configuration
- Main configuration file:
-   /etc/firewalld/firewalld.conf
- Configuration directories:
    - /etc/firewalld
    - /usr/lib/firewalld

## netfilter Overview

- Packet filtering framework inside the Linux 2.4.x and later kernel
- Set of hooks inside the Linux kernel that allows kernel modules to register callback functions with the network stack
- Enables packet filtering, network address [and port] translation (NA[P]T) and other packet mangling
- A registered callback function is then called back for every packet that traverses the respective hook within the network stack

## netfilter Terminology

- Each table has a chain
- Each chain has rules
- Each rule has a match
- Each rule has a target
- Default rule captures all packets that do not conform any rule

## netfilter Tables and Chains

- Tables are collections of chains
- Chains determine what time in the packet flow it is evaluated
    - PREROUTING (before routing decision)
    - INPUT (delivered to local process)
    - FORWARD (routed, non-local packets)
    - OUTPUT (sent packets, from local processes)
    - OSTROUTING (after routing decision)

## netfilter Targets and States

- Matches describe interesting packets
    - Targets
    - ACCEPT (allow packet)
    - REJECT (replies prohibited)
    - DROP (drops, no replies)
    - LOG (record info to file)
- States are NEW, ESTABLISHED, RELATED

## netfilter Default Tables and Chains

- FILTER
    - INPUT
    - FORWARD
    - OUTPUT
- NAT
    - PREROUTING
    - OUTPUT
    - POSTROUTING
- MANGLE
    - PREROUTING
    - INPUT
    - FORWARD
    - OUTPUT
    - POSTROUTING

## iptables

- iptables is the userspace command line program used to configure the Linux 2.4.x and later packet filtering ruleset
    - Listing the contents of the packet filter ruleset
    - Adding/removing/modifying rules in the packet filter ruleset
    - Listing/zeroing per-rule counters of the packet filter ruleset

## nftables
- nftables is the new packet classification framework that replaces the existing {ip,ip6,arp,eb}_tables infrastructure

It is available in Linux kernels >= 3.13
    - Comes with a new command line utility nft whose syntax is different to iptables
    - It also comes with a compatibility layer that allows to run iptables commands over the new nftables kernel framework
    - Provides generic set infrastructure that allows you to construct maps and concatenation

# Practice

```
sudo apt install auditd audispd-plugins
systemctl status audit
sudo auditctl -s # Status
sudo ausearch -m ADD_USER --start recent
sudo ausearch -m USER_LOGIN
ausearch -m
```

Watch for file changes:

```
sudo auditctl -w /secret.txt -p r -k super-secret
```


## nft

```
[m0sh1x2@centos04 html]$ sudo systemctl disable --now firewalld
Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
[m0sh1x2@centos04 html]$ sudo systemctl mask firewalld
Created symlink /etc/systemd/system/firewalld.service → /dev/null.
[m0sh1x2@centos04 html]$ sudo nft
nft: no command specified
[m0sh1x2@centos04 html]$ sudo nft 
httpd.my.pp  httpd.my.te  index.html   
[m0sh1x2@centos04 html]$ sudo nft flush ruleset
[m0sh1x2@centos04 html]$ sudo nft list ruleset
```

```
[m0sh1x2@centos04 html]$ sudo nft add table inet filter
[m0sh1x2@centos04 html]$ sudo nft add chain inet filter INPUT { type filter hook input priority 0  \; policy accept \; }
[m0sh1x2@centos04 html]$ sudo nft list tables
table inet filter
[m0sh1x2@centos04 html]$ sudo nft list ruleset
table inet filter {
        chain INPUT {
                type filter hook input priority 0; policy accept;
        }
}
```

```
[m0sh1x2@centos04 html]$ sudo nft add rule inet filter INPUT iif lo accept
[m0sh1x2@centos04 html]$ sudo nft add rule inet filter INPUT ct state established,related accept
[m0sh1x2@centos04 html]$ sudo nft add rule inet filter INPUT tcp dport {22, 80} accept
[m0sh1x2@centos04 html]$ sudo nft add rule inet filter INPUT counter
[m0sh1x2@centos04 html]$ sudo nft add rule inet filter INPUT drop
[m0sh1x2@centos04 html]$ sudo nft list ruleset
table inet filter {
        chain INPUT {
                type filter hook input priority 0; policy accept;
                iif "lo" accept
                ct state established,related accept
                tcp dport { ssh, http } accept
                counter packets 0 bytes 0
                drop
        }
}
```

```
[m0sh1x2@centos04 html]$ sudo nft --handle list ruleset
table inet filter { # handle 20
        chain INPUT { # handle 1
                type filter hook input priority 0; policy accept;
                iif "lo" accept # handle 2
                ct state established,related accept # handle 4
                tcp dport { ssh, http } accept # handle 6
                counter packets 0 bytes 0 # handle 8
                drop # handle 9
        }
}
```

```
[m0sh1x2@centos04 html]$ sudo nft insert rule inet filter INPUT handle 8 tcp dport 9090 accept
[m0sh1x2@centos04 html]$ sudo nft --handle list ruleset
table inet filter { # handle 20
        chain INPUT { # handle 1
                type filter hook input priority 0; policy accept;
                iif "lo" accept # handle 2
                ct state established,related accept # handle 4
                tcp dport { ssh, http } accept # handle 6
                tcp dport 9090 accept # handle 10
                counter packets 0 bytes 0 # handle 8
                drop # handle 9
        }
}
```

We are deleting rules with handle ID's

```
[m0sh1x2@centos04 html]$ sudo nft delete rule inet filter INPUT handle 10
[m0sh1x2@centos04 html]$ sudo nft --handle list ruleset
table inet filter { # handle 20
        chain INPUT { # handle 1
                type filter hook input priority 0; policy accept;
                iif "lo" accept # handle 2
                ct state established,related accept # handle 4
                tcp dport { ssh, http } accept # handle 6
                counter packets 0 bytes 0 # handle 8
                drop # handle 9
        }
}
```