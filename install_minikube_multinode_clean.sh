#!/bin/bash
set -e

echo "🧹 Cleaning old Kubernetes repositories (IMPORTANT FIX)..."
sudo rm -f /etc/apt/sources.list.d/kubernetes.list
sudo rm -f /etc/apt/keyrings/kubernetes.gpg

sudo sed -i '/kubernetes-xenial/d' /etc/apt/sources.list || true

echo "🔹 Updating system..."
sudo apt update -y

echo "🔹 Installing base dependencies..."
sudo apt install -y curl wget ca-certificates gnupg lsb-release apt-transport-https

#####################################
# Docker Installation (Official)
#####################################
echo "🐳 Installing Docker (official)..."

sudo apt remove -y docker docker-engine docker.io containerd runc || true

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

#####################################
# kubectl Installation (NEW OFFICIAL REPO)
#####################################
echo "☸️ Installing kubectl (pkgs.k8s.io)..."

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | \
sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg

echo \
"deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update -y
sudo apt install -y kubectl

#####################################
# Minikube Installation (Binary)
#####################################
echo "🚀 Installing Minikube..."

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

#####################################
# Start Multi-node Cluster
#####################################
echo "🔹 Starting Minikube (1 master + 2 workers)..."

minikube start \
  --driver=docker \
  --nodes=3 \
  --profile=multinode-cluster

#####################################
# Verify
#####################################
echo "🔍 Verifying cluster..."
kubectl get nodes -o wide

echo "✅ SUCCESS: Minikube multi-node cluster installed!"
echo "⚠️ Please logout & login once, then re-run: kubectl get nodes"

