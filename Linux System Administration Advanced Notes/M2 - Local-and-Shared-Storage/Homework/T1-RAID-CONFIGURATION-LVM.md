# Task 1
Research and implement a RAID configuration with LVM

# Used Sources
- https://linuxhint.com/install_lvm_centos7/
- https://www.agix.com.au/how-to-work-with-lvm-raid-on-centos-7-a-working-example/


# Architecture
- Hyper-V - CentOS 8 VM
- 5x Drives 20GB

# Solution Steps


Wipe the drives required for the LVM raid config:

```
sudo wipefs --all /dev/sd[b-f]
```

Create physical volumes:

```
sudo pvcreate /dev/sd[b-f]
```

Check the drives:

```
[m0sh1x2@centos ~]$ sudo pvscan 
  PV /dev/sda3   VG cl              lvm2 [23.41 GiB / 0    free]
  PV /dev/sdb                       lvm2 [20.00 GiB]
  PV /dev/sdc                       lvm2 [20.00 GiB]
  PV /dev/sdd                       lvm2 [20.00 GiB]
  PV /dev/sde                       lvm2 [20.00 GiB]
  PV /dev/sdf                       lvm2 [20.00 GiB]
  Total: 6 [123.41 GiB] / in use: 1 [23.41 GiB] / in no VG: 5 [100.00 GiB]
```

Creathe the group storage:

```
[m0sh1x2@centos ~]$ sudo vgcreate storage /dev/sd[b-e]
  Volume group "storage" successfully created
```

Check the group:
```
[m0sh1x2@centos ~]$ sudo pvscan
  PV /dev/sdb    VG storage         lvm2 [<20.00 GiB / <20.00 GiB free]
  PV /dev/sdc    VG storage         lvm2 [<20.00 GiB / <20.00 GiB free]
  PV /dev/sdd    VG storage         lvm2 [<20.00 GiB / <20.00 GiB free]
  PV /dev/sde    VG storage         lvm2 [<20.00 GiB / <20.00 GiB free]
  PV /dev/sda3   VG cl              lvm2 [23.41 GiB / 0    free]
  PV /dev/sdf                       lvm2 [20.00 GiB]
  Total: 6 [123.39 GiB] / in use: 5 [103.39 GiB] / in no VG: 1 [20.00 GiB]
```

Create RAID5:

```
[m0sh1x2@centos ~]$ sudo lvcreate --type raid6 -i 3 -l 100%FREE -n storageVolumeLVM storage
  Using default stripesize 64.00 KiB.
  Rounding size (25595 extents) down to stripe boundary size (25593 extents)
  Logical volume "storageVolumeLVM" created.
```

Check the drives

```
[m0sh1x2@centos storage]$ lsblk
NAME                                MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                                   8:0    0   25G  0 disk
├─sda1                                8:1    0  600M  0 part /boot/efi
├─sda2                                8:2    0    1G  0 part /boot
└─sda3                                8:3    0 23.4G  0 part
  ├─cl-root                         253:0    0 21.4G  0 lvm  /
  └─cl-swap                         253:1    0    2G  0 lvm  [SWAP]
sdb                                   8:16   0   20G  0 disk
├─storage-storageVolumeLVM_rmeta_0  253:2    0    4M  0 lvm
│ └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
└─storage-storageVolumeLVM_rimage_0 253:3    0   20G  0 lvm
  └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
sdc                                   8:32   0   20G  0 disk
├─storage-storageVolumeLVM_rmeta_1  253:4    0    4M  0 lvm
│ └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
└─storage-storageVolumeLVM_rimage_1 253:5    0   20G  0 lvm
  └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
sdd                                   8:48   0   20G  0 disk
├─storage-storageVolumeLVM_rmeta_2  253:6    0    4M  0 lvm
│ └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
└─storage-storageVolumeLVM_rimage_2 253:7    0   20G  0 lvm
  └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
sde                                   8:64   0   20G  0 disk
├─storage-storageVolumeLVM_rmeta_3  253:8    0    4M  0 lvm
│ └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
└─storage-storageVolumeLVM_rimage_3 253:9    0   20G  0 lvm
  └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
sdf                                   8:80   0   20G  0 disk
├─storage-storageVolumeLVM_rmeta_4  253:10   0    4M  0 lvm
│ └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
└─storage-storageVolumeLVM_rimage_4 253:11   0   20G  0 lvm
  └─storage-storageVolumeLVM        253:12   0   60G  0 lvm  /mnt/storage
```

Set the File System

```
sudo mkfs.ext4 /dev/storage/storageVolumeLVM
```

Mount the drive

```
sudo mount /dev/storage/storageVolumeLVM /mnt/storage/
```

Mount the drive on boot

```
mkdir /mnt/storage/
## Append to /etc/fstab
/dev/storage/storageVolumeLMV /mnt/storage ext4 defaults 0 0
```