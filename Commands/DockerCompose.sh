#!/bin/bash


docker-compose up -d #-d=detached

docker-compose -f <dir>/docker-compose.yml up

docker-compose ps #list the containers (run this in the directory of the docker-compose file)

docker-compose -f <dir>/docker-compose.yml ps

docker-compose stop 

docker-compose start

docker-compose restart

docker-compose down

docker-compose build

docker-compose build --no-cache
