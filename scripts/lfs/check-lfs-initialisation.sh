# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    check-lfs-initialisation.sh                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/14 13:07:56 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/15 13:43:40 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

function error {
    printf "\e[1;31m\e[1;33mWarning: $1\e[0m\n"
}

cat ~/.bashrc | grep "LFS" > /dev/null
res=$?
if [ $res != 0 ]
then
    error "LFS not found"
else
    printf "\e[1;32m\e[1;33m'LFS' found\e[0m\n"
fi
cat ~/.bashrc | grep "LFS_TGT" > /dev/null
res=$?
if [ $res != 0 ]
then
    error "LFS_TGT not found"
else
    printf "\e[1;32m\e[1;33m'LFS_TGT' found\e[0m\n"
fi
cat ~/.bashrc | grep "bin" > /dev/null
res=$?
if [ $res != 0 ]
then
    error "PATH not found"
else
    printf "\e[1;32m\e[1;33m'PATH' found\e[0m\n"
fi