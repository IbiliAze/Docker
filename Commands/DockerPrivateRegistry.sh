#!/bin/bash


[ Private Docker Registry ]

sudo su
curl -fsSL https://get.docker.com | bash
echo "subjectAltName=IP:172.31.16.108" > /usr/lib/ssl/openssl.cnf
cd ~; mkdir certs; cd certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $(pwd)/test.key -out $(pwd)/test.cert
docker run -d -p 5000:5000 \
 --restart=always \
 --name=registry \
 -v /certs:/certs \
 -e REGISTRY_HTTPS_TLS_CERTIFICATE=/certs/test.cert \
 -e REGISTRY_HTTPS_TLS_KEY=/certs/test.key \
 registry:2 #create docker registry
docker ps
mkdir -p /etc/docker/certs.d/172.31.16.108:5000
cp test* /etc/docker/certs.d/172.31.16.108\:5000/
cd /etc/docker/certs.d/172.31.16.108:5000
mv test.cert ca.cert

