# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    install_softwares_04.sh                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/03 15:41:28 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/11 00:53:29 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# GCC (Libstdc++)

tar -xvf gcc-11.2.0.tar.xz
cd gcc-11.2.0
ln -s gthr-posix.h libgcc/gthr-default.h
mkdir -v build
cd       build
../libstdc++-v3/configure            \
    CXXFLAGS="-g -O2 -D_GNU_SOURCE"  \
    --prefix=/usr                    \
    --disable-multilib               \
    --disable-nls                    \
    --host=$(uname -m)-lfs-linux-gnu \
    --disable-libstdcxx-pch
make
make install
cd ../..
rm -rf gcc-11.2

# Gettext

tar -xvf gettext-0.21.tar.xz
cd gettext-0.21
./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
cd ..
rm -rf gettext-0.21

# Bison

tar -xvf bison-3.8.2.tar.xz
cd bison-3.8.2
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make
make install
cd ..
rm -rf bison-3.8.2

# Perl

tar -xvf perl-5.34.0.tar.xz
cd perl-5.34.0
sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Dprivlib=/usr/lib/perl5/5.34/core_perl     \
             -Darchlib=/usr/lib/perl5/5.34/core_perl     \
             -Dsitelib=/usr/lib/perl5/5.34/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.34/site_perl    \
             -Dvendorlib=/usr/lib/perl5/5.34/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.34/vendor_perl
make
make install
cd ..
rm -rf perl-5.34.0

# Python

tar -xvf Python-3.10.2.tar.xz
cd Python-3.10.2
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip
make
make install
cd ..
rm -rf Python-3.10.2

# Texinfo

tar -xvf texinfo-6.8.tar.xz
cd texinfo-6.8
sed -e 's/__attribute_nonnull__/__nonnull/' \
    -i gnulib/lib/malloc/dynarray-skeleton.c
./configure --prefix=/usr
make
make install
cd ..
rm -rf texinfo-6.8

# Util-linux

tar -xvf util-linux-2.37.4.tar.xz
cd util-linux-2.37.4
mkdir -pv /var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
            --libdir=/usr/lib    \
            --docdir=/usr/share/doc/util-linux-2.37.4 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            runstatedir=/run
make
make install
cd ..
rm -rf util-linux-2.37.4