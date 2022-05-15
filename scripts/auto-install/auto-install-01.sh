# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    auto-install-01.sh                                 :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/15 14:38:48 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/15 14:52:42 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Check Root
if [ "$EUID" -ne 0 ]
  then echo "Error: run this script as root..."
  exit
fi

OPATH=$(pwd)

# Creation du systeme temporaire

printf 'Checking LFS: '$LFS'\n'
sleep 1
printf 'Checking LFS_TGT: '$LFS_TGT'\n'
sleep 1
printf 'Checking PATH: '$PATH'\n'
sleep 1

sh install_softwares.sh
# sh install_softwares_02.sh
# sh install_softwares_03.sh

exit 0