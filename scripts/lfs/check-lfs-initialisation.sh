# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    check-lfs-initialisation.sh                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/14 13:07:56 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/15 12:18:05 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

function error {
    printf "\e[1;31m\e[1;33mWarning: $1\e[0m\n"
}

cat ~/.bashrc | grep "LFS"
res=$?
if [ $res != 0 ]
then
    error "LFS not found"
else
    printf "\e[1;32m\e[1;33mLFS found\e[0m\n"
fi
cat ~/.bashrc | grep "LFS_TGT"
res=$?
if [ $res != 0 ]
then
    error "LFS_TGT not found"
else
    printf "\e[1;32m\e[1;33mLFS_TGT found\e[0m\n"
fi
cat ~/.bashrc | grep "bin"
res=$?
if [ $res != 0 ]
then
    error "PATH not found"
else
    printf "\e[1;32m\e[1;33mPATH found\e[0m\n"
fi