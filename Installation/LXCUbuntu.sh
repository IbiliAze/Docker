#!/bin/bash



echo step 1
sudo apt update -y

echo step 2
sudo apt install -y lxd lxd-client

echo step 3
sudo lxd init


