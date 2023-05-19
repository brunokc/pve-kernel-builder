#!/usr/bin/env bash

echo -e "Cores available: $(nproc)"
cd /build/pve-kernel

echo Building kernel...
make

echo Exporting artifacts
mkdir -p /output/artifacts
cp *.deb /output/artifacts
cp build/abi* /output
