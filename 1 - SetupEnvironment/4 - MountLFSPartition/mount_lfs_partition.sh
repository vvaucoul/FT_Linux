#!/bin/bash

mkdir -pv $LFS
mount -v -t ext4 /dev/sdb4 $LFS
mkdir -pv $LFS/{boot,root,home}
mount -v -t ext2 /dev/sdb1 $LFS/boot
mount -v -t ext4 /dev/sdb2 $LFS/root
swapon -v /dev/sdb3

lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb