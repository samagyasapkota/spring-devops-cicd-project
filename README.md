# Spring Boot DevOps CI/CD Pipeline Project

Complete DevOps implementation with automated deployment pipeline.

## 🏗��� Architecture Components

- **Infrastructure as Code**: Vagrant, Terraform, Ansible
- **Containerization**: Docker, Docker Compose
- **CI/CD**: Jenkins Pipeline
- **Orchestration**: Kubernetes (kubeadm)
- **Monitoring**: Prometheus + Grafana
- **Automated Backups**: Cron jobs for database backups

## 📁 Project Structure
```
.
├── vagrant/              # VM infrastructure definitions
├── ansible/              # Configuration management
├── terraform/            # Cloud infrastructure (optional)
├── docker/              # Dockerfiles and compose files
├── kubernetes/          # K8s manifests
├── jenkins/             # CI/CD pipeline definitions
├── monitoring/          # Prometheus & Grafana configs
├── scripts/             # Backup and automation scripts
├── docs/                # Documentation and architecture diagrams
└── src/                 # Spring Boot application source
```

## 🚀 Quick Start

See [docs/deployment-guide.md](docs/deployment-guide.md) for detailed instructions.

## 📊 Infrastructure

- **VM 1**: Jenkins + Application Server (192.168.56.10)
- **VM 2**: Kubernetes Node (192.168.56.20)
- **VM 3**: Monitoring Stack (192.168.56.30)

## 🔗 Access Points

- Jenkins: http://192.168.56.10:8080
- Application: http://192.168.56.10:8081
- Kubernetes Dashboard: http://192.168.56.20:30000
- Prometheus: http://192.168.56.30:9090
- Grafana: http://192.168.56.30:3000

## 👤 Author

[Your Name]

## 📄 License

This project is for educational purposes.
