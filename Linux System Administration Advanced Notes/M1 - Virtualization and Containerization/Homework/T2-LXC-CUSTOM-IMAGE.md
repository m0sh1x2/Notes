# Task 2

# Research and create own LXC template

# Main Infrastructure

- Ubuntu Server 18.04 - 172.26.138.56
- Basic LXC install

# Sources:

- https://ubuntu.com/tutorials/create-custom-lxd-images
- https://cwiki.apache.org/confluence/display/CLOUDSTACK/LXC+Template+creation
- https://wiki.debian.org/Debootstrap

## Solution

## 1. Set up LXC

```
lxd init
```

![lxd init output](https://m0sh1x2.com/screenshots/MobaXterm_UQcJci4Cw3.png)

## 2. Follow the steps from the [Creating custom LXD images](https://ubuntu.com/tutorials/create-custom-lxd-images) and setup a clean Debian Container

## 2.1 Install debootstrap

![Install](https://m0sh1x2.com/screenshots/MobaXterm_G8enOamW4Q.png)

## 2.2 Create basic system installation:

Short Video - https://m0sh1x2.com/screenshots/gE4PXkEr4X.webm
 - Includes debootstrap setup
 - chroot install of nmp, htop, nload, atop
 - filesystem archive
 - metadata.yml setup
 - container import
 - container start

```
mkdir /tmp/softuni-lxd
sudo debootstrap sid /tmp/softuni-lxd
```

Set up
- NodeJS
- HTOP
- nload
- atop

```
sudo chroot /tmp/softuni-lxd
wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
echo 'deb https://deb.nodesource.com/node_8.x sid main' > /etc/apt/sources.list.d/nodesource.list
echo 'deb-src https://deb.nodesource.com/node_8.x sid main' >> /etc/apt/sources.list.d/nodesource.list
exit
```

Compress the filesystem

```
sudo tar -cvzf rootfs.tar.gz -C /tmp/softuni-lxd .
```

Create medatata.yml file

```
vi metadata.yml
```

Paste the contents:

```
architecture: "x86_64"
creation_date: 1586368277 # To get current date in Unix time, use `date +%s` command
properties:
architecture: "x86_64"
description: "Debian Unstable (sid) with pre-installed nodejs, htop, atop, nload"
os: "debian"
release: "sid"
````

Compress the file

```
tar -cvzf metadata.tar.gz metadata.yaml
```

## Import the LXD image:

```
lxc image import metadata.tar.gz rootfs.tar.gz --alias softuni-lxd
```

```
lxc image list
```
Output:
![lxc image list](https://m0sh1x2.com/screenshots/MobaXterm_fWYmKNeaQ0.png)


Output:

![Output](https://m0sh1x2.com/screenshots/MobaXterm_SyjYDUg4pk.png)

![Output](https://m0sh1x2.com/screenshots/MobaXterm_aEIfC5vsBG.png)

Second Try:
![Output second try](https://m0sh1x2.com/screenshots/MobaXterm_nWc7M5kT3D.png)

## Launch and login the container

```
lxc launch softuni-container tutorial
lxc shell softuni-container softuni-homework-container
````


