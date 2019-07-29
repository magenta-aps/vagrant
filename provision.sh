#!/bin/bash

PLAYBOOK=$1
BOX_IMAGE=$2

# Update apt cache (if old)
last_update=$(stat -c %Y /var/cache/apt/pkgcache.bin)
now=$(date +%s)
if [ $((now - last_update)) -gt 84600 ]; then
  apt-get update
fi

# Install Ansible (if required)
if ! [ -x "$(command -v ansible)" ]; then
    if [  $BOX_IMAGE = 'ubuntu/bionic64' ]; then
        # Ubuntu
        apt-get install software-properties-common
        apt-add-repository ppa:ansible/ansible
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get install -y ansible
    elif [ $BOX_IMAGE = 'debian/stretch64' ]; then
        # Debian
        echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/strecth-backports.list
        apt-get update
        apt-get install -t stretch-backports -y ansible
    else
        echo "error in provision.sh : Cannot install ansible, because the box_image($BOX_IMAGE) is unknown, please add an entry in provision.sh with installation instructions for the given image"
        exit 1
    fi
fi

# Install git (if required)
if ! [ -x "$(command -v git)" ]; then
    apt-get install -y git
fi

# Ansible variables
ROLES_PATH=/vagrant/ansible/roles/
REQUIREMENTS_PATH=/vagrant/ansible/requirements.yml
PLAYBOOK_PATH=/vagrant/ansible/playbooks/$PLAYBOOK

# Install the playbook requirements
ANSIBLE_STDOUT_CALLBACK=debug ANSIBLE_ROLES_PATH=$ROLES_PATH PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true \
ansible-galaxy install -r $REQUIREMENTS_PATH

# Run the playbook
cd /vagrant/
ANSIBLE_STDOUT_CALLBACK=debug ANSIBLE_ROLES_PATH=$ROLES_PATH PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true \
ansible-playbook --timeout=30 -vv -i "localhost," -c local $PLAYBOOK_PATH
