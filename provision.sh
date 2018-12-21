#!/bin/bash

PLAYBOOK=$1

# Update apt cache (if old)
last_update=$(stat -c %Y /var/cache/apt/pkgcache.bin)
now=$(date +%s)
if [ $((now - last_update)) -gt 84600 ]; then
  apt-get update
fi

# Install Ansible (if required)
if ! [ -x "$(command -v locale-gen)" ]; then
    apt-get update
    # Install locales package
    apt-get install -y locales
    # Uncomment en_US.UTF-8 for inclusion in generation
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
    # Generate locale
    locale-gen
fi

# Install Ansible (if required)
if ! [ -x "$(command -v ansible)" ]; then
    apt-get update
    apt-get install -y python-pip
    pip install ansible
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
