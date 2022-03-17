#!/bin/bash

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

wget http://fr.linuxfromscratch.org/view/lfs-systemd-stable/wget-list -P $LFS/sources
wget http://fr.linuxfromscratch.org/view/lfs-systemd-stable/md5sums -P $LFS/sources
wget --input-file=$LFS/sources/wget-list --continue --directory-prefix=$LFS/sources

pushd $LFS/sources
md5sum -c md5sums
popd