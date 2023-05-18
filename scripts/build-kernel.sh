#!/usr/bin/env bash

echo -e "Cores available: $(nproc)"
cd /build/pve-kernel
make && echo "status=success"
