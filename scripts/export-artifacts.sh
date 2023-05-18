#!/usr/bin/env bash

# Copy build artifacts
cp /build/pve-kernel/*.deb /release
cd /build/pve-kernel/build
echo "version=$(ls abi-[0-9]* | sed 's/abi/pve-kernel/g' | sed 's/-pve//g')"
