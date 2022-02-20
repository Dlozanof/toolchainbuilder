#!/bin/sh

output_directory=$PWD/toolchainroot

mkdir -p ${output_directory}
chmod +x build.sh
docker build . -t toolchainbuilder:toolchainbuilder0.1
docker run --rm -v ${output_directory}:/workdir/output  toolchainbuilder:toolchainbuilder0.1
