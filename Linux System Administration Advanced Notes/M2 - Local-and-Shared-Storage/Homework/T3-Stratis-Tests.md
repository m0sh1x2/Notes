# Task 3
Explore and deploy the Stratis management framework

# Used Sources

- [Stratis Main Site](https://stratis-storage.github.io/howto/)
- [Stratis Storage Cheat Sheet – reference guide](https://computingforgeeks.com/stratis-storage-management-cheatsheet/)
- [RHEL 8 Beta - Managing Storage With Stratis](https://www.youtube.com/watch?v=CJu3kmY-f5o)


# Solution

```
stratis pool create main-pool /dev/sd[b-f]

# List the pools
stratis pool

# List block devices
stratis blockdev list

stratis filesystem create main-pool main_fs1
stratis filesystem create main-pool main_fs2

stratis fs list

# Mount the FS
mount /stratis/main-pool/main_fs1 /fs1/
mount /stratis/main-pool/main_fs2 /fs2/
```

Check the mounted filesystems

```
[root@centos m0sh1x2]# df -h | grep stratis
/dev/mapper/stratis-1-808b00f17fdb43c1ae77bbe34ec1b8e4-thin-fs-974bb8989f674d96bdd6511dbfce2ef3  1.0T  7.2G 1017G   1% /fs1
/dev/mapper/stratis-1-808b00f17fdb43c1ae77bbe34ec1b8e4-thin-fs-61418f7ea12b4eef8ce3b240c322db68  1.0T  7.2G 1017G   1% /fs2
```

Note: The 1.0T is because stratis doesn't have a stict size. It will grow based on provisioning.

Additional info:

```
[root@centos m0sh1x2]# stratis fs
Pool Name  Name      Used     Created            Device                       UUID                            
main-pool  main_fs1  546 MiB  Apr 14 2020 21:59  /stratis/main-pool/main_fs1  974bb8989f674d96bdd6511dbfce2ef3
main-pool  main_fs2  546 MiB  Apr 14 2020 21:59  /stratis/main-pool/main_fs2  61418f7ea12b4eef8ce3b240c322db68
```

Create 1G file:
```
dd if=/dev/zero of=test1G bs=1M count=1024
```

Create snapshots:

```
stratis fs snapshot main-pool main_fs1 main-fs-1-snapshot
```

Test the snapshot

```
[root@centos /]# umount /fs1
[root@centos /]# stratis fs destroy main-pool main_fs1
```

```
stratis fs snapshot main-pool main-fs-1-snapshot main_fs1
mount /stratis/main-pool/main_fs1 /fs1
```

Check the FS:

```
[root@centos fs1]# cd /fs1/
[root@centos fs1]# ls -la
total 1048580
drwxr-xr-x.  2 root root         39 Apr 14 22:08 .
dr-xr-xr-x. 20 root root        261 Apr 14 22:00 ..
-rw-r--r--.  1 root root         28 Apr 14 22:08 backup_file
-rw-r--r--.  1 root root 1073741824 Apr 14 22:07 test1G
```