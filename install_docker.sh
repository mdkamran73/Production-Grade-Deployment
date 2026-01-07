#!/bin/bash

set -e

echo "🔹 Updating system packages..."
sudo apt-get update -y

echo "🔹 Removing old Docker versions if any..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

echo "🔹 Installing required dependencies..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "🔹 Adding Docker’s official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "🔹 Adding Docker official repository..."
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔹 Updating package index..."
sudo apt-get update -y

echo "🔹 Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "🔹 Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "🔹 Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "✅ Docker installation completed successfully!"
echo "⚠️ Please logout and login again to use Docker without sudo."

