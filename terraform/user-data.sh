#!/bin/bash

sudo apt-get update && apt-get upgrade -y
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh

sudo usermod -aG docker $USER

sudo systemctl start docker
sudo systemctl enable docker

sudo mkdir -p /opt/webapp
sudo chown -R $USER:$USER /opt/webapp
cd /opt/webapp

git clone ${github_repo} .

docker compose up -d --build

echo "Deployment complete"