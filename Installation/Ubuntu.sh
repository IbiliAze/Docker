#!/bin/bash

echo step 1
sudo apt install curl

echo step 2
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo step 3
sudo apt-add-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo step 4
sudo apt update -y

echo step 5
sudo apt install -y docker-ce

echo step 6
sudo usermod -aG docker ${USER}

echo step 7 *** LOGGING OUT ***
logout
