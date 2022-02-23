#!/bin/bash

gcc_version=%{gcc_version}
output_folder=/workdir/output

wget https://ftp.gnu.org/gnu/gcc/gcc-${gcc_version}/gcc-${gcc_version}.tar.gz
wget https://ftp.gnu.org/gnu/gcc/gcc-${gcc_version}/gcc-${gcc_version}.tar.gz.sig
wget https://ftp.gnu.org/gnu/gnu-keyring.gpg
signature_invalid=`gpg --verify --no-default-keyring --keyring ./gnu-keyring.gpg gcc-${gcc_version}.tar.gz.sig`
if [ $signature_invalid ]; then echo "Invalid signature" ; exit 1 ; fi
tar -xvzf gcc-${gcc_version}.tar.gz
cd gcc-${gcc_version}
./contrib/download_prerequisites
cd ..
mkdir gcc-${gcc_version}-build
cd gcc-${gcc_version}-build
$PWD/../gcc-${gcc_version}/configure --prefix=${output_folder} --enable-languages=c,c++ --disable-multilib
make -j$(nproc)
make install