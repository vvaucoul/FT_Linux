# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    auto_install.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/14 11:56:00 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/15 12:16:02 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Auto install LFS with this script

# TMP
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

# Check Root
if [ "$EUID" -ne 0 ]
  then echo "Error: run this script as root..."
  exit
fi


debug=${1:-"debug"}
jumpto $debug


OPATH=$(pwd)
printf 'Original Path: '$OPATH'\n'
sleep 1

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
sh ./scripts/check/version-check.sh | grep "not"
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

curl https://raw.githubusercontent.com/vvaucoul/FT_Linux/main/wget-list > wget-list
curl https://raw.githubusercontent.com/vvaucoul/FT_Linux/main/md5sums > md5sums

wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
cp md5sums $LFS/sources/md5sums

rm -rf ./wget-list ./md5sums

pushd $LFS/sources
md5sum -c md5sums
popd

# Check archives
cd $OPATH
sh ./scripts/check/check_archives.sh
sh ./scripts/check/check_archives.sh | grep "Not Found"
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

debug:
OPATH=$(pwd)
printf 'Original Path: '$OPATH'\n'
export LFS=/mnt/lfs
printf 'LFS Path: '$LFS'\n'
sleep 1

# Init LFS Shell
cd $OPATH
cp -f ./scripts/lfs/init-lfs-shell.sh /home/lfs/init-lfs-shell.sh
cp -f ./scripts/lfs/check-lfs-initialisation.sh /home/lfs/check-lfs-initialisation.sh

su - lfs << EOF
pwd
ls
sudo sh init-lfs-shell.sh
sudo sh check-lfs-initialisation.sh

cat ~/.bashrc
cat ~/.bash_profile

printf 'LFS : '$LFS'\n'
printf 'LFS_TGT : '$LFS_TGT'\n'

EOF

exit 1

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

# Creation du systeme temporaire
chmod 755 /etc/sudoers
cp /etc/sudoers /etc/sudoers.bak
cat /etc/sudoers | grep "lfs"
if [ $? != 0 ]
then
    echo "lfs ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

cd $OPATH
pwd
cp -f ./scripts/lfs/install_softwares.sh $LFS/sources/install_softwares.sh
cp -f ./scripts/lfs/install_softwares_02.sh $LFS/sources/install_softwares_02.sh
cp -f ./scripts/lfs/install_softwares_03.sh $LFS/sources/install_softwares_03.sh

su - lfs << EOF
env
export LFS=/mnt/lfs
cd $LFS/sources/
pwd
sudo su << EOF2
cd $LFS/sources/
pwd
env
sh install_softwares.sh
EOF2
EOF
# sh install_softwares_02.sh
# sh install_softwares_03.sh

exit 1

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
