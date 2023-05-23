#!/usr/bin/env bash

IMAGE_NAME=pve-kernel-build
DEBIAN_RELEASE=bullseye
REPO_URL=https://github.com/brunokc/pve-kernel-builder
REPO_BRANCH=main

echo Preparing container...
docker build \
    --build-arg DEBIAN_RELEASE=${DEBIAN_RELEASE} \
    --build-arg REPO_URL=${REPO_URL} \
    --build-arg REPO_BRANCH=${REPO_BRANCH} \
    -t ${IMAGE_NAME} .

echo Building PVE kernel...
mkdir -p ./output
docker run -v $(pwd)/output:/build/output ${IMAGE_NAME} scripts/build-kernel.sh
