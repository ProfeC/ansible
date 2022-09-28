#!/bin/bash

# Reference: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

# Make sure Python is installed
printf "\n\n\nChecking for Python v3...\n"
if [ ! "$(which python3)" ]; then
    printf "\n\n\nPython3 is not installed. Please install it before continuing.\n\n\n"
    exit 0
else
    printf "\nYou have:\n"
    python3 --version
fi

# Make sure cURL is installed
printf "\n\n\nChecking for cURL..."
if [ ! "$(which curl)" ]; then
    printf "cURL is not installed. Please install it before continuing.\n\n\n"
    exit 0
else
    printf "\nYou have:\n"
    curl --version
fi

# Make sure pip is available
printf "\n\n\nChecking for 'pip'...\n"

# If you see an error like No module named pip, you’ll need to install pip under your chosen Python 
# interpreter before proceeding. This may mean installing an additional OS package 
# (for example, python3-pip), or installing the latest pip directly from the Python Packaging 
# Authority by running the following:

if [ ! "$(which pip)" ]; then
    printf "\n\n\npip isn't installed! Installing it now.\n\n\n"
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --user
    python3 -m pip -V # check the version again, just to make sure it's there.
else 
    printf "\nYou have:\n"
    python3 -m pip -V
fi

# Install ansible
printf "\n\n\nInstalling ansible...\n"
python3 -m pip install --user ansible

# Check the version of installed packages
printf "\n\n\nInstalled version of Ansible:\n"
ansible --version

# eof
