# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    get-time.sh                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/19 14:38:28 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/19 14:54:06 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ls compil-calculator > /dev/null 2>&1
if [ $? -eq 0 ]
then
    ./compil-calculator $1
    rm -f compil-calculator
else
    gcc -o compil-calculator scripts/compil-calculator/compil-calculator.c
    ./compil-calculator $1
    rm -f compil-calculator
fi