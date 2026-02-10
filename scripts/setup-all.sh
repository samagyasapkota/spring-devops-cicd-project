#!/bin/bash

echo "=========================================="
echo "AUTOMATED DEVOPS SETUP - Starting..."
echo "=========================================="

# Install Jenkins
echo "[1/6] Installing Jenkins..."
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk maven git

wget -q -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update -y
sudo apt-get install -y jenkins

sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# Install Docker and Docker Compose
echo "[2/6] Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker vagrant
sudo systemctl start docker
sudo systemctl enable docker

curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /tmp/docker-compose
sudo mv /tmp/docker-compose /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone project repository
echo "[3/6] Cloning project..."
cd /home/vagrant
git clone https://github.com/samagyasapkota/spring-devops-cicd-project.git
cd spring-devops-cicd-project
git checkout staging

# Build and deploy application
echo "[4/6] Building application..."
cd /home/vagrant/spring-devops-cicd-project/JavaApp-CICD
mvn clean package -DskipTests

# Setup monitoring
echo "[5/6] Setting up monitoring..."
cd /home/vagrant/spring-devops-cicd-project/monitoring
docker-compose up -d

# Install Node Exporter
echo "[6/6] Installing Node Exporter..."
docker run -d \
  --name=node-exporter \
  --restart=unless-stopped \
  --net="host" \
  -v "/:/host:ro,rslave" \
  prom/node-exporter:latest \
  --path.rootfs=/host

echo "=========================================="
echo "SETUP COMPLETE!"
echo "=========================================="
echo "Jenkins: http://192.168.56.10:8080"
echo "Prometheus: http://192.168.56.30:9090"
echo "Grafana: http://192.168.56.30:3000"
echo ""
echo "Jenkins password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "Jenkins starting..."
echo "=========================================="
