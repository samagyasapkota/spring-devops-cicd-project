# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # VM 1: Jenkins + App Server (CI/CD + Application)
  config.vm.define "jenkins-app" do |node|
    node.vm.box = "ubuntu/jammy64"
    node.vm.hostname = "jenkins-app"
    node.vm.network "private_network", ip: "192.168.56.10"
    node.vm.network "forwarded_port", guest: 8080, host: 8080  # Jenkins
    node.vm.network "forwarded_port", guest: 8081, host: 8081  # Spring App
    
    node.vm.provider "virtualbox" do |vb|
      vb.name = "jenkins-app"
      vb.memory = 3072
      vb.cpus = 2
    end
    
    node.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y apt-transport-https ca-certificates curl software-properties-common git
      
      # Install Docker
      curl -fsSL https://get.docker.com -o get-docker.sh
      sh get-docker.sh
      usermod -aG docker vagrant
      
      # Install Docker Compose
      curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
      
      # Install Java 17
      apt-get install -y openjdk-17-jdk maven
      
      # Install Jenkins
      wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | apt-key add -
      sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
      apt-get update
      apt-get install -y jenkins
      systemctl start jenkins
      systemctl enable jenkins
      
      echo "=========================================="
      echo "Jenkins Initial Password:"
      sleep 15
      cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null
      echo "=========================================="
      echo "Jenkins: http://192.168.56.10:8080"
      echo "=========================================="
    SHELL
  end
  
  # VM 2: Kubernetes Node
  config.vm.define "k8s-node" do |node|
    node.vm.box = "ubuntu/jammy64"
    node.vm.hostname = "k8s-node"
    node.vm.network "private_network", ip: "192.168.56.20"
    node.vm.network "forwarded_port", guest: 30000, host: 30000  # K8s NodePort
    
    node.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-node"
      vb.memory = 3072
      vb.cpus = 2
    end
    
    node.vm.provision "shell", inline: <<-SHELL
      apt-get update
      
      # Disable swap
      swapoff -a
      sed -i '/ swap / s/^/#/' /etc/fstab
      
      # Install Docker
      curl -fsSL https://get.docker.com -o get-docker.sh
      sh get-docker.sh
      
      # Configure Docker for K8s
      cat > /etc/docker/daemon.json <<DOCKEREOF
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
DOCKEREOF
      
      systemctl daemon-reload
      systemctl restart docker
      
      # Install Kubernetes
      curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
      
      apt-get update
      apt-get install -y kubelet kubeadm kubectl
      apt-mark hold kubelet kubeadm kubectl
      
      # Load kernel modules
      modprobe br_netfilter
      
      # Configure sysctl
      cat > /etc/sysctl.d/k8s.conf <<SYSCTLEOF
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
SYSCTLEOF
      
      sysctl --system
      
      echo "=========================================="
      echo "K8s node ready for: kubeadm init"
      echo "=========================================="
    SHELL
  end
  
  # VM 3: Monitoring
  config.vm.define "monitoring" do |node|
    node.vm.box = "ubuntu/jammy64"
    node.vm.hostname = "monitoring"
    node.vm.network "private_network", ip: "192.168.56.30"
    node.vm.network "forwarded_port", guest: 9090, host: 9090  # Prometheus
    node.vm.network "forwarded_port", guest: 3000, host: 3000  # Grafana
    
    node.vm.provider "virtualbox" do |vb|
      vb.name = "monitoring"
      vb.memory = 2048
      vb.cpus = 2
    end
    
    node.vm.provision "shell", inline: <<-SHELL
      apt-get update
      
      # Install Docker
      curl -fsSL https://get.docker.com -o get-docker.sh
      sh get-docker.sh
      usermod -aG docker vagrant
      
      # Install Docker Compose
      curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
      
      echo "=========================================="
      echo "Prometheus: http://192.168.56.30:9090"
      echo "Grafana: http://192.168.56.30:3000"
      echo "=========================================="
    SHELL
  end
  
end
