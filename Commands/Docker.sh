#!/bin/bash



[ Image ]

docker image ls

docker image ls -a #all

docker image history myimage #layer history

docker image pull nginx

docker image inspect f35646e83998 #image info


{Build}
docker image build -t myimage:latest -f Dockerfile.test . #specify a custom Dockerfile name

docker image build -t myimage:latest --force-rm . #always remove intermediate containers

docker image build -t myimage:latest --rm . #remove intermidiate containers after a successful build

docker image build -t myimage:latest --label myversion=1.1 . #add metadata

docker image build -t myimage:latest --ulimit .

docker image build -t myimage:latest https://github.com/docker/image:# #use URL, :#=directory

docker image build -t myimage:latest https://github.com/docker/image#master:mydir # #=reference (brand name)

docker image build -t myimage:latest - < mytarfile.tar.gz #for TAR files


{DockerHub}
docker image push ibiliaze/myimage


{History}
docker image history node:latest

docker image history node:latest --no-trunc

docker image history node:latest --quiet

docker image history node:latest --quiet --no-trunc


{Save}
docker image save myimage > myimage.tar

docker image save myimage --output myimage.tar #same as above

docker image load < myimage.tar

docker image load --input myimage.tar #same as above

docker image load -i myimage.tar #same as above 2x



[ Container ]

docker container run busybox

docker container run --name myconname myimage

docker container run --rm busybix  #automatically remove the container when it exits

docker container run -it ngninx #-i=interactive keep STDIN open, -t=allocate TTY to the container

docker container run --network mynetwork nginx #run a container in a network

docker container run --network mynetwork --ip 10.33.1.23 nginx



{Listing}
docker container ls

docker container ls -a #all

docker container ls -a -q #-q=quiet, will only show IDs

docker container ls -a -f status=exited #-f=filter

docker container ls -a -f status=running

docker container ls -a -f status=running | wc -l #number of:



{Running Ports}
docker container run -P -d nginx #-P=take all the ports on the container and map to random port, -d=detached

docker container port f8er7t3ffgdf #see all specified port mappings

docker container run -d -p 80:8080 nginx #-p=publish a port

docker container run -d -p 8081:80/tcp -p 8081:80/udp nginx

docker container run -d --expose 3000 nginx #open up a port on the container, but won't be able to curl localhost:3000, see below

docker container run -d --expose 3000 -p 8080:80 nginx #8080:80 as NGINX listens on port 80



{Running Storage}
docker container run -v #-v=mount a volume

docker container run --mount #--mount=attach a filesystem mount



{Running Commands}
docker container attach df5aa7864529 #attach local STDIN, STDOUT, STDER streams to a running contianer

docker container exec -it df5aa7864529 /bin/bash #drop into the container shell

docker container exec -it df5aa7864529 pwd #running a command in a container

docker container run -it nginx /bin/bash #the container will shut down after the bash command is executed, overwrites Dockerfile CMD

docker container run -it nginx pwd #the container will shut down after the pwd command is executed, overwrites Dockerfile CMD



{Environment variables}
docker container run -d -p 8080:80 --env PORT=5000 myimagewithenv #Dockerfile: the ENV has to be called, and overwrites

docker image build -t myimage:latest --build -arg MY_ARG=/var/node . #build with ARG



{Start/Stop/Restart}
docker contianer stop d1a4a49e476a

docker contianer start d1a4a49e476a #start a stopped container 

docker container pause df5aa7864529 #pause the running processes

docker container unpause df5aa7864529

docker container run -d --restart always myimage #will restart after systemctl restart

docker container run -d --restart unless-stopped myimage #will restart after systemctl restart, but not if it's stopped

docker container rm df5aa7864529 -f #-f=force

docker container rm -h fgv434gd3vt 3vf5b345y35 v534b5454353 #multiple containers

docker container prune #remove all stopped containers 

docker container prune -f 



{Informational}
docker container logs df5aa7864529

docker container logs df5aa7864529 -f #follow

docker container inspect df5aa7864529

docker container top df5aa7864529 #running processes of the container

docker container stats d2834324fddsf #resource usage live

docker system events

docker system events --since '1h'

docker system events --filter type=container --since '1h'

docker system events --filter type=container --filter event=stop



[ Events ]

docker system events

docker system events --since '1h'

docker system events --filter type=container --since '1h'

docker system events --filter type=container --filter event=stop



[ Network ]

docker container run --network #--network=connect container to a network

docker network ls #list all the networks

docker network inspect bridge

docker network create mynetwork

docker network rm mynetwork

docker network prune #delete all unused networks (risky)

docker network connect mynetwork mycontainer

docker network disconnect mynetwork mycontainer

docker network create --subnet 10.33.0.0/24 --gateway 10.33.0.1 mynetwork

docker network create --subnet 10.33.0.0/16 --gateway 10.33.0.1 \
--ip-range=10.33.1.0/24 --driver=bridge --label=host4network mynetwork #subnetting Class B into Class C

docker container run --network mynetwork nginx

docker container run --network mynetwork --ip 10.33.1.23 nginx
docker container inspect fa0f10cf7378 | grep IPAddress



[ Storage ]

sudo ls /var/lib/docker/<storage driver> #location of the non-persistent storage; sudo ls /var/lib/docker/overlay2

sudo ls /var/lib/docker/volumes/ #persistent storage

docker volume ls

docker volume create myvolume

docker volume inspect myvolume

docker volume rm myvolume

docker volume prune

{Bind Mounts} #Uses File System path
mkdir ~/Documents/Git/Docker/code -p
echo test > ~/Documents/Git/Docker/code/test.txt
docker container run -d --mount type=bind,source=/home/ibi/Documents/Git/Docker/code,target=/app nginx #bind mount

docker container run -d -v /home/ibi/Documents/Git/Docker/code:/app nginx #same as above

{Volumes Mounts} #Uses /var/lib/docker/volumes
docker container run -d --mount type=volume,source=html-volume,target=/usr/share/nginx/html nginx #volume mount

docker container run -d -v html-volume:/usr/share/nginx/html nginx #same as above

sudo vim /var/lib/docker/volumes/html-volume/_data/index.html #(example) edit the mounted volume on your local machine

docker container run -d --mount type=volume,source=html-volume,target=/usr/share/nginx/html,readonly nginx #read only



[ Security ]

{Seccomp}
wget https://raw.githubusercontent.com/moby/moby/master/profiles/seccomp/default.json
docker container run -it --security-opt seccomp=./default.json alpine #security profile

{Capability}
docker container run -it --cap-drop=CHOWN alpine sh #drop the chown command

docker container run -it --cap-add=CHOWN alpine sh

{Resource Constraining}
docker container run -it --cpus="2" --memory=512M --memory-swap=1G alpine 

{Content trust}
docker trust key generate user1 #generate a key
 
docker trust ket load mykey.pem --name user1 #import a key

docker trust signer add --key user1.pem user1 ibiliaze
docker trust sign ibiliaze/myimage:latest
docker image push ibiliaze/myimage:latest
sudo echo '''{"content-trust": {"mode": "enforced"}}''' >> /etc/docker.daemon.json
 
docker trust signer remove user1 ibiliaze

{Secrets}

openssl rand -base64 20 > secret.txt
docker secret create mysecret2 secret.txt

openssl rand -base64 20 | docker secret create mysecret -

docker secret ls



[ Exec ]

docker exec -it df5aa7864529 /bin/bash

docker exec -it df5aa7864529  pwd

docker exec -it -u 0 fd4r543tvf3 /bin/bash #enter the container shell as root

docker container run -it nginx /bin/bash #container will shut down after the bash command is executed, overwrites Dockerfile CMD

docker container run -it nginx pwd #container will shut down after the pwd command is executed, overwrites Dockerfile CM



[ Portainer ]

docker container run -d --name portainer -p 3000:9000 \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data portainer/portainer


