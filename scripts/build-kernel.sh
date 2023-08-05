#!/usr/bin/env bash

set -x

BUILD_DIR=/build
KERNEL_DIR=$BUILD_DIR/pve-kernel
OUTPUT_DIR=$BUILD_DIR/output

echo -e "Cores available: $(nproc)"
cd $KERNEL_DIR

echo Building kernel...
make

echo Exporting artifacts...
mkdir -p $OUTPUT_DIR/artifacts
cp *.deb $OUTPUT_DIR/artifacts

for d in build pve-kernel-* proxmox-kernel-*; do
    if [[ -d $d ]]; then
        echo "Exporting abi files from $d to $OUTPUT_DIR..."
        cp $d/abi* $OUTPUT_DIR
    fi
done
