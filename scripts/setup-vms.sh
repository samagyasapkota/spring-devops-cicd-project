#!/bin/bash
# Run this from Windows/Cygwin to provision VMs

echo "Starting VM provisioning..."
vagrant up

echo "Setting up k8s-node-1..."
vagrant ssh k8s-node-1 -c "sudo bash /vagrant/scripts/setup-k8s-node.sh"

echo "Setting up k8s-node-2..."
vagrant ssh k8s-node-2 -c "sudo bash /vagrant/scripts/setup-k8s-node.sh"

echo "VM setup complete!"
