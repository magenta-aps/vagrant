#!/bin/bash

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
