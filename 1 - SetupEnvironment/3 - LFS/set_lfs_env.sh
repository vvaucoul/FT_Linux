#!/bin/bash

## BASH
echo "export LFS=/mnt/lfs" >> /etc/bash.bashrc
## ZSH
echo "export LFS=/mnt/lfs" >> ~/.zshrc

export LFS=/mnt/lfs

source /etc/environment
tail -n1 /etc/environment

echo $LFS

$@