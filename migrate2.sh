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
echo "--------------------"
echo "Nuking old partition"
echo "--------------------"
echo ""

sudo dd if=/dev/zero of=/dev/sda1 bs=4M
sync

(
echo d # Add a new partition
echo 1 # Primary partition
echo w # Partition number
) | sudo fdisk /dev/sda
sync

echo ""
echo "-----------------"
echo "Running partprobe"
echo "-----------------"
echo ""

partprobe

echo ""
echo "--------------------"
echo "Expanding filesystem"
echo "--------------------"
echo ""

sudo resize2fs /dev/sda4
sync

echo ""
echo "---------------------"
echo "Updating grub entries"
echo "---------------------"
echo ""

sudo update-grub

echo ""
echo "--------------------"
echo "Machine provisioned!"
echo "--------------------"
echo ""

true
