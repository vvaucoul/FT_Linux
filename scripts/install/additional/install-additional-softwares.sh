# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    install-additional-softwares.sh                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/23 10:45:30 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/23 12:37:19 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

# Emacs - Dependences

# Nettle
tar xvf nettle-3.7.3.tar.gz
cd nettle-3.7.3
./configure --prefix=/usr --disable-static &&
make
make check
make install &&
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.7.3 &&
install -v -m644 nettle.html /usr/share/doc/nettle-3.7.3
cd ..
rm -rf nettle-3.7.3

# Libtasn1
tar xvf libtasn1-4.18.0.tar.gz
cd libtasn1-4.18.0
./configure --prefix=/usr --disable-static &&
make
make check
make install
make -C doc/reference install-data-local
cd ..
rm -rf libtasn1-4.18.0

# Libunistring
tar xvf libunistring-1.0.tar.xz
cd libunistring-1.0
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-1.0 &&
make
make check
make install
cd ..
rm -rf libunistring-1.0

# P11-kit
tar xvf p11-kit-0.24.1.tar.xz
cd p11-kit-0.24.1
sed '20,$ d' -i trust/trust-extract-compat &&
cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF
mkdir p11-build &&
cd    p11-build &&

meson --prefix=/usr       \
      --buildtype=release \
      -Dtrust_paths=/etc/pki/anchors &&
ninja
ninja test
ninja install &&
ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates
ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
cd ../..
rm -rf p11-kit-0.24.1         

# Gnutls
tar xvf gnutls-3.7.3.tar.xz
cd gnutls-3.7.3
./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.7.3 \
            --disable-guile \
            --disable-rpath \
            --with-default-trust-store-pkcs11="pkcs11:" &&
make
make install
cd ..
rm -rf gnutls-3.7.3

# Emacs
tar xvf emacs-27.2.tar.xz
cd emacs-27.2
sed -e '/SIGSTKSZ/ s|^.*$|static max_align_t sigsegv_stack[\
   (64 * 1024 + sizeof (max_align_t) - 1) / sizeof (max_align_t)];|' \
    -i src/sysdep.c
./configure --prefix=/usr &&
make
make install &&
chown -v -R root:root /usr/share/emacs/27.2 &&
rm -vf /usr/lib/systemd/user/emacs.service
cd ..
rm -rf emacs-27.2

# Nano
tar xvf nano-6.2.tar.xz
cd nano-6.2
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-6.2 &&
make
make install &&
install -v -m644 doc/{nano.html,sample.nanorc} /usr/share/doc/nano-6.2
cat > /etc/nanorc << "EOF"
set autoindent
set constantshow
set fill 72
set historylog
set multibuffer
set nohelp
set positionlog
set quickblank
set regexp
set suspend
EOF
cd ..
rm -rf nano-6.2

# Wget
tar xvf wget-1.6.tar.gz
cd wget-1.6
./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make
make install
cd ..
rm -rf wget-1.6

# Valgrind
tar xvf valgrind-3.18.1.tar.bz2
cd valgrind-3.18.1
patch -Np1 -i ../valgrind-3.18.1-upstream_fixes-1.patch
sed -i 's|/doc/valgrind||' docs/Makefile.in &&

./configure --prefix=/usr \
            --datadir=/usr/share/doc/valgrind-3.18.1 &&
make
sed -e 's@prereq:.*@prereq: false@' \
    -i {helgrind,drd}/tests/pth_cond_destroy_busy.vgtest
make install
cd ..
rm -rf valgrind-3.18.1

# Tree
tar xvf tree-2.0.2.tgz
cd tree-2.0.2
make
make PREFIX=/usr MANDIR=/usr/share/man install &&
chmod -v 644 /usr/share/man/man1/tree.1
cd ..
rm -rf tree-2.0.2

# LibSSH
tar xvf libssh2-1.10.0.tar.gz
cd libssh2-1.10.0
./configure --prefix=/usr --disable-static &&
make
make install
cd ..
rm -rf libssh2-1.10.0

# OpenSSH
tar xvf openssh-8.8p1.tar.gz
cd openssh-8.8p1
install  -v -m700 -d /var/lib/sshd &&
chown    -v root:sys /var/lib/sshd &&

groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd
./configure --prefix=/usr                            \
            --sysconfdir=/etc/ssh                    \
            --with-md5-passwords                     \
            --with-privsep-path=/var/lib/sshd        \
            --with-default-path=/usr/bin             \
            --with-superuser-path=/usr/sbin:/usr/bin \
            --with-pid-dir=/run
make
make install &&
install -v -m755    contrib/ssh-copy-id /usr/bin     &&

install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
install -v -m755 -d /usr/share/doc/openssh-8.8p1     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-8.8p1
cd ..
rm -rf openssh-8.8p1

# Curl
tar xvf curl-7.81.0.tar.xz
cd curl-7.81.0
./configure --prefix=/usr                           \
            --disable-static                        \
            --with-openssl                          \
            --enable-threaded-resolver              \
            --with-ca-path=/etc/ssl/certs &&
make
make install &&

rm -rf docs/examples/.deps &&

find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&

install -v -d -m755 /usr/share/doc/curl-7.81.0 &&
cp -v -R docs/*     /usr/share/doc/curl-7.81.0
cd ..
rm -rf curl-7.81.0

# ZSH

tar xvf zsh-5.9.tar.xz
cd zsh-5.9
tar --strip-components=1 -xvf ../zsh-5.9-doc.tar.xz
./configure --prefix=/usr         \
            --sysconfdir=/etc/zsh \
            --enable-etcdir=/etc/zsh                  &&
make                                                  &&

makeinfo  Doc/zsh.texi --plaintext -o Doc/zsh.txt     &&
makeinfo  Doc/zsh.texi --html      -o Doc/html        &&
makeinfo  Doc/zsh.texi --html --no-split --no-headers -o Doc/zsh.html
make install                              &&
make infodir=/usr/share/info install.info &&

install -v -m755 -d                 /usr/share/doc/zsh-5.9/html &&
install -v -m644 Doc/html/*         /usr/share/doc/zsh-5.9/html &&
install -v -m644 Doc/zsh.{html,txt} /usr/share/doc/zsh-5.9
make htmldir=/usr/share/doc/zsh-5.9/html install.html &&
install -v -m644 Doc/zsh.dvi /usr/share/doc/zsh-5.9
cat >> /etc/shells << "EOF"
/bin/zsh
EOF

# Git
tar xvf git-2.35.1.tar.xz
cd git-2.35.1
cp ../git-manpages-2.35.1.tar.xz .
cp ../git-htmldocs-2.35.1.tar.xz .
./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3 &&
make
make perllibdir=/usr/lib/perl5/5.34/site_perl install
tar -xf ../git-manpages-2.35.1.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir
mkdir -vp   /usr/share/doc/git-2.35.1 &&
tar   -xf   ../git-htmldocs-2.35.1.tar.xz \
      -C    /usr/share/doc/git-2.35.1 --no-same-owner --no-overwrite-dir &&

find        /usr/share/doc/git-2.35.1 -type d -exec chmod 755 {} \; &&
find        /usr/share/doc/git-2.35.1 -type f -exec chmod 644 {} \;    
mkdir -vp /usr/share/doc/git-2.35.1/man-pages/{html,text}         &&
mv        /usr/share/doc/git-2.35.1/{git*.txt,man-pages/text}     &&
mv        /usr/share/doc/git-2.35.1/{git*.,index.,man-pages/}html &&

mkdir -vp /usr/share/doc/git-2.35.1/technical/{html,text}         &&
mv        /usr/share/doc/git-2.35.1/technical/{*.txt,text}        &&
mv        /usr/share/doc/git-2.35.1/technical/{*.,}html           &&

mkdir -vp /usr/share/doc/git-2.35.1/howto/{html,text}             &&
mv        /usr/share/doc/git-2.35.1/howto/{*.txt,text}            &&
mv        /usr/share/doc/git-2.35.1/howto/{*.,}html               &&

sed -i '/^<a href=/s|howto/|&html/|' /usr/share/doc/git-2.35.1/howto-index.html &&
sed -i '/^\* link:/s|howto/|&html/|' /usr/share/doc/git-2.35.1/howto-index.txt
cd ..
rm -rf git-2.35.1