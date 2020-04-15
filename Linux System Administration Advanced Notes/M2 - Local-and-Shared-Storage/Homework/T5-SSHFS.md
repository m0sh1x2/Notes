# Task 5
Research and implement SSHFS

# Used Sources

- [SSHFS: Mounting a remote file system over SSH](https://www.redhat.com/sysadmin/sshfs)
- [How To Use SSHFS to Mount Remote File Systems Over SSH](https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh)

# Solution

The solution requires a client and a server with installed SSH or SFTP.

There aren't any other requirements for the server.

Client setup:

```
sudo apt install sshfs
```

Make a mount directory

```
mkdir /mnt/m2-centos
```

Connect:

```
sudo sshfs -o allow_other,default_permissions m0sh1x2@192.168.1.135:/ /mnt/m2-centos/
```

Test the connection

```
m0sh1x2@DESKTOP-BMAX-Y13 ~> cd /mnt/m2-centos/
m0sh1x2@DESKTOP-BMAX-Y13 /m/m2-centos> ls -la
total 92
dr-xr-xr-x 1 root root  261 Apr 15 05:00 ./
drwxr-xr-x 5 root root 4096 Apr 15 17:49 ../
lrwxrwxrwx 1 root root    7 May 11  2019 bin -> usr/bin/
dr-xr-xr-x 1 root root 4096 Apr 15 06:48 boot/
drwxr-xr-x 1 root root 3500 Apr 15 07:11 dev/
drwxr-xr-x 1 root root 8192 Apr 15 07:14 etc/
drwxr-xr-x 1 root root   39 Apr 15 05:08 fs1/
drwxr-xr-x 1 root root    6 Apr 15 04:59 fs2/
drwxr-xr-x 1 root root   21 Apr 11 15:46 home/
lrwxrwxrwx 1 root root    7 May 11  2019 lib -> usr/lib/
lrwxrwxrwx 1 root root    9 May 11  2019 lib64 -> usr/lib64/
drwxr-xr-x 1 root root    6 May 11  2019 media/
drwxr-xr-x 1 root root   33 Apr 15 07:13 mnt/
drwxr-xr-x 1 root root    6 May 11  2019 opt/
dr-xr-xr-x 1 root root    0 Apr 14 21:06 proc/
dr-xr-x--- 1 root root  205 Apr 15 02:27 root/
drwxr-xr-x 1 root root 1280 Apr 15 07:11 run/
lrwxrwxrwx 1 root root    8 May 11  2019 sbin -> usr/sbin/
drwxr-xr-x 1 root root    6 May 11  2019 srv/
drwxr-xr-x 1 root root   23 Apr 15 05:16 stratis/
dr-xr-xr-x 1 root root    0 Apr 15 07:11 sys/
drwxrwxrwt 1 root root 4096 Apr 15 07:40 tmp/
drwxr-xr-x 1 root root  144 Apr 11 15:40 usr/
drwxr-xr-x 1 root root 4096 Apr 11 15:46 var/
```