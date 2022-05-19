# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    get-time.sh                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vvaucoul <vvaucoul@student.42.Fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/19 14:38:28 by vvaucoul          #+#    #+#              #
#    Updated: 2022/05/19 15:42:05 by vvaucoul         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ls compile-calculator > /dev/null 2>&1
if [ $? -eq 0 ]
then
    ./compile-calculator $1
    rm -f compile-calculator
else
    gcc -o compile-calculator scripts/compile-calculator/compile-calculator.c
    ./compile-calculator $1
    rm -f compile-calculator
fi