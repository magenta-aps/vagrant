#!/bin/bash

SCRIPT_SUM=$(md5sum $0 | cut -f1 -d' ')
VALIDATION_ARG=$1
if [ "$VALIDATION_ARG" != "$SCRIPT_SUM" ]; then
    echo "Script called without the script sum commandline argument!"
    echo "This script should not be called directly by the host."
    echo "Calling this script from the host, will destroy your computer."
    echo "Please don't call this with script sum as a commandline argument!"
    echo ""
    echo "Consider yourself warned!"
    exit 1
fi

echo ""
echo "---------------------"
echo "Adding new partitions"
echo "---------------------"
echo ""

(
echo n # Add a new partition
echo p # Primary partition
echo 3 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo n # Add a new partition
echo p # Primary partition (4)
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/sda
sync

echo ""
echo "-----------------"
echo "Installing parted"
echo "-----------------"
echo ""

sudo apt-get update
sudo apt-get install -y parted

echo ""
echo "-----------------"
echo "Running partprobe"
echo "-----------------"
echo ""

sudo partprobe

echo ""
echo "----------------------------------"
echo "Duplicating current boot partition"
echo "----------------------------------"
echo ""

sudo dd if=/dev/sda1 of=/dev/sda4 bs=4M
sync

echo ""
echo "---------------------"
echo "Updating grub entries"
echo "---------------------"
echo ""

sudo rm /etc/grub.d/10_linux
sudo update-grub

echo ""
echo "-----------------------"
echo "Rebooting to new kernel"
echo "-----------------------"
echo ""

true
