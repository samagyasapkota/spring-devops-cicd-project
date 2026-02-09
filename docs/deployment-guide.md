# Spring PetClinic - Complete Deployment Guide

## Prerequisites
- VirtualBox 7.0+
- Vagrant 2.3+
- Git
- 8-12GB RAM
- 50GB Disk Space

## Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  jenkins-app    │    │   k8s-node      │    │   monitoring    │
│  192.168.56.10  │    │  192.168.56.20  │    │  192.168.56.30  │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ - Jenkins       │    │ - Kubernetes    │    │ - Prometheus    │
│ - Docker        │    │ - kubectl       │    │ - Grafana       │
│ - App Server    │    │ - kubeadm       │    │ - Node Exporter │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Step-by-Step Deployment

### Phase 1: Infrastructure Setup (30 mins)

1. **Start Vagrant VMs**
```bash
cd /drives/c/devops-project/spring-devops-cicd-project
vagrant up
```

2. **Verify VMs are running**
```bash
vagrant status
# All three VMs should show "running"
```

3. **SSH into jenkins-app**
```bash
vagrant ssh jenkins-app
```

### Phase 2: Jenkins Configuration (30 mins)

1. **Get Jenkins initial password**
```bash
vagrant ssh jenkins-app
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

2. **Access Jenkins**: http://192.168.56.10:8080
   - Paste initial password
   - Install suggested plugins
   - Create admin user

3. **Configure DockerHub Credentials**
   - Manage Jenkins → Credentials → System → Global credentials
   - Add credentials:
     - Kind: Username with password
     - Username: samagyasapkota
     - Password: [DockerHub password/token]
     - ID: dockerhub-credentials

4. **Create Pipeline**
   - New Item → Pipeline → "petclinic-pipeline"
   - Pipeline script from SCM
   - Git: https://github.com/samagyasapkota/spring-devops-cicd-project.git
   - Branch: staging
   - Script path: jenkins/Jenkinsfile

### Phase 3: Kubernetes Setup (1 hour)

1. **Initialize Kubernetes on k8s-node**
```bash
vagrant ssh k8s-node

# Initialize cluster
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --apiserver-advertise-address=192.168.56.20

# Setup kubectl for vagrant user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Flannel network plugin
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Allow scheduling on master (since we have only one node)
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

2. **Deploy Application to Kubernetes**
```bash
# On your host machine
cd /drives/c/devops-project/spring-devops-cicd-project

# Copy manifests to k8s-node
scp -r kubernetes vagrant@192.168.56.20:/home/vagrant/

# SSH to k8s-node
vagrant ssh k8s-node

# Apply manifests
kubectl apply -f kubernetes/secret.yml
kubectl apply -f kubernetes/configmap.yml
kubectl apply -f kubernetes/pvc.yml
kubectl apply -f kubernetes/deployment.yml
kubectl apply -f kubernetes/service.yml

# Verify deployment
kubectl get pods
kubectl get svc

# Scale to 5-10 pods
kubectl scale deployment petclinic-app --replicas=7
```

### Phase 4: Monitoring Setup (45 mins)

1. **Deploy monitoring stack**
```bash
vagrant ssh monitoring

# Copy monitoring configs
cd /vagrant/monitoring

# Start Prometheus and Grafana
docker-compose up -d

# Verify
docker-compose ps
```

2. **Setup Node Exporter on all VMs**
```bash
# On each VM (jenkins-app, k8s-node, monitoring)
docker run -d \
  --name=node-exporter \
  --restart=unless-stopped \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  prom/node-exporter:latest \
  --path.rootfs=/host
```

3. **Access Grafana**: http://192.168.56.30:3000
   - Login: admin / admin
   - Import Node Exporter Dashboard (ID: 1860)

### Phase 5: Backup Configuration (15 mins)

1. **Setup backup script**
```bash
vagrant ssh jenkins-app

# Copy backup script
sudo mkdir -p /opt/petclinic/scripts
sudo cp /vagrant/scripts/backup.sh /opt/petclinic/scripts/
sudo chmod +x /opt/petclinic/scripts/backup.sh

# Setup cron job
sudo /vagrant/scripts/setup-cron.sh

# Test backup manually
sudo /opt/petclinic/scripts/backup.sh
```

## Access URLs

- Jenkins: http://192.168.56.10:8080
- PetClinic App: http://192.168.56.10:8080/petclinic
- Kubernetes App: http://192.168.56.20:30080/petclinic
- Prometheus: http://192.168.56.30:9090
- Grafana: http://192.168.56.30:3000

## Troubleshooting

### Jenkins not accessible
```bash
vagrant ssh jenkins-app
sudo systemctl status jenkins
sudo systemctl restart jenkins
```

### Kubernetes pods not starting
```bash
vagrant ssh k8s-node
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Database backup failing
```bash
vagrant ssh jenkins-app
docker logs petclinic-mysql
ls -la /var/backups/petclinic/
```
