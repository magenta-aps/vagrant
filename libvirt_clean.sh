#!/bin/bash

NAME="vagrant_default"

MACHINE_ID=$(sudo virsh list --all | grep "$NAME" | cut -f2 -d' ')
# Destroy everything
sudo virsh destroy $MACHINE_ID
sudo virsh vol-delete --pool default ${NAME}.img
sudo vagrant destroy -f
