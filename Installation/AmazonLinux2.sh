#!/bin/bash

echo step 1
sudo yum install -y docker --disablerepo=docker-ce-stable

echo step 2
systemctl start docker

echo step 3
systemctl enable docker

echo step 4
sudo chmod 666 /var/run/docker.sock

