#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

sleep 30

apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker

docker pull gojo922/strapi-app:latest
docker run -d -p 1337:1337 gojo922/strapi-app:latest
