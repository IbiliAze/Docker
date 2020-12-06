#!/bin/bash

docker network create --subnet 10.0.0.0/24 --gateway 10.0.0.1 bn

docker build -t dmvpn:latest -f Dockerfile .

docker run -d -p 5000:5000 --network="bn" --ip 10.0.0.2 dmvpn

docker run -d -p 27017:27017 --network="bn" --ip 10.0.0.3 mongo

