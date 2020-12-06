#!/bin/bash


[ chroot ]

sudo su -
mkdir /home/chrootuser
mkdir /home/chrootuser/{bin,lib}
groupadd chrootgroup
useradd chrootuser
useradd -g chrootgroup quinn
groups quinn
cd /home/chrootuser/bin/
cp /usr/bin/bash .
cp /usr/bin/ls .
ldd /bin/bash

