#!/bin/bash

# Exit immediately if a command fails
set -e

echo "===================================="
echo " Updating system packages"
echo "===================================="
sudo apt update -y

echo "===================================="
echo " Installing Java (OpenJDK 17)"
echo "===================================="
sudo apt install -y openjdk-17-jre

# Verify Java installation
java -version

echo "===================================="
echo " Adding Jenkins repository and key"
echo "===================================="
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "===================================="
echo " Installing Jenkins"
echo "===================================="
sudo apt update -y
sudo apt install -y jenkins

echo "===================================="
echo " Starting and enabling Jenkins service"
echo "===================================="
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "===================================="
echo " Jenkins Installation Completed"
echo "===================================="
echo "Jenkins Status:"
sudo systemctl status jenkins --no-pager

echo "===================================="
echo " Initial Admin Password"
echo "===================================="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

