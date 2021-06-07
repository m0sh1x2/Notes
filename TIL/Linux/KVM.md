# KVM Notes


## Check virtualization
lsmod | grep kvm
ls /dev/kvm
lscpu | grep Virtualizaiton
egrep "vmx|svm" /proc/cpuinfo | wc -l

# QEMU

- Type 2 hypervisor that runs in user space.
- When used with KVM, it accelerates the performance of a QEMU guest and the combination becomes a type-1 hypervisor.

QEMU is a user space program that has two modes

- Emulation(Software)
    - Type-2 hypervisor
- Virtualization(software and hardware)
    - Type-1 hypervisor

QEMU creates one process for every VM and a thread for each vCPU.

- These run in the Linux scheduler.
- A virtual machine is a collection of processes running on the host.


QEMU and the /dev/kvm interface combine to provide the resources the guest operating system requires:

Key hardware:
    - Virtual CPU(s)
    - Virtual memory
    - Virtual disk(s)
    - Virtual networking

Mapped physical resources:
    - Networking
        - IP
        - Storage
    - GPU(s)

Other resources:
    - USB
    - Sound
    - Virtual media:
        - CD/DVD/ISO images


## Paravirtualization

QEMU/KVM - Provide Paravirtualization Support

- Two parts;
    - Provides a software interface that looks like hardware
    - VirtIO drivers for the guest operating system
- Offloads some "challenging" processes from the guest to the host
- Uses the VirtIO API
    - Ethernet
    - Storage
    - Memory baloon device
    - Display

## QEMU - Disk Image Formats

- QEMU - Copy-On-Write(.qcow2, .qed, .qdow, .cow)
- VirtualBox - Virtual Disk Image(.vdi)
- Virtual PC - Virtual Hard Disk (.vhd)
- Virtual VFAT
    - A virtual drive with FAT filesystem
    - Quick way to share files between guest and host
- VMware - Virtual Machine Disk(.vmdk)
- Raw images (.img)
    - These contain sector-by-sector disk contents
- Bootable CD/DVD Images (.iso)

### Read-Only Formats

- macOS - Universal Disk Image Format (.dmg)
- Bochs
- Linux cloop
    - Compressed image format
- Parallels disk image (.hdd, hds)