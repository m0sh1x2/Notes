# Task 4
Research and implement VDO (Virtual Data Optimizer)

# Used Sources

- [Configure Virtual Data Optimizer (VDO) on CentOS 8](https://www.centlinux.com/2019/12/configure-virtual-data-optimizer-vdo-centos-8.html)

- [RHEL 8 Disk Optimisation Using VDO](https://www.youtube.com/watch?v=GG22ROk4tIM)

# Solution

Install the service and kernel modules:

```
dnf install kmod-kvdo vdo -y
```

Check the service status

```
[root@centos fs1]# systemctl status vdo
● vdo.service - VDO volume services
   Loaded: loaded (/usr/lib/systemd/system/vdo.service; enabled; vendor preset: enabled)
   Active: active (exited) since Tue 2020-04-14 14:06:27 EDT; 9h ago
 Main PID: 1284 (code=exited, status=0/SUCCESS)
    Tasks: 0 (limit: 11012)
   Memory: 0B
   CGroup: /system.slice/vdo.service

Apr 14 14:06:27 centos.server systemd[1]: Starting VDO volume services...
Apr 14 14:06:27 centos.server systemd[1]: Started VDO volume services.
```

Create the VDO drive:

```
[root@centos fs1]# sudo vdo create --name=vdo1 --device=/dev/sdd --vdoLogicalSize=1T
Creating VDO vdo1
Starting VDO vdo1
Starting compression on VDO vdo1
VDO instance 0 volume is ready at /dev/mapper/vdo1
```

Makefs

```
[root@centos fs1]# mkfs.xfs -K /dev/mapper/vdo1 
meta-data=/dev/mapper/vdo1       isize=512    agcount=4, agsize=67108864 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0         =                       reflink=1
data     =                       bsize=4096   blocks=268435456, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=131072, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

Mount the drive

```
mount /dev/mapper/vdo1 /mnt/vdo1/
```

Add to fstab

```
# Append to fstab
/dev/mapper/vdo1        /mnt/vdo1       xfs     defaults,x-systemd.req=vdo.service,discard      0 0
```

Re-mount and check status

```
[root@centos fs1]# mount -av
/                        : ignored
/boot                    : already mounted
/boot/efi                : already mounted
swap                     : ignored
/mnt/vdo1                : already mounted
```

Test the deduplication:


Create a 1 gig file

```
[root@centos vdo1]# dd if=/dev/urandom of=largefile bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 6.22115 s, 169 MB/s
```

Check the VDO stats

```
[root@centos vdo1]# vdostats --human-readable
Device                    Size      Used Available Use% Space saving%
/dev/mapper/vdo1         20.0G      5.0G     15.0G  24%           33%
```

Copy the large file

```
sudo cp largefile largefile1
sudo cp largefile largefile2
sudo cp largefile largefile3
```

Check the VDO stats

```
[root@centos vdo1]# vdostats --human-readable
Device                    Size      Used Available Use% Space saving%
/dev/mapper/vdo1         20.0G      5.0G     15.0G  24%           77%
```

Check the files

```
[root@centos vdo1]# ls -la
total 4096000
drwxr-xr-x. 2 root root         77 Apr 15 00:40 .
drwxr-xr-x. 4 root root         33 Apr 15 00:13 ..
-rw-r--r--. 1 root root 1048576000 Apr 15 00:39 largefile
-rw-r--r--. 1 root root 1048576000 Apr 15 00:40 largefile1
-rw-r--r--. 1 root root 1048576000 Apr 15 00:40 largefile2
-rw-r--r--. 1 root root 1048576000 Apr 15 00:40 largefile3
```