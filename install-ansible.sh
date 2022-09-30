#!/bin/sh

# Reference: https://github.com/neillturner/omnibus-ansible/blob/master/ansible_install.sh

if [ "$1" = "-v" ]; then
    ANSIBLE_VERSION="${2}"
fi

wait_for_cloud_init() {
    while pgrep -f "/usr/bin/python /usr/bin/cloud-init" >/dev/null 2>&1; do
        echo "Waiting for cloud-init to complete"
        sleep 1
    done
}

dpkg_check_lock() {
    while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
        echo "Waiting for dpkg lock release"
        sleep 1
    done
}

apt_install() {
    dpkg_check_lock && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        -o DPkg::Options::=--force-confold -o DPkg::Options::=--force-confdef "$@"
}

if [ ! "$(which ansible-playbook)" ]; then
    if [ -f /etc/debian_version ] || grep -qi ubuntu /etc/lsb-release || grep -qi ubuntu /etc/os-release; then
        wait_for_cloud_init
        dpkg_check_lock && apt-get update -q

        # Install Ansible and module dependencies
        apt_install ansible

    elif [ -f /etc/fedora-release ]; then
        # Install required Python libs and pip
        dnf install ansible

    else
        echo 'WARN: Could not detect distro or distro unsupported'
        echo 'WARN: Trying to install ansible via pip without some dependencies'
        echo 'WARN: Not all functionality of ansible may be available'
    fi

fi
