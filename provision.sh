#!/bin/bash

PLAYBOOK=$1

# Install Ansible
apt-get update
apt-get install -y ansible

# Run the playbook
cd /vagrant/
ANSIBLE_ROLES_PATH=/vagrant/ansible/roles/ \
PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook --timeout=30 \
    -vv -i "localhost," -c local ansible/playbooks/$PLAYBOOK
