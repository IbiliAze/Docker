#!/bin/bash



[ Init ]

docker swarm init --advertise-addr 192.168.0.64

sudo docker swarm join docker swarm join --token \ 
SWMTKN-1-6a6x9dgsmrjurfvu6blidru2dr9o8fjcm3zkb9upcojewmk5ub-baiwznx0y2d30b0mwll0bbbh4 192.168.0.64:2377 #run on slave node

docker node ls

docker swarm join-token worker #view the join token for a new worker

docker swarm join-token manager



[ Nodes ]

docker node inspect 77kaqeu5dz3g2fyixhpkvk10y

docker node promote 77kaqeu5dz3g2fyixhpkvk10y
 
docker node demote 77kaqeu5dz3g2fyixhpkvk10y

docker node rm -f 77kaqeu5dz3g2fyixhpkvk10y

docker swarm leave

docker node demote 77kaqeu5dz3g2fyixhpkvk10y; docker \
node rm -f 77kaqeu5dz3g2fyixhpkvk10y #removing a manager node
docker swarm leave #then run on the node



[ Services ] #Similar to containers / pods
 
docker service create -d --name mynginxservice -p 8080:80 --replicas 1 nginx:latest

docker service ls

docker service inspect mynginxservice

docker service logs mynginxservice

docker service ps mynginxservice

docker service scale mynginxservice=2

docker service update -h #update options


