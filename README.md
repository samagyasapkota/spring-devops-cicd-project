# 🚀 Spring Boot DevOps CI/CD Pipeline Project

Complete DevOps implementation for the Spring PetClinic Java application — featuring automated CI/CD, Kubernetes orchestration, and full-stack monitoring with alerting.

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Host Machine (Windows)                    │
│                   192.168.56.1 (VirtualBox)                  │
└──────────┬──────────────┬──────────────────┬────────────────┘
           │              │                  │
    ┌──────▼──────┐ ┌─────▼──────┐  ┌───────▼───────┐
    │ jenkins-app │ │  k8s-node  │  │  monitoring   │
    │192.168.56.10│ │192.168.56.20│  │192.168.56.30  │
    │─────────────│ │────────────│  │───────────────│
    │ Jenkins     │ │ Kubernetes │  │ Prometheus    │
    │ Docker      │ │ kubeadm    │  │ Grafana       │
    │ Node Export │ │ Calico CNI │  │ Alertmanager  │
    │             │ │ 5x Pods    │  │ Node Exporter │
    └─────────────┘ └────────────┘  └───────────────┘
```

---

## 🛠️ Technology Stack

| Category | Technology | Details |
|---|---|---|
| Application | Spring PetClinic | Java / Maven 3.8.5 / OpenJDK 17 |
| Containerization | Docker + Docker Compose | eclipse-temurin:17-jdk-jammy |
| CI/CD | Jenkins | Declarative Pipeline — 6 stages |
| Container Registry | Docker Hub | samagyasapkota/spring-app |
| Orchestration | Kubernetes | v1.28.15 via kubeadm — 5 replicas |
| CNI | Calico | Pod networking |
| IaC — VM | Vagrant + VirtualBox | 3x Ubuntu 22.04 VMs |
| IaC — Cloud | Terraform | AWS EC2 + VPC (optional) |
| Config Management | Ansible | Automated deployment playbook |
| Monitoring | Prometheus + Grafana | Node Exporter Full dashboard |
| Alerting | Alertmanager | Email alerts via Gmail SMTP |
| Backup | Bash + Cron | Daily 10PM — 7-day retention |

---

## 📁 Project Structure

```
spring-devops-cicd-project/
├── Dockerfile                  # Multi-stage build (Maven → eclipse-temurin)
├── docker-compose.yml          # Local development compose
├── Jenkinsfile                 # 6-stage CI/CD pipeline
├── Vagrantfile                 # 3-VM infrastructure definition
├── .dockerignore               # Exclude target/ from build context
│
├── JavaApp-CICD/               # Spring PetClinic source code
│   ├── pom.xml
│   └── src/
│
├── k8s/                        # Kubernetes manifests
│   ├── deployment.yaml         # 5-replica deployment
│   └── service.yaml            # NodePort service on 30080
│
├── kubernetes/                 # Extended K8s manifests
│   ├── configmap.yml
│   ├── deployment.yml
│   ├── pvc.yml
│   ├── secret.yml
│   └── service.yml
│
├── monitoring/                 # Full monitoring stack
│   ├── docker-compose.yml      # Prometheus + Grafana + Alertmanager + Node Exporter
│   ├── prometheus/
│   │   ├── prometheus.yml      # Scrape configs for all 3 VMs
│   │   ├── alerts.yml          # CPU / RAM / Disk / ServiceDown rules
│   │   └── alertmanager.yml    # Gmail SMTP email alerts
│   └── grafana/
│       └── provisioning/       # Auto-provisioned datasource + dashboard
│
├── ansible/                    # Configuration management
│   ├── playbook.yml
│   ├── inventory
│   └── roles/
│
├── terraform/                  # AWS infrastructure (optional)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── scripts/                    # Automation scripts
│   ├── backup.sh               # MySQL backup (runs via cron at 10PM)
│   ├── db-migration.sh         # Database migration script
│   ├── setup-cron.sh           # Cron job setup
│   ├── setup-jenkins-app.sh    # VM provisioning
│   ├── setup-k8s-node.sh       # Kubernetes setup
│   └── setup-monitoring-vm.sh  # Monitoring setup
│
└── docs/                       # Documentation
```

---

## 🖥️ Virtual Machine Infrastructure

| VM | IP Address | RAM | Role |
|---|---|---|---|
| jenkins-app | 192.168.56.10 | 2GB | Jenkins CI/CD, Docker, Node Exporter |
| k8s-node | 192.168.56.20 | 3GB | Kubernetes control-plane + worker, 5 app pods |
| monitoring | 192.168.56.30 | 2GB | Prometheus, Grafana, Alertmanager, Node Exporter |

---

## 🔗 Access Points

| Service | URL | Credentials |
|---|---|---|
| Jenkins | http://localhost:8080 | admin / (configured) |
| PetClinic App | http://192.168.56.20:30080 | — |
| Prometheus | http://localhost:9090 | — |
| Grafana | http://localhost:3000 | admin / admin |
| Alertmanager | http://localhost:9093 | — |

---

## 🚀 Quick Start

### Prerequisites
- VirtualBox 6.x+
- Vagrant 2.x+
- Git

### 1. Clone the repository
```bash
git clone https://github.com/samagyasapkota/spring-devops-cicd-project.git
cd spring-devops-cicd-project
git checkout staging
```

### 2. Start all VMs
```bash
vagrant up
```

### 3. Access Jenkins
Open http://localhost:8080 and trigger the pipeline

### 4. Access the application
Open http://192.168.56.20:30080

### 5. Access monitoring
- Grafana: http://localhost:3000
- Prometheus: http://localhost:9090

---

## 🔄 CI/CD Pipeline Stages

```
Checkout → Build Maven → Build Docker Image → Push to DockerHub → Deploy to K8s → Scale to 5 Pods
```

| Stage | Description | Duration |
|---|---|---|
| Checkout | Pull from staging branch | ~2s |
| Build Maven | mvn clean package -DskipTests | ~1m 30s |
| Build Docker Image | Multi-stage Docker build | ~2m |
| Push to DockerHub | Push :BUILD_NUMBER and :latest | ~20s |
| Deploy to Kubernetes | kubectl set image + rollout | ~40s |
| Scale to 5 Pods | kubectl scale --replicas=5 | ~2s |

---

## 📊 Monitoring & Alerts

Prometheus scrapes metrics every 15 seconds from all 3 VMs via Node Exporter.

**Alert Rules:**
- 🔴 **HighCPUUsage** — CPU > 80% for 5 minutes
- 🔴 **HighMemoryUsage** — RAM > 80% for 5 minutes
- 🔴 **DiskSpaceLow** — Disk < 20% free for 5 minutes
- 🔴 **ServiceDown** — Any target down for 2 minutes

Alerts are sent via email using Gmail SMTP through Alertmanager.

Grafana dashboard: **Node Exporter Full** (ID: 1860)

---

## ⏰ Backup & Cron Job

Daily database backup runs at **10:00 PM** on jenkins-app:

```bash
# Cron schedule
0 22 * * * /opt/petclinic/scripts/backup.sh >> /var/log/petclinic-backup.log 2>&1
```

- Backups stored in `/var/backups/petclinic/`
- Compressed as `.sql.gz`
- 7-day retention (older files auto-deleted)

---

## 👤 Author

**Samagya Sapkota**
GitHub: [@samagyasapkota](https://github.com/samagyasapkota)

---

## 📄 License

This project is for educational purposes as part of a DevOps assignment.