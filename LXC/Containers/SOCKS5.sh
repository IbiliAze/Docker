#!/bin/bash



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
