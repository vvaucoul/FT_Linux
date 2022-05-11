# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    install_softwares_02.sh                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/09 17:53:59 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/09 18:21:36 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# M4
tar -xvf m4-1.4.19.tar.xz
cd m4-1.4.19
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
cd ..
rm -rf m4-1.4.19

# Ncurses

tar -xvf ncurses-6.3.tar.gz
cd ncurses-6.3
sed -i s/mawk// configure
mkdir build
pushd build
  ../configure
  make -C include
  make -C progs tic
popd
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-debug              \
            --without-ada                \
            --without-normal             \
            --disable-stripping          \
            --enable-widec
make
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so
cd ..
rm -rf ncurses-6.3

# Bash

tar -xvf bash-5.1.16.tar.gz
cd bash-5.1.16
./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc
make
make DESTDIR=$LFS install
ln -sv bash $LFS/bin/sh
cd ..
rm -rf bash-5.1.16

# Coreutils

tar -xvf coreutils-9.0.tar.xz
cd coreutils-9.0
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
make
make DESTDIR=$LFS install
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8
cd ..
rm -rf coreutils-9.0

# DiffUtils

tar -xvf diffutils-3.8.tar.xz
cd diffutils-3.8
./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install
cd ..
rm -rf diffutils-3.8

# File

tar -xvf file-5.41.tar.gz
cd file-5.41
mkdir build
pushd build
../configure --disable-bzlib      \
             --disable-libseccomp \
             --disable-xzlib      \
             --disable-zlib
make
popd
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$LFS install
cd ..
rm -rf file-5.41

# FindUtils

tar -xvf findutils-4.9.0.tar.xz
cd findutils-4.9.0
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
cd ..
rm -rf findutils-4.9.0

# Gawk

tar -xvf gawk-5.1.1.tar.xz
cd gawk-5.1.1
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make            
make DESTDIR=$LFS install
cd ..
rm -rf gawk-5.1.1

# Grep

tar -xvf grep-3.7.tar.xz
cd grep-3.7
./configure --prefix=/usr   \
            --host=$LFS_TGT
make            
make DESTDIR=$LFS install
cd ..
rm -rf grep-3.7

# Gzip

tar -xvf gzip-1.11.tar.xz
cd gzip-1.11
./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install
cd ..
rm -rf gzip-1.11

# Make

tar -xvf make-4.3.tar.gz
cd make-4.3
./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
cd ..
rm -rf make-4.3

# Patch

tar -xvf patch-2.7.6.tar.xz
cd patch-2.7.6
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
cd ..
rm -rf patch-2.7.6

# Sed

tar -xvf sed-4.8.tar.xz
cd sed-4.8
./configure --prefix=/usr   \
            --host=$LFS_TGT
make
make DESTDIR=$LFS install
cd ..
rm -rf sed-4.8

# Tar

tar -xvf tar-1.34.tar.xz
cd tar-1.34
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
cd ..
rm -rf tar-1.34

# Xz

tar -xvf xz-5.2.5.tar.xz
cd xz-5.2.5
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.2.5
make
make DESTDIR=$LFS install
cd ..
rm -rf xz-5.2.5