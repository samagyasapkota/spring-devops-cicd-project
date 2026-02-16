#!/bin/bash
set -e
echo "Setting up monitoring..."
cd /vagrant/monitoring
docker-compose up -d
echo "Prometheus & Grafana started!"
