#!/bin/bash
set -e
echo "Installing Jenkins..."
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk maven git curl

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update -y
sudo apt-get install -y jenkins

sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

echo "Jenkins password:"
sleep 15
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
