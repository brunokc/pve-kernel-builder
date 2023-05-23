#!/usr/bin/env bash

echo -e "Cores available: $(nproc)"
cd /build/pve-kernel

echo Building kernel...
make

echo Exporting artifacts
mkdir -p /output/artifacts
cp *.deb /output/artifacts

for d in build pve-kernel-*; do
    if [[ -d $d ]]; then
        echo "found abi files in $d"
        cp $d/abi* /output
    fi
done
