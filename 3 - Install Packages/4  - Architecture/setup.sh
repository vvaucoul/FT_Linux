#!/bin/bash

cd $LFS/sources
tar Jxvf binutils-2.38.tar.xz
cd binutils-2.38/
./config.guess

readelf -l /bin/ls | grep interpreter
ld --verbose | grep SEARCH
cd ..
rm -rf binutils-2.32/