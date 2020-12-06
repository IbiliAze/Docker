#!/bin/bash



[ Informational ]

lxc info mycentos-cont



[ Containers ]

lxc launch ubuntu:20.04

lxc launch ubuntu:20.04 myimage #custom container name

lxc launch images:alpine/3.5 myimage #pulling from repo

lxc launch images:alpine/3.10 -s default #-s=storage pool

lxc list #list containers



[ Images ]

lxc image copy ubuntu:20.04 local: --alias myubuntu #pull Ubuntu image 
lxc image copy images:centos/8 local: --alias centos #pull CentOS image
lxc launch myubuntu myubuntu-cont
lxc exec myubuntu -- /bin/bash

lxc image list #list images

lxc image alias create myceontos 9bf9f8411662 #create a name for an existing image


{Snapshots}
lxc snapshot myubuntu-cont mysnapshot #new snapshot

lxc snapshot myubuntu-cont 1.0 #best practice when naming snapshots as version numbers
lxc copy myubuntu-cont/1.0 myubuntu-cont2
lxc start myubuntu-cont2

lxc delete myubuntu-cont/1.0


{Remotes}
lxc remote list

lxd init #setup a remote on the remote server
>Would you like LXD to be available over the network? yes
>Address to bind LXD to (not including the port)? all
>Port to bind LXD to? 8443
>Trust password for new clients? cisco12345
>Again? cisco12345

lxc remote add mycustom-remote <IP of remote server above> #run on local machine

lxc list mycustom-remote: #list images on the remote

lxc image copy images:alpine/3.11 mycustom-remote: 

lxc image copy images:alpine/3.11 mycustom-remote: --alias alpine #copy with a name


{Disecting Images}
lxc image export myalpine . #current view of an existing image
sudo mkdir /dev/alpine-expanded
sudo mount 34234234723482nc742n472.squashfs /dev/alpine-expanded
ls /dev/alpine-expanded

tar -xvf meta-2917b7777de97aa5d6aba2b9cc58e0fc7e20d2760cc6a6f8be18e29d611fae53.tar.xz
cat metadata.yaml #LXD config


[ Creating Images ]

lxc config set core.https_address 192.168.0.137
lxc launch ubuntu-image ubuntu-cont
lxc snapshot ubuntu-cont 1.0
lxc publish local:ubuntu-cont/1.0 local: --alias myubuntu
lxc image ls local:


{Distrobuilder}
wget https://raw.githubusercontent.com/lxc/distrobuilder/master/doc/examples/ubuntu.yaml #ubuntu distro template
ls /usr/share/debootstrap/scripts/ #available distros 
sudo distrobuilder build-lxd ubuntu.yaml 
lxc image import lxc.tar.xz root.squashfs --alias eoan
lxc image ls



[ Config ]

lxc config show myubuntu-cont

lxc config edit myubuntu-cont

lxc config get myubuntu-cont <key>

lxc config get myubuntu-cont boot.autostart

lxc config set myubuntu-cont <key> <value>

lxc config set myubuntu-cont boot.autostart false


{Device}
lxc config device <cmd> #configure disks

lxc config device list mycentos-cont

lxc config device get mycentos-cont root pool #root=device, pool=value


{Resource Limitation}
lxc config set mycont limits.cpu 1 #CPU core limitation

lxc config set mycont limits.cpu 2-4 #CPU limitation with a range of cores

lxc exec centos -- cat /proc/cpuinfo | grep ^processor #see containers number of cores

lxc config set mycont limits.cpu.allowance 50% #CPU limitation of maximum 50% of core time

lxc config set mycont limits.cpu.priority 10 #10 highest, 1 lowest

lxc config set mycont limits.memory 256MB

lxc config set mycont limits.memory.swap true

lxc config set mycont limits.memory.swap.priority 10 #lowest chance of using SWAP, will use RAM more

lxc config set mycont limits.memory.enforce soft #soft limit

lxc config set mycont limits.memory.enforce hard 



[ File ]

lxc file edit mycentos-cont/etc/httpd/conf/httpd.conf #edit a file in the container

lxc file pull mycentos-cont/etc/httpd/conf/httpd.conf httpd2.conf #download a file from a container and save it as httpd2.conf

lxc file push ./httpd.conf mycentos-cont/etc/httpd/conf/ #upload a file "httpd.conf" to a container directory /etc/httpd/conf/

lxc file delete mycentos-cont/etc/httpd/conf/httpd.conf



[ Security ]

sudo vim /var/lib/lxd/security/seccomp/mycont #seccomp profile for Centos

sudo vim /var/snap/lxd/common/lxd/security/seccomp/mycont #seccomp profile for Ubuntu

https://man7.org/linux/man-pages/man2/syscalls.2.html #all system calls



[ SOCKS Proxy ]

lxc exec centos bash
useradd tunnel -m
passwd tunnel
yum install -y openssh-server openssh net-tools
systemctl start sshd
systemctl enable sshd
echo '''PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no''' > /etc/ssh/sshd_config
mkdir /home/tunnel/.ssh
touch /home/tunnel/.ssh/authorized_keys
cd /home/tunnel/
chown -R tunnel:tunnel .ssh
chmod 700 .ssh/
cd .ssh/
chmod 600 authorized_keys
exit
ssh-keygen
    > /home/ibi/.ssh/SOCKS5
cat ~/.ssh/SOCKS5.pub #copy
lxc exec centos bash
cd /home/tunnel/.ssh
vim authorized_keys #paste
systemctl restart sshd
ss -lntp | grep 22
exit
lxc config device add centos myport61613 proxy listen=tcp:0.0.0.0:61613 connect=tcp:10.253.104.62:22 #IP of container
lxc snapshot centos SOCKS5
lxc publish local:centos/SOCKS5 local: --alias centosSOCKS5
lxc image ls
lxc launch centosSOCKS5 centosSOCKS5
ss -lntp | grep 61613
ssh tunnel@localhost -i ~/.ssh/SOCKS5 -p 61613 #can test from another client, with the IP of the server running LXD
ssh -D 65535 -q -C -N -f tunnel@192.168.0.137 -i ~/.ssh/SOCKS5 -p 61613 #65535=local, q=quiet, -C=compressed, -N=no commands, -f=run in backgroud, IP of intermidiate server



[ Profile ]

lxc profile list

lxc profile show default

lxc profile copy default profile2 #copy from default to a new profile "profile2"

lxc profile edit profile2

lxc profile set profile2 boot.autostart.priority 50 #higher the more important boot priority

lxc profile set profile2 boot.autostop.priority 50

lxc profile set profile2 environment.EDITOR vim #set environment variable on the container EDITOR=vim

lxc profile add myubuntu-cont profile2

lxc profile remove myubuntu-cont profile2

lxc launch myubuntu myubuntu-cont -p profile2 #launch from profile



[ Storage ]

lxc storage create zfs-test zfs source=dev/sdb1



[ Exec ]

lxc exec coherent-beetle -- /bin/bash

lxc exec myubuntu-cont -- bash -c 'echo && pwd' #run multiple commands with && or ||



[ Clustering ]

lxd init
>Would you like to use LXD clustering? yes
>What name should be used to identify this node in the cluster? ubuntu
>What IP address or DNS name should be used to reach this node? default
>Are you joining an existing cluster? no
>Setup password authentication on the cluster? yes
>Trust password for new clients? cisco
>Again? cisco
...



[ lxd init ]

>Would you like to use LXD clustering? no
>Do you want to configure a new storage pool? yes
>Name of the new storage pool? default
>Name of the storage backend to use? btrfs (Ubuntu) zfs (CentOS)
>Create a new BTRFS pool? yes
>Would you like to use an existing empty block device? no
>Size in GB of the new loop device? default
>Would you like to connect to a MAAS server? no
>Would you like to create a new local network bridge? yes
>What should the new bridge be called? default
>What IPv4 address should be used? auto
>What IPv6 address should be used? auto
>Would you like LXD to be available over the network? no
>Would you like stale cached images to be updated automatically? yes
>Would you like a YAML "lxd init" preseed to be printed? yes #save to LXD.yml

cat LXC.yml | lxd init --preseed

