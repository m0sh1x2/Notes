# Task 1
Research and implement a RAID configuration with LVM

# Used Sources
- https://linuxhint.com/install_lvm_centos7/
- https://www.agix.com.au/how-to-work-with-lvm-raid-on-centos-7-a-working-example/


# Architecture
- Hyper-V - CentOS 8 VM
- 4x Drives 20GB

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
sudo lvcreate --type raid6 -i 5 -I 16 -l 100%FREE -n storageVolumeLVM storage
```

```
sudo parted -s /dev/sdb -- mklabel msdos mkpart primary 2048s -0m set 1 raid on
sudo parted -s /dev/sdc -- mklabel msdos mkpart primary 2048s -0m set 1 raid on
sudo parted -s /dev/sdd -- mklabel msdos mkpart primary 2048s -0m set 1 raid on
sudo parted -s /dev/sde -- mklabel msdos mkpart primary 2048s -0m set 1 raid on
sudo parted -s /dev/sdf -- mklabel msdos mkpart primary 2048s -0m set 1 raid on
```