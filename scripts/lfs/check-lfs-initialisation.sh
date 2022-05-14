# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    check-lfs-initialisation.sh                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/14 13:07:56 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/14 13:17:40 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

function error {
    printf "\e[1;31m\e[1;33mWarning: $1\e[0m\n"
}

echo $LFS | grep "lfs"
res=$?
if [ $res != 0 ]
then
    error "LFS not found"
fi
echo $LFS_TGT | grep "lfs"
res=$?
if [ $res != 0 ]
then
    error "LFS_TGT not found"
fi
echo $PATH | grep "bin"
res=$?
if [ $res != 0 ]
then
    error "PATH not found"
fi