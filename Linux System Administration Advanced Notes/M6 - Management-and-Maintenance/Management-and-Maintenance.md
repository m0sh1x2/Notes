# Management and Maintenance

- Monitoring
    - Monitor and measure equipment and services
- Management
    - Group your hosts and services for easier monitoring
- Notifications
    - Receive prompt notifications upon state changes
- Actions
    - Take actions in response to state changes


- Real-time queries of OS counters
- (Local) Log files processing
- Centralized Log Files Collection via SYSLOG
    - 1) Works on 514/udp or 1468/tcp
    - 2) Messages have 3 components – facility, severity level, and message
- Simple Network Management Protocol (SNMP)
    - 1) Works on 161/udp + 162/udp 
    - 2) Alternatively can use 10161/udp + 10162/udp
    - 3) There are three versions - SNMPv1, SNMPv2, and SNMPv3
    - 4) Information is organized in management information base (MIB) objects
    - 5) Information is exchanged via Get requests and Trap answers

## Solutions

- Local real-time or batch tools (vmstat, sysstat, …)
    - Nagios
    - Zabbix
    - Sensu
    - Prometheus

- Simple solutions (collectd, …)
    - Icinga
    - Cacti
    - Sysdig
    - Observium

## Nagios

- Key Characteristics
    - Windows Monitoring
    - Linux Monitoring
    - Server Monitoring
    - Open Source(+ community ediiton)
    - Application Monitoring
    - SNMP Monitoring
    - Log Monitoring
    - Extensible

Host->Service->Command

## Nagios Object Definition

```
define <OBJECT-TYPE> {
	object_name		Short name, used for reference
	alias			Descriptive name
	use				Template to use
	...				Other specific attributes
}
```

<OBJECT-TYPE> can be host, hostgroup, service, servicegroup, command, contact, contactgroup, or timeperiod

## Observium

## Key Characteristics

- Auto discovery and registration of devices
- Supports CDP, LLDP, FDP, EDP, and OSPF for auto discovery
- Offers special applications for (Apache, MySQL, …)
- Visualization through dashboards
- API
- Community and Subscription (Pro or Ent) Editions

## Main Processes

- Polling
- Discovery
- Housekeeping

## Practice Monitoring


### Sysstat
```
dnf install sysstat -y
cat /etc/sysconfig/sysstat
sar # app provided by sysstat to read data
```

```
[root@m1 ~]# systemctl list-units --all | grep sysstat
  sysstat-collect.service                loaded    inactive dead      system activity accounting tool
  sysstat-summary.service                loaded    inactive dead      Generate a daily summary of process accounting
  sysstat.service                        loaded    inactive dead      Resets System Activity Logs
  sysstat-collect.timer                  loaded    inactive dead      Run system activity accounting tool every 10 minutes
  sysstat-summary.timer                  loaded    inactive dead      Generate summary of yesterday's process accounting
```

Find config files
```
[root@m1 ~]# find / -type f -name 'sysstat*.timer*' 2> /dev/null
/usr/lib/systemd/system/sysstat-summary.timer
/usr/lib/systemd/system/sysstat-collect.timer
```

Start service
```
[root@m1 ~]# systemctl enable --now sysstat^C
[root@m1 ~]# systemctl status sysstat
```

TODO: Check the files

### Nagios

```
dnf install epel-release
yum install dnf-plugins-core
dnf config-manager --set-enabled PowerTools
dnf install nagios nagios-common nagios-selinux nagios-plugins-all
sudo systemctl enable --now httpd
sudo systemctl enable --now nagios
```

# Configuration Management

- Management efficiency
- Replicated environments
- Avoid Snowflake servers
- Version control
- Quick provisioning
- Quick recovery

## Popular Solutions

- Chef
- Puppet
- Salt
- Ansible

## Ansible

- No extra components
    - No agents, repositories, etc.
- Easy to learn and program
    - Uses YAML, structured, easy to read and write
- Secure by design
    - Uses OpenSSH and WinRM
- Open and extendable
    - Shell commands, Library (Ansible Galaxy)

## Inventory

- Defines and describes the environment
- Can be stored anywhere on the system
- More than one inventory file is allowed

## Configuration

- $ANSIBLE_CONFIG
- ./ansible.cfg
- ~/.ansible.cfg
- /etc/ansible/ansible.cfg 

They are not merged, the first found is considered

## Modules

- Modules do the actual work
- Can be executed manually or in batches
- Also known as task plugins or library plugins
- Organized in categories (Command, Files, System, etc.)

## Plays & Playbooks

- Plays map hosts to tasks
- Each play can have multiple tasks
- Tasks call modules
- Tasks run sequentially

A playbook contains one or more plays

## Practice: Configuration Management

```
dnf install openssh-server -y
systemctl enable --now sshd
passwd
```

# Backup & Restore

## Backup Options

- Archiving with tar
- Mirror directories with rsync
- Image disks with dd
- Tape Devices
- Backup Suites

## tar

- Create archives with -c option
- Test or list archive contents with -t option
- Expand or extract archives with -x option
- To work with gzip compressed archives use -z option
- To work with bzip2 compressed archives use -j option
- To work with xz compressed archives use -J option

## rsync

- Locally between folders
- Remotely via SSH
- Remotely via rsync server (873/tcp)

## dd

- Input file or source is set with if=
- Output file or target is set with of=
- Block size is set with bs=
- Block count is set with count=

## Tape Devices

- Rewinding tape devices /dev/st*
- Non-rewinding tape devices /dev/nst*
- Control magnetic tapes with /bin/mt

## Backup Suites

- Amanda
- Bacula
- Relax and Recover (ReaR)

# Bacula

- Console - Allows the administrator or user to communicate with the Bacula Director
    - Director - Supervises all the backup, restore, verify and archive operations
        - Catalog -Software programs responsible for maintaining the file indexes and volume databases for all files backed up
        - File - The software program that is installed on the machine to be backed up
        - Storage - Software programs that perform the storage and recovery of the file attributes and data to the physical backup media or volumes
            - Backup device (Tape or Disk)
    - Monitor - Program that allows the administrator or user to watch current status of Bacula Directors, Bacula File Daemons and Bacula Storage Daemons