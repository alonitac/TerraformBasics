#!/bin/bash

# Update and install necessary packages
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

echo "Installed necessary packages"

# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null
chmod a+r /etc/apt/keyrings/docker.asc

echo "Added Docker's GPG key"

# Add Docker's repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Added Docker's repository"

# Update and install Docker packages
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Installed Docker"

#git clone ....
#cd Netflix
#docker compose up -d

# Verify Docker installation
docker run hello-world