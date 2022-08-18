#!/bin/bash

# Update the system
echo "Updating the system..."
sudo dnf update -y

# Install ansible
echo "Installing ansible and dialog..."
sudo dnf install -y ansible dialog

# Check the version of Ansible
echo "Installed version of Ansible:"
ansible --version

# eof
