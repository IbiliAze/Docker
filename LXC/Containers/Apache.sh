#!/bin/bash



echo step 1 - HOST
lxc exec centosContainer bash

echo step 2 - CONTAINER
yum install -y httpd

echo step 3 - CONTAINER
systemctl start httpd

echo step 4 - CONTAINER
mkdir /etc/httpd/sites-enabled
mkdir /etc/httpd/sites-available
mkdir /var/www/html/mydomain.com/
touch /etc/httpd/sites-available/mydomain.com.conf
echo "127.0.0.1   mydomain.com" >> /etc/hosts

echo step 5 - CONTAINER
echo "<VirtualHost *:80>
        ServerName mydomain.com
        ServerAlias mydomain.com
        DocumentRoot /var/www/html/mydomain.com/
</VirtualHost>" > /etc/httpd/sites-available/mydomain.com.conf

echo step 6 - CONTAINER
systemctl restart httpd

echo step 7 - CONTAINER
ln -sf \
    /etc/httpd/sites-available/mydomain.com.conf \
    /etc/httpd/sites-enabled/mydomain.com.conf #-s=soft link, -f=force symlink

echo step 8 - HOST
lxc config device add centosContainer myport80 proxy listen=tcp:0.0.0.0:80 connect=tcp:0.0.0.0:80
lxc config device add centosContainer myport443 proxy listen=tcp:0.0.0.0:443 connect=tcp:0.0.0.0:443

echo step 9 - CONTAINER
echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf

echo step 10 - CONTAINER
systemctl restart httpd

echo step 11 - CONTAINER
echo mydomain > /var/www/html/mydomain.com/index.html
curl --header "Host: mydomain.com" 127.0.0.1

echo step 12 - CONTAINER
yum update -y
yum install -y epel-release python3-certbot-apache certbot

echo step 13 - CONTAINER
systemctl restart httpd

echo step 14 - CONTAINER
certbot --apache --server http://acme-v02.api.letsencrypt.org/directory -m me@mail.com -d rqd0JWXrN0.com


