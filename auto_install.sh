# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    auto_install.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/14 11:56:00 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/15 14:51:52 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Auto install LFS with this script

# Check Root
if [ "$EUID" -ne 0 ]
  then echo "Error: run this script as root..."
  exit
fi

OPATH=$(pwd)

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
sh $OPATH/scripts/check/version-check.sh
sh $OPATH/scripts/check/version-check.sh | grep "introuvable"
res=$?

if [ $res != 1 ]
then
    echo "Error: install packages requiered by LFS..."
    exit 1
fi
sh $OPATH/scripts/check/version-check.sh | grep "échouée"
res=$?

if [ $res != 1 ]
then
    echo "Error: install packages requiered by LFS..."
    exit 1
fi
sh $OPATH/scripts/check/version-check.sh | grep "not"
res=$?

if [ $res != 1 ]
then
    echo "Error: install packages requiered by LFS..."
    exit 1
fi

# Reset Sudoers File
ls /etc/sudoers.bak
res=$?
if [ $res == 0 ]
then
    rm -rf /etc/sudoers
    mv /etc/sudoers.bak /etc/sudoers
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

# Download Archives
curl https://raw.githubusercontent.com/vvaucoul/FT_Linux/main/wget-list > wget-list
curl https://raw.githubusercontent.com/vvaucoul/FT_Linux/main/md5sums > md5sums

ls $OPATH/archives
if [ $? != 0 ]
then
    wget --input-file=wget-list --continue --directory-prefix=$OPATH/archives
fi

cp -rf $OPATH/archives/* $LFS/sources/
cp md5sums $LFS/sources/md5sums
rm -rf ./wget-list ./md5sums

pushd $LFS/sources
md5sum -c md5sums
popd

# Check archives
cd $OPATH
sh $OPATH/scripts/check/check_archives.sh
sh $OPATH/scripts/check/check_archives.sh | grep "Not Found" > /dev/null
var=$?

if [ $var == 0 ]
then
    echo "Error when downloading archives..."
    exit 1
fi

# Preparation Suite
mkdir -v $LFS/tools
ln -sv $LFS/tools /
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

# LFS User
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
printf 'toor\ntoor\n' | passwd lfs

# Preparation Suite
chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

# Set LFS User Sudo without password
chmod 755 /etc/sudoers
cp /etc/sudoers /etc/sudoers.bak
cat /etc/sudoers | grep "lfs"
if [ $? != 0 ]
then
    echo "lfs ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

# Check LFS Script version-check
echo "dash dash/sh boolean false" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
apt-get install -y gawk
apt-get install -y bison
apt-get install -y build-essential
apt-get update && apt-get upgrade -y

curl http://www.linuxfromscratch.org/lfs/view/stable/chapter02/hostreqs.html | grep -A53 "# Simple script to list version numbers of critical development tools" | sed 's:</code>::g' | sed 's:&gt;:>:g' | sed 's:&lt;:<:g' | sed 's:&amp;:\&:g' | sed 's:failed:not OK:g' > version-check.sh
bash version-check.sh | grep not
rm -rf version-check.sh

# Init LFS Shell
cd $OPATH
cp -f ./scripts/lfs/init-lfs-shell.sh /home/lfs/init-lfs-shell.sh
cp -f ./scripts/lfs/check-lfs-initialisation.sh /home/lfs/check-lfs-initialisation.sh
chmod 755 /home/lfs/init-lfs-shell.sh
chmod 755 /home/lfs/check-lfs-initialisation.sh

cp -f ./scripts/auto-install/auto-install-01.sh /home/lfs/auto-install-01.sh
chmod 755 /home/lfs/auto-install-01.sh
cp -f ./scripts/install/install_softwares.sh $LFS/sources/install_softwares.sh
cp -f ./scripts/install/install_softwares_02.sh $LFS/sources/install_softwares_02.sh
cp -f ./scripts/install/install_softwares_03.sh $LFS/sources/install_softwares_03.sh

export LFS=/mnt/lfs
chmod 755 $LFS/sources/install_softwares.sh $LFS/sources/install_softwares_02.sh $LFS/sources/install_softwares_03.sh

printf "\n\nNow, enter in lfs user (su - lfs with password: 'toor')\n\
and execute the script: 'init-lfs-shell && check-lfs-initialisation' in root of lfs shell...\n\
Execute the script 'init-lfs-shell && check-lfs-initialisation' with sudo su as lfs user\n\
Then, launch the script auto-install-01 with sudo su as lfs user !\n\n\
Commands to do:\n
\t- su - lfs
\t- ./init-lfs-shell
\t- ./check-lfs-initialisation
\t- sudo su
\t- ./init-lfs-shell
\t- ./check-lfs-initialisation
\t- ./auto-install-01
"
exit 0







#Creation des outils temporaires suplementaires
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac
export LFS=/mnt/lfs
mkdir -pv $LFS/{dev,proc,sys,run}
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

# CHROOT
mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

sudo chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login
