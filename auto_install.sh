# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    auto_install.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/14 11:56:00 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/14 11:59:01 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Auto install LFS with this script

# Check Root
if [ "$EUID" -ne 0 ]
  then echo "Error: run this script as root..."
  exit
fi

# Update Host system
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove --purge -y </dev/null
sudo apt-get autoclean -y </dev/null
sudo apt-get clean -y </dev/null
sudo rm -rf /bin/sh
sudo ln -s /usr/bin/bash /bin/sh
sudo apt-get install apt-file automake build-essential git liblocale-msgfmt-perl locales-all parted bison make patch texinfo gawk vim g++ bash gzip binutils findutils gawk gcc libc6 grep gzip m4 make patch perl sed tar texinfo xz-utils bison curl libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf --fix-missing -y

# Check LFS Script version-check
sh ./scripts/check/version-check.sh
sh ./scripts/check/version-check.sh | grep "introuvable"
res=$?

if [ $res != 1 ]
then
    echo "Error: install packages requiered by LFS..."
    exit 1
fi
sh ./scripts/check/version-check.sh | grep "échouée"
res=$?

if [ $res != 1 ]
then
    echo "Error: install packages requiered by LFS..."
    exit 1
fi

# Check if SDB disk is valid
lsblk /dev/sdb
var=$?

if [ $var != 0 ]
then
    echo "Before format partitions, insert a second disk..."
    exit 1
fi

# Create Partitions on Disk SDB
printf 'g\nn\n\n\n+1M\nt\n4\nn\n\n\n+200M\nt\n2\n1\nn\n\n\n+4G\nt\n3\n19\nn\n\n\n\nw\n' | fdisk /dev/sdb

# Verification
lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb
sleep 1

# Preparations
cd ~
export LFS=/mnt/lfs
mkdir -v $LFS
mount -v -t ext4 /dev/sdb4 $LFS

# Restore LFS Default                                                                              
rm -vrf /mnt/lfs/*

swapoff /dev/sdb3
mkswap /dev/sdb3
swapon /dev/sdb3
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

# Verification 02 
lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb
sleep 1


curl https://raw.githubusercontent.com/vvaucoul/FT_Linux/main/wget-list > wget-list
curl https://raw.githubusercontent.com/vvaucoul/FT_Linux/main/md5sums > md5sums

wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
cp md5sums $LFS/sources/md5sums

rm -rf ./wget-list ./md5sums

pushd $LFS/sources
md5sum -c md5sums
popd
