# Local and Shared Storage

# Storage Types

1. Local
    - Internal
    - External
- aka. Direct attatched storage(DAS)

2. Remote
    - File-based - network-attatched storage(NAS)
    - Block-base - storage area network(SAN)

## Disks Innerworkings

- Each platter is split to circular tracks (A)
- Each track is split to sectors (C)
- A cluster (D) or allocation unit is the smallest logical amount of disk space that can be allocated to hold a file

## Disk Partitioning

There are two partitioning schemes.

- Master Boot Record (MBR)
    - Up to 4 primary or 3 primary + 1 extended( with multiple logical)
    - Volumes up to 2 terabytes

- GUID Partition Table (GPT)
    - Supports up to 128 primary partitions
    - Supports volumes up to 18 exabytes
    - Provides partition table protection
    - Requires UEFI

# Local Storage

## Device Mapper

- A framework provided by the Linux kernel for mapping physical block devices onto higher-level virtual block devices
- Foundation of the logical volume manager (LVM), software RAIDs and dm-crypt disk encryption
- Offers additional features such as file system snapshots
- Passes data from a virtual block device to another block device.
- Data can be also modified in transition

## Software RAID

Uses the Device Mapper

- mdadm is a Linux utility used to manage and monitor software RAID devices
- Supports
    - RAID configurations (0, 1, 4, 5, 6, 10)
    - Non-RAID configurations(linear, multipath, faulty, container)
- Standard naming convention for devices is /dev/md<n>
- Configuration is stored in /etc/mdadm.conf
- Can be monitored via the utility or /proc/mdstat
- Not suitable for /boot

## Blocks, Chunks and Stripes

- Block size
    - Linux block size is 4k
    - Device block size can be either 512 bytes or 4K
        - 512 bytes native or 512 bytes emulated
- Chunk size
    - Number of consecutive blocks written to each drive
    - It's multiple of the Linux 4K block size
- Stripe size
    - Number of chunks by the number of drives
    - Includes parity and/or mirror information of the data stored per stripe is usually less than the size of hte stripe.

## Common RAID Types

- Stripe (RAID 0)
```
mdadm --create /dev/md0 --level 0 --raid-devices 2 \
       /dev/sda1 /dev/sdb1
```
- Mirror (RAID 1)
```
mdadm --create /dev/md0 --level 1 --raid-devices 2 \
       /dev/sda1 /dev/sdb1
```
- Parity (RAID 5)
```
mdadm --create /dev/md0 --level 5 --raid-devices 3 \
       /dev/sda1 /dev/sdb1 /dev/sdc1
```

## Command Groups

- Assemble --assemble
- Create --create
- Grow --grow
- Manage [--manage]
- Monitor --monitor
- Build --build 
- Misc [--misc]

Misc and Manage can be used without the "--".

# Logical Volume Manager (LVM)

- A device mapper targets providing logical volume managment
- Physical Volume (PV) - Lowest Level
- Physical Extent (PE)
- Volume Group (VG) - Highest Level
- Fyle System (FS)
- Mount Point (MP)

## LVM Features
- Volume groups and logical volumes can be resized online
- Read only and read/write snapshots
    - Snapshots are not backups, we need a Backup Strategy
- Hybrid volumes which allow for using cache
    - Combine SSDs with HDDs
- Thin provisioning of logical volumes
- Multipathing
- RAID implementations
- Different high availability options

## Command Groups

The commands are grouped as well:

- Physical Volumes (PV)
    - pvcreate
    - pvremove
    - pvs
    - pvscan
    - pvdisplay

- Volume Groups (VG)
    - vgcreate
    - vgremove
    - vgextend
    - vgreduce
    - vgs
    - vgscan
    - vgdisplay

- Logical Volumes (LV)
    - lvcreate
    - lvremove
    - lvextend
    - lvs
    - lvscan
    - lvdisplay

# Local Storage Advanced Filesystems

## BTRFS
- Copy on Write (COW)
    - We are working with copies of the blocks.
    - Operations are written or not written
    - If there is an issue with power then we know which blocks are written and which are not
- Read-only and read/write snapshots
- Sub-volumes
- Compression and deduplicaiton
- Multiple device support (pooling and RAID)
- Eliminates the need of (hardware) raid volume manager
- Not very popular (default FS on SUSE/openSUSE)

## (Open)ZFS (on Linux)
- Copy on Write(COW)
- Read-only and read/write snapshots
- Compression and deduplication
- Multiple device support (pooling and RAID)
- Datasets can be file systems, volumes, snapshots or clones.
- Eliminates the need of (hardware) raid or volume manager
- Relatively popular(supported on multiple platforms)

# Practice: Local Storage
- MDAM. LVM2. ZFS

Create working directories
-p - no error if existing, make parent directories if needed
```
sudo mkdir -p /storage/{raid,lvm,nfs,samba}
```

List all direves
```
lsblk
```
Create the partition with lsblk

```bash
[m0sh1x2@centos ~]$ sudo fdisk /dev/sdb 

Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x315defee.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): 

Using default response p.
Partition number (1-4, default 1): 1
First sector (2048-41943039, default 2048): 
Last sector, +sectors or +size{K,M,G,T,P} (2048-41943039, default 41943039): 

Created a new partition 1 of type 'Linux' and of size 20 GiB.

Command (m for help): t
Selected partition 1
[m0sh1x2@centos ~]$ sudo fdisk /dev/sdb 

Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x315defee.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): 

Using default response p.
Partition number (1-4, default 1): 1
First sector (2048-41943039, default 2048): 
Last sector, +sectors or +size{K,M,G,T,P} (2048-41943039, default 41943039): 

Created a new partition 1 of type 'Linux' and of size 20 GiB.

Command (m for help): t
Selected partition 1
```

Other way is to use parted:

```bash
sudo parted -s /dev/sdc -- mklabel msdos mkpart primary 2048s -0m set 1 raid on

sudo parted -s /dev/sdd -- mklabel msdos mkpart primary 2048s -0m set 1 raid on

sudo parted -s /dev/sde -- mklabel msdos mkpart primary 2048s -0m set 1 raid on
```

Check if everything is set after that:

```
sudo parted -s /dev/sde -- mklabel msdos mkpart primary 2048s -0m set 1 raid on
```

Install required pacakges:

```
sudo dnf install mdadm
```

## Create RAID 0 

```
sudo mdadm --create /dev/md0 --level 0 --raid-devices 2 /dev/sdb1 /dev/sdc1
```

Check if everything is ok:

```
cat /proc/mdstat

# Output:

Personalities : [raid0] 
md0 : active raid0 sdc1[1] sdb1[0]
      41906176 blocks super 1.2 512k chunks
      
unused devices: <none>
```

Set the default chunk size to 4k:

```
[m0sh1x2@centos ~]$ sudo mdadm --stop /dev/md0
mdadm: stopped /dev/md0
[m0sh1x2@centos ~]$ sudo mdadm --zero-superblock /dev/sd{b,c}1

[m0sh1x2@centos ~]$ sudo mdadm --create /dev/md0 --level 0 --chunk 4 --raid-devices 2 /dev/sdb1 /dev/sdc1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

[m0sh1x2@centos ~]$ cat /proc/mdstat 
Personalities : [raid0] 
md0 : active raid0 sdc1[1] sdb1[0]
      41906176 blocks super 1.2 4k chunks
      
unused devices: <none>
```

Get more detailed info for the array:

```
sudo mdadm --detail /dev/md0
```

## Set RAID 1 but with 64k chunk size

```
sudo mdadm --stop /dev/md0
sudo mdadm --create /dev/md0 --level 1 --chunk 64 --raid-devices 2 /dev/sdb1 /dev/sdc1
```

Note: This method might not be stable for boot.

## Create RAID 5

```
sudo mdadm --stop /dev/md0
sudo mdadm --zero-superblock /dev/sdb1 /dev/sdc1
sudo mdadm --create /dev/md0 --level 5 --chunk 64 --raid-devices 3 /dev/sd{b,c,d}
```

Note: This might take some time as the rebuild status might not be complete:

```
sudo mdadm --detail /dev/md0

# Output:
...
Rebuild Status : 81% complete
...
```

## Resize the raid array from 3 to 4 devices

- Before we begin we must create a backup.
- The file must also be out of the raid location
- We must also add /dev/sde1

Add /dev/sde1
```
sudo mdadm /dev/md0 --add /dev/sde1
```

We can check the device with:

```
sudo mdadm --detail /dev/md0
```

And can see that it is a spare device:

```
sudo mdadm --detail /dev/md0

# Output:
...
    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1

       4       8       65        -      spare   /dev/sde1
...
```

Enable the spare device and create a backup at /tmp/md0-grow.bak:

```
sudo mdadm /dev/md0 --grow --raid-devices 4 --backup-file /tmp/md0-grow.bak
```

Output:

```
mdadm: Need to backup 384K of critical section..
```

Check the status:

```
sudo mdadm --detail /dev/md0
```
Output:
```
Consistency Policy : resync

    Reshape Status : 0% complete
     Delta Devices : 1, (3->4)

              Name : centos.server:0  (local to host centos.server)
              UUID : e4bb41e1:d59a745e:f17d2014:66aa7018
            Events : 23

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1
       4       8       65        3      active sync   /dev/sde1
```

CLear the devices:

```
[m0sh1x2@centos ~]$ sudo mdadm --stop /dev/md0
mdadm: stopped /dev/md0
[m0sh1x2@centos ~]$ sudo mdadm --zero-superblock /dev/sd[b-e]1


[m0sh1x2@centos ~]$ sudo wipefs --all /dev/sd[b-e]
/dev/sdb: 2 bytes were erased at offset 0x000001fe (dos): 55 aa
/dev/sdb: calling ioctl to re-read partition table: Success
/dev/sdc: 2 bytes were erased at offset 0x000001fe (dos): 55 aa
/dev/sdc: calling ioctl to re-read partition table: Success
/dev/sdd: 2 bytes were erased at offset 0x000001fe (dos): 55 aa
/dev/sdd: calling ioctl to re-read partition table: Success
/dev/sde: 2 bytes were erased at offset 0x000001fe (dos): 55 aa
/dev/sde: calling ioctl to re-read partition table: Success
```

## LVM Setup

```
sudo pvcreate /dev/sd[b-e] -vv
```

Check the devices:
```
[m0sh1x2@centos ~]$ sudo pvs
  PV         VG Fmt  Attr PSize  PFree 
  /dev/sda3  cl lvm2 a--  23.41g     0 
  /dev/sdb      lvm2 ---  20.00g 20.00g
  /dev/sdc      lvm2 ---  20.00g 20.00g
  /dev/sdd      lvm2 ---  20.00g 20.00g
  /dev/sde      lvm2 ---  20.00g 20.00g
```

Create and check the new group:

```
[m0sh1x2@centos ~]$ sudo vgcreate vg_demo /dev/sdb
  Volume group "vg_demo" successfully created

[m0sh1x2@centos ~]$ sudo vgs
  VG      #PV #LV #SN Attr   VSize   VFree  
  cl        1   2   0 wz--n-  23.41g      0 
  vg_demo   1   0   0 wz--n- <20.00g <20.00g
```

Check for more detailed information:

```
[m0sh1x2@centos ~]$ sudo vgdisplay vg_demo
  --- Volume group ---
  VG Name               vg_demo
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <20.00 GiB
  PE Size               4.00 MiB
  Total PE              5119
  Alloc PE / Size       0 / 0   
  Free  PE / Size       5119 / <20.00 GiB
  VG UUID               GxmjHM-7zjh-9oOM-MgQF-qP3j-HRjH-TeqyMy
```

Add more -v, -vv, --vvv for more verbose output.

Extend the group:
```
sudo vgextend vg_demo /dev/sdc
sudo vgextend vg_demo /dev/sdd /dev/sde
```

Create a new partition with size of 1G:

```
sudo lvcreate -L 1G -n lv_demo vg_demo

# Output:

sudo lvs
  LV      VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root    cl      -wi-ao---- <21.41g                                                    
  swap    cl      -wi-ao----   2.00g                                                    
  lv_demo vg_demo -wi-a-----   1.00g  
```

Crete a smaller size 25M:

```
[m0sh1x2@centos ~]$ sudo lvcreate -L 25M -n lv_tiny vg_demo
  Rounding up size to full physical extent 28.00 MiB
  Logical volume "lv_tiny" created.
```

The size will be 28MiB as the extents cannot allocate a lowe value.

Remove the pratition:

```
sudo lvremove vg_demo/lv_tiny
```

Create the filesystem and mount the group:

```
sudo mkfs.ext4 /dev/vg_demo/lv_demo
sudo mount /dev/vg_demo/lv_demo /storage/lvm
```

Resize the partition to 10GB:

```
sudo lvextend -L 10G /dev/vg_demo/lv_demo
```

Alternative:

```
sudo lvextend -L +5G /dev/vg_demo/lv_demo
```

Resize the partition 2x times:

```
sudo lvextend -l 100%PVS /dev/vg_demo/lv_demo
```

lsblk output:

```
[m0sh1x2@centos ~]$ lsblk 
NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                 8:0    0   25G  0 disk 
├─sda1              8:1    0  600M  0 part /boot/efi
├─sda2              8:2    0    1G  0 part /boot
└─sda3              8:3    0 23.4G  0 part 
  ├─cl-root       253:0    0 21.4G  0 lvm  /
  └─cl-swap       253:1    0    2G  0 lvm  [SWAP]
sdb                 8:16   0   20G  0 disk 
└─vg_demo-lv_demo 253:2    0   80G  0 lvm  /storage/lvm
sdc                 8:32   0   20G  0 disk 
└─vg_demo-lv_demo 253:2    0   80G  0 lvm  /storage/lvm
sdd                 8:48   0   20G  0 disk 
└─vg_demo-lv_demo 253:2    0   80G  0 lvm  /storage/lvm
sde                 8:64   0   20G  0 disk 
└─vg_demo-lv_demo 253:2    0   80G  0 lvm  /storage/lvm
```

Resize the filesystem:

```
sudo resize2fs /dev/vg_demo/lv_demo
```

Test file writes:

```
echo "Hello!" | sudo tee /storage/lvm/hello.tx
```

Downsize the filesystem:

```
sudo umount /storage/lvm
sudo e2fsck -f /dev/vg_demo/lv_demo
sudo resize2fs /dev/vg_demo/lv_demo 5G
sudo lvreduce -L 5G dvg_demo/lv_demo
sudo lvreduce -L 5G vg_demo/lv_demo
sudo e2fsck -f /dev/vg_demo/lv_demo
# Mount the file system
sudo mount /dev/vg_demo/lv_demo /storage/lvm
```

We can describe the filesystem in two ways:

- with ```cat /etc/fstab```
- get the block id ```sudo blkid```

```
[m0sh1x2@centos ~]$ sudo umount /storage/lvm
[m0sh1x2@centos ~]$ sudo vgremove vg_demo --force
  Logical volume "lv_demo" successfully removed
  Volume group "vg_demo" successfully removed
[m0sh1x2@centos ~]$ sudo wipefs --all /dev/sd[b-e]
/dev/sdb: 8 bytes were erased at offset 0x00000218 (LVM2_member): 4c 56 4d 32 20 30 30 31
/dev/sdc: 8 bytes were erased at offset 0x00000218 (LVM2_member): 4c 56 4d 32 20 30 30 31
/dev/sdd: 8 bytes were erased at offset 0x00000218 (LVM2_member): 4c 56 4d 32 20 30 30 31
/dev/sde: 8 bytes were erased at offset 0x00000218 (LVM2_member): 4c 56 4d 32 20 30 30 31
```

## ZFS Setup

Add the repo:

```
sudo dnf install http://download.zfsonlinux.org/epel/zfs-release.el8_1.noarch.rpm
```

In order to avoid manual builds we can enable zfs-kmod:

```
sudo vi /etc/yum.repos.d/zfs.repo

# File contents:
# Change zfs enable 1 to 0
# Change zfs-kmod from 0 to 1

[zfs]
...
enabled=0
...

[zfs-kmod]
...
enabled=1
...
```

### Zfs autosetup after reboot(CentOS)

```
echo "zfs" | sudo tee -a /etc/modules-load.d/zfs.conf
```

Enable the ZFS Module:

```
sudo modprobe zfs
```

Set up a pool of 2 devices:

```
sudo zpool create -m /storage/zfs/ zfs-demo /dev/sdb /dev/sdc
```

List the pools:

```
sudo zpool status zfs-demo
```

Get info for the pool

```
sudo zfs list
```

Check the FS with ```mount -l```


Remove the pool

```
sudo umount /storage/zfs 
sudo zpool destroy zfs-demo
sudo wipefs --all /dev/sd[b-e]
```

# Shared storage

## Network File System (NFS)

- NFSv2
    - Mount requesta re granted per host; uses TCP and UDP
- NFSv3
    - Many bug-fixes over v2; can serve bigger files than 2GB
- NFSv3
    - Uses stateful TCP or Stream Control Transmission Protocol(SCTP)
    - Firewall-friendly, can listen only on 2049/tcp
    No need for rpc.mountd, rpc.lockd, rpc.statd, and portmap
    - Supports ACLs and Kerberos

### Configuration
- Main configuration file /etc/exports
- Each row is for one export and has the structure:
    - ```/exportdir client|ip-network(permissions) [client|ip-network(permissions)] ...```
- Premissions
    - ro/rw - read-only or read write
    - [no_]all_squash – maps all UID/GID to the anonymous user
    - noaccess – denies access to all folders bellow the stated

## Samba File Server

- Server Message Block(SMB) protocal was develobed by IBM, Microsoft and Intel in 1980s
- Microsoft’s Common Internet File System (CIFS) protocol is built on top of SMB protocol
- CIFS/SMB is used for file and printer sharing in Windows networks
- Samba is free SMB server that incorporates CIFS as well
- Samba can act as Active Directory domain member or controller
- Samba bridges the gap between Unix-like systems and Windows

## Samba Daemons and Ports

- Daemons
    - Main Samba service (smbd / smb.service)
    - NetBIOS name service (nmbd / nmb.service)
    - Winbind service (winbindd / winbind.service) for user and hostname resolution
- Ports
    - 137/udp for NetBIOS name service
    - 138/udp for NetBIOS datagram service
    - 139/tcp for NetBIOS  session service
    - 445/tcp for Samba over TCP/IP
- Configuration
    - Main configuration file is /etc/samba/smb.conf
    - File /etc/samba/smb.conf.example contains 
    - Resources are exposed via stanzas
    - Test configuration changes with testparm
    - Samba users are created in the OS and password is set via smbpasswd
    - Depending on the passdb backend directive the users are stored in
        - When set to smbpasswd, then /etc/samba/smbpasswd 
        - When set to tdbsam, then /var/lib/samba/private/passwd.tdb
    - Current users can be explored with pdbedit

# SMB vs NFS

- SMB/CIFS
    - Share
    - Map
- NFS
    - Export
    - Mount

# Practice: Shared Storage

## NFS

```
sudo dnf install nfs-utils
cat /etc/nfs.conf
sudo nfsconf --set nfsd vers4 y
sudo nfsconf --set nfsd vers2 n
sudo nfsconf --set nfsd udp n
sudo systemctl enable --now nfs-server.service
```

Check open ports

```
ss -4tl
```

Remove useless services:

```
sudo systemctl mask --now rpcbind.service rpcbind.socket rpc-statd
```

Check the open ports again:

```
ss -4tl
```

Finish up the server configuration:

```
sudo find /usr/share/doc -type f -name '*.txt' -exec cp {} /storage/nfs/share \;
sudo vi /etc/exports
sudo exportrtfs -rav
sudo exportfs -rav
cat /var/lib/nfs/etab 
sudo firewall-cmd --list-ports 
sudo firewall-cmd --list-services
sudo firewall-cmd --add-service nfs --permanent
sudo firewall-cmd --list-all
sudo firewall-cmd --reload
```

Set up the client:

```
sudo dnf install nfs-utils
sudo mount -t nfs4 server:/storage/nfs/share /mnt
# !!! /etc/hosts 192.168.1.135 server !!!
sudo mount -t nfs4
```

Enable at boot
```
sudo vi /etc/fstab

# Configure this: server://storage/nfs/share /theshare nfs4 defaults 0 0

# Test the setup and mount the new drive

sudo mount -va
```

Protect the access

```
sudo vi /etc/exports
# Set to IP
/storage/nfs/share 192.168.81.152(rw) 192.168.1.100(ro) 192.168.88.0/255.255.255.0
sudo exportfs -var
```

## Samba setup

```
sudo dnf install samba samba-client samba-common-tools -y
sudo systemctl enable --now smb
sudo firewall-cmd --add-service samba -permanent
sudo firewall-cmd --reload
sudo mkdir /storage/samba/public
sudo chown nobody:nobody /storage/samba/public/
sudo chmod 775 /storage/samba/public/
# Configure selinux access
sudo setsebool -P samba_export_all_ro=on samba_export_all_rw=on
sudo semanage fcontext -at public_content_rw_t "/storage/samba/public(/.*)?"
sudo restorecon /storage/samba/public
```

# Additional techniques

## Quotas

- EXT4
    - Control space usage on user and group level
    - Soft and hard limits on disk space (block) and file (inode) level
- XFS
    - Control space usage on user, group, and project level
    - Soft and hard limits on disk space (block) and file (inode) level
    - Allows for soften the hard limits (to avoid interruptions)
    - Has own xfs_quota tool, but generic ones can be used as well

## Disk Encryption

- Linux Unified Key Setup (LUKS) is a disk encryption solution
- Uses dm-crypt kernel module for block level encryption
- A password or a key can be used to open an encrypted device
- Predictable naming via /etc/crypttab
- Supported by many tools

## Automounting

- AutoFS provides automounting of removable media or network - shares when they are inserted or accessed
- Supports multiple devices and filesystems
- Managed via a set of configuration files
    - Main files are /etc/autofs.conf and /etc/auto.master
    - Auxiliary files /etc/auto.* and /etc/auto.master.d/

## Easier Local Storage Management

- Stratis provides ZFS/Btrfs-style features
- Integrates layers of existing technology - Linux’s device mapper subsystem, and the XFS filesystem
- The stratisd daemon manages collections of block devices, and provides a D-Bus API
- The stratis-cli provides a command-line tool stratis which itself uses the D-Bus API to communicate with stratisd

## Compression and Deduplication

- Virtual Data Optimizer (VDO) is the answer
- Provides a solution for transparent compression and deduplication layer
- Under filesystems, iSCSI or Ceph

## Secure Remote File Systems

- SSHFS allows us to mount remote file systems over SSH
- It is a FUSE-based (Filesystem in Userspace) filesystem client
- Easy to setup and use
- Supported by multiple platforms

# Practice: Additional Techniques

Configured the drives:

```
sudo parted -s /dev/sdb -- mklabel msdos mkpart primary 2048s -0m set 1
sudo parted -s /dev/sdb -- mklabel msdos mkpart primary 2048s -0m set 1

# Remember to wipe the partitions before that
sudo mkfs.ext4 /dev/sdb1

sudo mkfs.ext4 /dev/sdb1
sudo mkfs.xfs -f /dev/sdc1
lsblk 
sudo vi /etc/fstab 
ls -al /storage/
sudo mkdir /storage/{ext4,xfs}
sudo mount -av

# Fix selinux

sudo restorecon /storage/ext4/
sudo mount -av
```

## EXT4 Quota setup