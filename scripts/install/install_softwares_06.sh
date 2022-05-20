# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    install_softwares_06.sh                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/19 18:26:55 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/20 13:06:42 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# End Bash

cd /sources
rm -rf bash-5.1.16

# LibTool

tar xvf libtool-2.4.6.tar.xz
cd libtool-2.4.6
./configure --prefix=/usr
make -j$(nproc)
make check
make install
rm -fv /usr/lib/libltdl.a
cd ..
rm -rf libtool-2.4.6

# GDBM

tar xvf gdbm-1.23.tar.gz
cd gdbm-1.23
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make -j$(nproc)
make check
make install
cd ..
rm -rf gdbm-1.23     

# GPerf

tar xvf gperf-3.1.tar.gz
cd gperf-3.1
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make -j$(nproc)
make -j1 check
make install
cd ..
rm -rf gperf-3.1

# Expat

tar xvf expat-2.4.6.tar.xz
cd expat-2.4.6
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.4.6
make -j$(nproc)
make check
make install
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.4.6
cd ..
rm -rf expat-2.4.6

# Inetutils

tar xvf inetutils-2.2.tar.xz
cd inetutils-2.2
./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make -j$(nproc)
make check
make install
mv -v /usr/{,s}bin/ifconfig
cd ..
rm -rf inetutils-2.2

# Less

tar xvf less-590.tar.gz
cd less-590
./configure --prefix=/usr --sysconfdir=/etc
make -j$(nproc)
make install
cd ..
rm -rf less-590

# Perl

tar xvf perl-5.34.0.tar.xz
cd perl-5.34.0
patch -Np1 -i ../perl-5.34.0-upstream_fixes-1.patch
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des                                         \
             -Dprefix=/usr                                \
             -Dvendorprefix=/usr                          \
             -Dprivlib=/usr/lib/perl5/5.34/core_perl      \
             -Darchlib=/usr/lib/perl5/5.34/core_perl      \
             -Dsitelib=/usr/lib/perl5/5.34/site_perl      \
             -Dsitearch=/usr/lib/perl5/5.34/site_perl     \
             -Dvendorlib=/usr/lib/perl5/5.34/vendor_perl  \
             -Dvendorarch=/usr/lib/perl5/5.34/vendor_perl \
             -Dman1dir=/usr/share/man/man1                \
             -Dman3dir=/usr/share/man/man3                \
             -Dpager="/usr/bin/less -isR"                 \
             -Duseshrplib                                 \
             -Dusethreads
make -j$(nproc)
make test
make install
unset BUILD_ZLIB BUILD_BZIP2
cd ..
rm -rf perl-5.34.0

# XML::Parser

tar xvf XML-Parser-2.46.tar.gz
cd XML-Parser-2.46
perl Makefile.PL
make -j$(nproc)
make test
make install
cd ..
rm -rf XML-Parser-2.46

# Intltool

tar xvf intltool-0.51.0.tar.gz
cd intltool-0.51.0
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make -j$(nproc)
make check
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
cd ..
rm -rf intltool-0.51.0

# Autoconf

tar xvf autoconf-2.71.tar.xz
cd autoconf-2.71
./configure --prefix=/usr
make -j$(nproc)
make check
make install
cd ..
rm -rf autoconf-2.71

# Automake

tar xvf automake-1.16.5.tar.xz
cd automake-1.16.5
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.5
make -j$(nproc)
make -j4 check
make install
cd ..
rm -rf automake-1.16.5

# OpenSSL

tar xvf openssl-3.0.1.tar.gz
cd openssl-3.0.1
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make -j$(nproc)
make test
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.0.1
cp -vfr doc/* /usr/share/doc/openssl-3.0.1
cd ..
rm -rf openssl-3.0.1

# KMod

tar xvf kmod-29.tar.xz
cd kmod-29
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --with-openssl         \
            --with-xz              \
            --with-zstd            \
            --with-zlib
make -j$(nproc)
make install

for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /usr/sbin/$target
done

ln -sfv kmod /usr/bin/lsmod
cd ..
rm -rf kmod-29

# Libelf

tar xvf elfutils-0.186.tar.bz2
cd elfutils-0.186
./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy
make -j$(nproc)
make check
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a
cd ..
rm -rf elfutils-0.186

# Libffi

tar xvf libffi-3.4.2.tar.gz
cd libffi-3.4.2
./configure --prefix=/usr          \
            --disable-static       \
            --with-gcc-arch=native \
            --disable-exec-static-tramp
make -j$(nproc)
make check
make install
cd ..
rm -rf libffi-3.4.2

# Python 3.10

tar xvf Python-3.10.2.tar.xz
cd Python-3.10.2
./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --with-system-ffi    \
            --with-ensurepip=yes \
            --enable-optimizations
make -j$(nproc)
make install
install -v -dm755 /usr/share/doc/python-3.10.2/html

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.10.2/html \
    -xvf ../python-3.10.2-docs-html.tar.bz2
cd ..
rm -rf Python-3.10.2

# Ninja

tar xvf ninja-1.10.2.tar.gz
cd ninja-1.10.2
export NINJAJOBS=4
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc
python3 configure.py --bootstrap
./ninja ninja_test
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
cd ..
rm -rf ninja-1.10.2

# Meson

tar xvf meson-0.61.1.tar.gz
cd meson-0.61.1
python3 setup.py build
python3 setup.py install --root=dest
cp -rv dest/* /
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson
cd ..
rm -rf meson-0.61.1

# CoreUtils

tar xvf coreutils-9.0.tar.xz
cd coreutils-9.0
patch -Np1 -i ../coreutils-9.0-i18n-1.patch
patch -Np1 -i ../coreutils-9.0-chmod_fix-1.patch
autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
make -j$(nproc)
make install
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
cd ..
rm -rf coreutils-9.0

# Check

tar xvf check-0.15.2.tar.gz
cd check-0.15.2
./configure --prefix=/usr --disable-static
make -j$(nproc)
make check
make docdir=/usr/share/doc/check-0.15.2 install
cd ..
rm -rf check-0.15.2

# Diffutils

tar xvf diffutils-3.8.tar.xz
cd diffutils-3.8
./configure --prefix=/usr
make -j$(nproc)
make check
make install
cd ..
rm -rf diffutils-3.8

# Gawk

tar xvf gawk-5.1.1.tar.xz
cd gawk-5.1.1
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make -j$(nproc)
make check
make install
mkdir -pv                                   /usr/share/doc/gawk-5.1.1
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.1
cd ..
rm -rf gawk-5.1.1

# FindUtils

tar xvf findutils-4.9.0.tar.xz
cd findutils-4.9.0
case $(uname -m) in
    i?86)   TIME_T_32_BIT_OK=yes ./configure --prefix=/usr --localstatedir=/var/lib/locate ;;
    x86_64) ./configure --prefix=/usr --localstatedir=/var/lib/locate ;;
esac
make -j$(nproc)
make check
make install
cd ..
rm -rf findutils-4.9.0

# Groff

tar xvf groff-1.22.4.tar.gz
cd groff-1.22.4
PAGE=A4 ./configure --prefix=/usr
make -j1
make install
cd ..
rm -rf groff-1.22.4

# Grub

tar xvf grub-2.06.tar.xz
cd grub-2.06
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror
make -j$(nproc)
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
cd ..
rm -rf grub-2.06

# GZip

tar xvf gzip-1.11.tar.xz
cd gzip-1.11
./configure --prefix=/usr
make -j$(nproc)
make check
make install
cd ..
rm -rf gzip-1.11

# IPRoute2

tar xvf iproute2-5.16.0.tar.xz
cd iproute2-5.16.0
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
make -j$(nproc)
make SBINDIR=/usr/sbin install
mkdir -pv             /usr/share/doc/iproute2-5.16.0
cp -v COPYING README* /usr/share/doc/iproute2-5.16.0
cd ..
rm -rf iproute2-5.16.0

# KBD

tar xvf kbd-2.4.0.tar.xz
cd kbd-2.4.0
patch -Np1 -i ../kbd-2.4.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make -j$(nproc)
make check
make install
mkdir -pv           /usr/share/doc/kbd-2.4.0
cp -R -v docs/doc/* /usr/share/doc/kbd-2.4.0
cd ..
rm -rf kbd-2.4.0

# LibPipeline

tar xvf libpipeline-1.5.5.tar.gz
cd libpipeline-1.5.5
./configure --prefix=/usr
make -j$(nproc)
make check
make install
cd ..
rm -rf libpipeline-1.5.5

# Make

tar xvf make-4.3.tar.gz
cd make-4.3
./configure --prefix=/usr
make -j$(nproc)
make check
make install
cd ..
rm -rf make-4.3

# Patch

tar xvf patch-2.7.6.tar.xz
cd patch-2.7.6
./configure --prefix=/usr
make -j$(nproc)
make check
make install
cd ..
rm -rf patch-2.7.6

# Tar

tar xvf tar-1.34.tar.xz
cd tar-1.34
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr
make -j$(nproc)
make check
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.34
cd ..
rm -rf tar-1.34

# Texinfo

tar xvf texinfo-6.8.tar.xz
cd texinfo-6.8
./configure --prefix=/usr
sed -e 's/__attribute_nonnull__/__nonnull/' \
    -i gnulib/lib/malloc/dynarray-skeleton.c
make -j$(nproc)
make check
make install
make TEXMF=/usr/share/texmf install-tex
pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd
cd ..
rm -rf texinfo-6.8

# Vim

tar xvf vim-8.2.4383.tar.gz
cd vim-8.2.4383
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make -j$(nproc)
"LANG=en_US.UTF-8 make -j1 test" &> vim-test.log
make install
ln -sfv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim82/doc /usr/share/doc/vim-8.2.4383
cat > /etc/vimrc << "EOF"
" Début de /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" Fin de /etc/vimrc
EOF
set spelllang=en,fr
set spell
cd ..
rm -rf vim-8.2.4383

# Eudev

tar xvf eudev-3.2.11.tar.gz
cd eudev-3.2.11
./configure --prefix=/usr           \
            --bindir=/usr/sbin      \
            --sysconfdir=/etc       \
            --enable-manpages       \
            --disable-static
make -j$(nproc)
mkdir -pv /usr/lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make check
make install
tar -xvf ../udev-lfs-20171102.tar.xz
make -f udev-lfs-20171102/Makefile.lfs install
udevadm hwdb --update
cd ..
rm -rf eudev-3.2.11

# Man db

tar xvf man-db-2.10.1.tar.xz
cd man-db-2.10.1
./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.10.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=
make -j$(nproc)
make check
make install
cd ..
rm -rf man-db-2.10.1

# Procps

tar xvf procps-ng-3.3.17.tar.xz
cd procps-3.3.17/
./configure --prefix=/usr                            \
            --docdir=/usr/share/doc/procps-ng-3.3.17 \
            --disable-static                         \
            --disable-kill
make -j$(nproc)
make check
make install
cd ..
rm -rf procps-3.3.17/

# Util linux

tar xvf util-linux-2.37.4.tar.xz
cd util-linux-2.37.4
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --bindir=/usr/bin    \
            --libdir=/usr/lib    \
            --sbindir=/usr/sbin  \
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
            --without-systemd    \
            --without-systemdsystemunitdir
make -j$(nproc)
make install
cd ..
rm -rf util-linux-2.37.4

# E2fsprog

tar xvf e2fsprogs-1.46.5.tar.gz
cd e2fsprogs-1.46.5
mkdir -v build
cd       build
../configure --prefix=/usr           \
             --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
make -j$(nproc)
make check
make install           
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
cd ../..
rm -rf e2fsprogs-1.46.5

# Sysklogd

tar xvf sysklogd-1.5.1.tar.gz
cd sysklogd-1.5.1
sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
sed -i 's/union wait/int/' syslogd.c
make -j$(nproc)
make BINDIR=/sbin install
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
cd ..
rm -rf sysklogd-1.5.1

# Sysvinit

tar xvf sysvinit-3.01.tar.xz
cd sysvinit-3.01
patch -Np1 -i ../sysvinit-3.01-consolidated-1.patch
make -j$(nproc)
make install
cd ..
rm -rf sysvinit-3.01