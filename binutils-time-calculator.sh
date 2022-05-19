# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    binutils-time-calculator.sh                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/19 15:56:25 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/19 16:19:16 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

echo "Loading..."

wget https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz > /dev/null 2>&1
tar xvf binutils-2.38.tar.xz > /dev/null 2>&1
cd binutils-2.38 > /dev/null 2>&1
mkdir -v build > /dev/null 2>&1
cd build > /dev/null 2>&1
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --disable-werror > /dev/null 2>&1
time make > result.txt > /dev/null 2>&1
cat result.txt | tail -n1 | grep make