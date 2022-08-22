#!/bin/bash

# Update the system
echo "Updating the system..."
sudo dnf update -y

# Install ansible
echo "Installing ansible, dialog, and python..."
sudo dnf install -y ansible dialog python

# Check the version of installed packages
echo "Installed version of Ansible:"
ansible --version

echo "Installed version of Dialog:"
dialog --version

echo "Installed version of Python:"
python --version

# eof
