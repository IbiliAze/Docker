#!/bin/bash

docker container run -d --name portainer -p 3000:9000 \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data portainer/portainer

