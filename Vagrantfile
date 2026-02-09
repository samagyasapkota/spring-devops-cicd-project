# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Define VMs
  machines = {
    "jenkins" => { ip: "192.168.56.10", memory: 2048, cpus: 2 },
    "app-server" => { ip: "192.168.56.11", memory: 2048, cpus: 2 },
    "k8s-master" => { ip: "192.168.56.20", memory: 2048, cpus: 2 },
    "k8s-worker1" => { ip: "192.168.56.21", memory: 2048, cpus: 2 },
    "k8s-worker2" => { ip: "192.168.56.22", memory: 2048, cpus: 2 },
    "monitoring" => { ip: "192.168.56.30", memory: 2048, cpus: 2 }
  }

  machines.each do |name, config_data|
    config.vm.define name do |machine|
      machine.vm.box = "ubuntu/jammy64"  # Ubuntu 22.04
      machine.vm.hostname = name
      machine.vm.network "private_network", ip: config_data[:ip]
      
      machine.vm.provider "virtualbox" do |vb|
        vb.name = name
        vb.memory = config_data[:memory]
        vb.cpus = config_data[:cpus]
      end

      # Provision with basic tools
      machine.vm.provision "shell", inline: <<-SHELL
        apt-get update
        apt-get install -y curl wget git vim net-tools
        
        # Install Docker on all machines
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        usermod -aG docker vagrant
        
        # Install Docker Compose
        curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
      SHELL
    end
  end
end
