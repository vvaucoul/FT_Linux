<p align="center">
	![](https://cdn-icons-png.flaticon.com/512/226/226772.png)
</p>
#FT_LINUX

Creer sa distribution linux from scratch !

Tutoriel de reference: [LFS](http://fr.linuxfromscratch.org/view/lfs-stable/ "LFS")
- LFS 11.1
- Kernel Linux 5.xx

------------

### Creation de la VM

- Installez un linux en tant que systeme host pour creer notre LFS
- Linux Kernel 5.X
- Espace disque 16GB vdi
- Une fois installe, inserrez un second disque d une taille de 32GB qui contiendra notre LFS

### Prerequis

> SSH:

```bash
sudo su
apt-get update
apt-get upgrade -y
apt-get install -y openssh-server
exec <&-
ip address | grep inet
```

- Ajoutez une regle port forwarding sur virtual box




> Paquets a installer: 

```bash
sudo apt-get install bash gzip binutils findutils gawk gcc libc6 grep gzip m4 make patch perl python sed tar texinfo xz-utils bison curl -y
 sudo apt-get install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf -y
```

```bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove --purge -y </dev/null
sudo apt-get autoclean -y </dev/null
sudo apt-get clean -y </dev/null
sudo rm -rf /bin/sh
sudo ln -s /usr/bin/bash /bin/sh
sudo apt-get install apt-file automake build-essential git liblocale-msgfmt-perl locales-all parted bison make patch texinfo gawk vim g++ --fix-missing -y
sudo apt-file update
```

### Partitions

> - sudo su
> - fdisk /dev/sdb

```bash
 g
 n default default +1M
 t 4
 n default default +200M
 t 2 1
 n default default +4G
 t 3 19
 n default default default
 w
```

--------------

> - Resultat:

    NAME     UUID   FSTYPE   MOUNTPOINT    SIZE
    sdb                          							              32G
    ├─sdb1             							                      1M			# BIOS BOOT
    ├─sdb2             								              200M			# EFI SYSTEM
    ├─sdb3             								                  4G			#  LINUX SWAP
    └─sdb4             								             27,8G			#  ROOT /

```bash
 sudo mkfs -v -t ext2 /dev/sdb2
 sudo mkfs -v -t ext4 /dev/sdb4
 sudo mkswap /dev/sdb3
```

Verifications:
> - lsblk -o NAME,UUID,FSTYPE,MOUNTPOINT,SIZE /dev/sdb

### Preparations

```bash
cd
export LFS=/mnt/lfs
mkdir -v $LFS
mount -v -t ext4 /dev/sdb4 $LFS

swapoff /dev/sdb3
mkswap /dev/sdb3
swapon /dev/sdb3

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

curl https://www.linuxfromscratch.org/lfs/downloads/stable/wget-list > wget-list
curl https://www.linuxfromscratch.org/lfs/downloads/stable/md5sums > md5sums

wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
cp md5sums $LFS/sources/md5sums

pushd $LFS/sources
md5sum -c md5sums
popd
```

> Si vous rencontrez une erreur pour le fichier 'mpfr', lancez ce script:

```bash
wget https://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.xz > $LFS/sources/mpfr-4.1.0.tar.xz
wget https://www.mpfr.org/mpfr-current/mpfr-4.1.0.tar.xz.asc > $LFS/sources/mpfr-4.1.0.tar.xz.asc
```

> Si vous rencontrez une erreur pour le fichier 'zlib', lancez ce script:

```bash
wget https://zlib.net/zlib-1.2.12.tar.xz > $LFS/sources/zlib-1.2.11.tar.xz
wget https://zlib.net/zlib-1.2.12.tar.xz.asc > $LFS/sources/zlib-1.2.11.tar.xz.asc
```

> Puis relancez le script suivant:

```bash
pushd $LFS/sources
md5sum -c md5sums
popd
```

### Preparations suite...

```bash
mkdir -v $LFS/tools
ln -sv $LFS/tools /

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
printf 'toor\ntoor\n' | passwd lfs

chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

su - lfs

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

source ~/.bash_profile
export MAKEFLAGS='-j4'

exec <&-

echo "dash dash/sh boolean false" | debconf-set-selections
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
apt-get install -y gawk
apt-get install -y bison
apt-get install -y build-essential
apt-get update && apt-get upgrade -y

curl http://www.linuxfromscratch.org/lfs/view/stable/chapter02/hostreqs.html | grep -A53 "# Simple script to list version numbers of critical development tools" | sed 's:</code>::g' | sed 's:&gt;:>:g' | sed 's:&lt;:<:g' | sed 's:&amp;:\&:g' | sed 's:failed:not OK:g' > version-check.sh
bash version-check.sh | grep not
```

### Creation du systeme temporaire

    
```bash
chmod 755 /etc/sudoers
echo "lfs      ALL=(ALL:ALL) ALL" >> /etc/sudoers
su - lfs
sudo su
export LFS=/mnt/lfs
export MAKEFLAGS='-j4'
cd $LFS/sources/
```

> Avant de lancer les scripts, vérifiez que les variables d'environnement 'LFS' et 'LFS_TGT' existent et sont correctes.

> Lancez le script "install_softwares.sh"
> Lancez le script "install_softwares_02.sh"
> Lancez le script "install_softwares_03.sh"

### Creation des outils temporaires suplementaires

```bash
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac

mkdir -pv $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

mount -v --bind /dev $LFS/dev

mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi
```

```bash
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login
```

```bash
mkdir -pv /{boot,home,mnt,opt,srv}

mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
```

```bash
ln -sv /proc/self/mounts /etc/mtab

cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/usr/bin/false
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
nogroup:x:99:
users:x:999:
EOF

echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester

exec /usr/bin/bash --login

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
```

> Lancez le script "install_softwares_04.sh"

### Nettoyage & sauvegarde du systeme temporaire



```bash
rm -rf /usr/share/{info,man,doc}/*

find /usr/{lib,libexec} -name \*.la -delete

rm -rf /tools

exit
```

#### - Sauvegarde
> Temps de sauvegarde ~10 minutes

```bash
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}

cd $LFS
tar -cJpf $HOME/lfs-temp-tools-11.1.tar.xz .
```

#### - Restauration du systeme

```bash
cd $LFS
rm -rf ./*
tar -xpf $HOME/lfs-temp-tools-11.1.tar.xz
mount -v -t ext4 /dev/sdb4 $LFS

mount -v --bind /dev $LFS/dev

mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
```

### Construction du système LFS

```bash
grep -l  -e 'libfoo.*deleted' /proc/*/maps |
   tr -cd 0-9\\n | xargs -r ps u
```

> Lancez le script "install_softwares_05.sh"
