#!/bin/bash

## /boot: Ext2
sudo mkfs -v -t ext2 /dev/sdb1

## /: Ext4
sudo mkfs -v -t ext4 /dev/sdb2

## swap: Swap
sudo mkswap /dev/sdb3

## Check Partitions and Mounts
lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb