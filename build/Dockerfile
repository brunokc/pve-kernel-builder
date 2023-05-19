#
# This Dockerfile builds the newest kernel with the RMRR patch
#
ARG DEBIAN_RELEASE=bullseye
FROM debian:${DEBIAN_RELEASE}

ARG DEBIAN_RELEASE
ARG REPO_URL=git://git.proxmox.com/git/pve-kernel.git
ARG REPO_BRANCH=pve-kernel-5.15

ENV DEBIAN_FRONTEND=noninteractive

# Trust Proxmox repository key and upgrade system
RUN set -x \
  && apt update \
  && apt install -y apt-utils ca-certificates wget \
  && wget http://download.proxmox.com/debian/proxmox-release-bullseye.gpg -qO /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg \
  && chmod +r /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg \
  && echo "deb http://download.proxmox.com/debian/pve ${DEBIAN_RELEASE} pve-no-subscription" \
	> /etc/apt/sources.list.d/pve-no-subscription.list \
  && apt update \
  && apt upgrade -y 

# Install dependencies
RUN set -x \
  && apt-get install -y --no-install-recommends git nano screen patch fakeroot build-essential devscripts \
	libncurses5 libncurses5-dev libssl-dev bc flex bison libelf-dev libaudit-dev libgtk2.0-dev libperl-dev \
	asciidoc xmlto gnupg gnupg2 rsync lintian debhelper libdw-dev libnuma-dev libslang2-dev sphinx-common \
	asciidoc-base automake cpio dh-python file gcc kmod libiberty-dev libtool perl-modules python3-minimal \
	sed tar zlib1g-dev liblz4-tool idn libpve-common-perl dwarves zstd \
        python3-dev libunwind-dev libzstd-dev libcap-dev systemtap-sdt-dev libbabeltrace-dev \
  && apt-get autoremove --purge \
  && apt-get clean

RUN mkdir -p /build
WORKDIR /build
COPY patches patches

# Clone pve kernel repo
RUN set -x \
    && git clone ${REPO_URL} -b ${REPO_BRANCH} pve-kernel

# Apply patches
RUN set -x \
  && cp patches/kernel/*.patch pve-kernel/patches/kernel \
  && cd pve-kernel \
  && for patch in ../patches/*.patch; do if [ -f $patch ]; then echo "Applying patch '$patch'" && patch -p1 < ${patch}; fi; done

# Build kernel
RUN set -x \
  && cd pve-kernel \
  && echo -e "$(nproc) thread compile" \
  #&& make -j$(nproc) || make -j1 V=s
  && make

# Copy build artifacts
RUN set -x \
  && cd pve-kernel \
  && mkdir release \
  && cp *.deb release/ \
  #&& cp *.ddeb release/ \
  && echo "version=$(ls abi-prev* | sed 's/abi-prev/pve-kernel/g' | sed 's/-pve//g')" >> $GITHUB_OUTPUT
