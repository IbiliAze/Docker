#!/bin/bash



echo step 1
sudo apt install -y curl

echo step 2
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

echo step 3
sudo chmod +x /usr/local/bin/docker-compose

echo step 4
docker-compose version

