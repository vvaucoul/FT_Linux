# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    install_softwares_05.sh                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/11 10:56:10 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/11 11:09:34 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Man

tar xvf man-pages-5.13.tar.xz
cd man-pages-5.13
make prefix=/usr install
cd ..
rm -rf man-pages-5.13

# Iana-ETC

tar xvf iana-etc-20220207.tar.gz
cd iana-etc-20220207
cp services protocols /etc
cd ..
rm -rf iana-etc-20220207

# GLibC - 2.35

tar xvf glibc-2.35.tar.xz
cd glibc-2.35
patch -Np1 -i ../glibc-2.35-fhs-1.patch
mkdir -v build
cd       build
echo "rootsbindir=/usr/sbin" > configparms
../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/usr/lib
make