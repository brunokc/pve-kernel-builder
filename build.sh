#!/usr/bin/env bash

while getopts ':d:u:b:s' OPTION; do
    case "$OPTION" in
        d)
            DEBIAN_RELEASE=$OPTARG
            ;;
        u)
            REPO_URL=$OPTARG
            ;;
        b)
            REPO_BRANCH=$OPTARG
            ;;
        s)
            SKIP_BUILD=1
            ;;
        ?|h|help)
            echo "Usage: $(basename $0) [-d <DEBIAN_RELEASE>] [-u <REPO_URL>] -b <REPO_BRANCH>"
            echo
            echo "Ex: $(basename $0) -d bullseye -u git://git.proxmox.com/git/pve-kernel.git -b master"
            exit 1
            ;;
    esac
done

DEBIAN_RELEASE=${DEBIAN_RELEASE:-bullseye}
REPO_URL=${REPO_URL:-git://git.proxmox.com/git/pve-kernel.git}

if [ -z "$REPO_BRANCH" ]; then
    echo "Branch name required. Please specify the branch to build with the -b option."
    echo "Type \"$(basename $0) -h\" for usage."
    exit 1
fi


echo Using:
echo DEBIAN_RELEASE=$DEBIAN_RELEASE
echo REPO_URL=$REPO_URL
echo REPO_BRANCH=$REPO_BRANCH

IMAGE_NAME=pve-kernel-build

echo Preparing container...
docker build \
    --build-arg DEBIAN_RELEASE=${DEBIAN_RELEASE} \
    --build-arg REPO_URL=${REPO_URL} \
    --build-arg REPO_BRANCH=${REPO_BRANCH} \
    -t ${IMAGE_NAME} .

if [ "$SKIP_BUILD" != "1" ]; then
    echo Building PVE kernel...
    mkdir -p ./output
    docker run -v $(pwd)/output:/build/output ${IMAGE_NAME} scripts/build-kernel.sh
fi
