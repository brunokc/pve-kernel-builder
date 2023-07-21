# Proxmox VE Kernel Builder

[![Check for new pve-kernel releases](https://github.com/brunokc/pve-kernel-builder/actions/workflows/trigger-kernel-check.yml/badge.svg)](https://github.com/brunokc/pve-kernel-builder/actions/workflows/kernel-check-schedule.yml)  
Latest from [Proxmox](https://git.proxmox.com/):
<img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=proxmox&query=version.proxmox&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fmaster%2Fversion"> <sup>with</sup> <img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=kernel&query=version.kernel&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fmaster%2Fversion">
<sup>&nbsp;|&nbsp;</sup>
<img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=proxmox&query=version.proxmox&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fpve-kernel-5.15%2Fversion"> <sup>with</sup> <img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=kernel&query=version.kernel&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fpve-kernel-5.15%2Fversion">  
Latest [releases](https://github.com/brunokc/pve-kernel-builder/releases):
[![Latest release](https://img.shields.io/github/v/release/brunokc/pve-kernel-builder?display_name=release&sort=date)](https://github.com/brunokc/pve-kernel-builder/releases)
<sup>&nbsp;|&nbsp;</sup>
[![Latest release](https://img.shields.io/github/v/release/brunokc/pve-kernel-builder?display_name=release&sort=date&filter=*5.15*)](https://github.com/brunokc/pve-kernel-builder/releases)

---

<!--
<table>
  <tr>
    <td>proxmox</td>
    <td><img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=proxmox&query=version.proxmox&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fmaster%2Fversion"></td>
  </tr>
  <tr>
    <td>master</td>
    <td><img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=kernel&query=version.kernel&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fmaster%2Fversion"></td>
  </tr>
  <tr>
    <td>5.15</td>
    <td><img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=kernel&query=version.kernel&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fpve-kernel-5.15%2Fversion"></td>
  </tr>
</table>
-->

This project aims to provide an easy way to build kernels for Proxmox VE 
with a particular set of patches. 

At the moment, these are the patches applied during build:

* [Relax Intel RMRR](https://github.com/kiler129/relax-intel-rmrr): relax 
RMRRs on Intel platforms to allow certain PCIe devices to be passed through
to VMs (credit to [kiler129](https://github.com/kiler129/relax-intel-rmrr)).
This patch works around the dreaded `Device is ineligible for IOMMU domain 
attach due to platform RMRR requirement. Contact your platform vendor.` 
message when trying to passthrough certain PCIe devices to a VM.

## How to Build

There are two options:

1. Trigger the [Build pve kernel (in container)](https://github.com/brunokc/pve-kernel-builder/actions/workflows/build-pve-kernel-container.yml) 
workflow.

   This workflow will build a new kernel with the current set of patches applied 
   and produce artifacts that can be downloaded. It will run on a 2-core VM in 
   GitHub and it will take between 2h30m and 3h to complete.

2. Build it locally

   Use the build.sh script to build the kernel locally with the current set of 
   patches applied. Because you are building everything locally, you can customize
   the set of patches you want before building.

In all cases, kernel builds are done using docker to contain the dependencies
and make cleanup easier.

## Installation

Regardless of how you built the kernel, you'll end up with a few of .deb files. 
To install them you need to:

1. Go to the [releases tab](https://github.com/brunokc/pve-kernel-builder/releases/) and pick appropriate packages
   - If you don't use your Proxmox machine for building software, you really only need the `pve-kernel-<version>-pve-relaxablermrr_<version>_amd64.deb` file.
3. Download all applicable `*.deb`s packages to your machine
4. Install the package(s) using `dpkg -i *.deb` in the folder where you downloaded the debs
5. *(OPTIONAL)* Verify the kernel works with the patch disabled by rebooting and checking if `uname -r` shows a version 
   ending with `-pve-relaxablermrr`
5. [Configure the kernel](README.md#configuration)

## Configuration

By default, after the kernel is installed, the patch will be *inactive* (i.e. the kernel will
behave like no patch was applied). To activate it you have to add `relax_rmrr` to the `intel_iommu`
option on your Linux boot args.

In most distros (including Proxmox) you do this by:

1. Opening `/etc/default/grub` (e.g. using `nano /etc/default/grub`)
2. Editing the `GRUB_CMDLINE_LINUX_DEFAULT` to include the option:

    - Example of old line:
      ```
      GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt intremap=no_x2apic_optout"
      ```
    - Example of new line:
      ```
      GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on,relax_rmrr iommu=pt intremap=no_x2apic_optout"
      ```
    - *Side note: these are actually options which will make your PCI passthrough work and do so efficiently*
3. Running `update-grub`
4. Rebooting

To verify if the the patch is active execute `dmesg | grep 'Intel-IOMMU'` after reboot. 
You should see a result similar to this:
 
```
root@sandbox:~# dmesg | grep 'Intel-IOMMU'
[    0.050195] DMAR: Intel-IOMMU: assuming all RMRRs are relaxable. This can lead to instability or data loss
root@sandbox:~# 
```

## Acknowledgements

* [kiler129](https://github.com/kiler129/relax-intel-rmrr): provider of the Relax Intel RMRR patch. Kiler129 provides lots of good info on the [why and how the patch works](https://github.com/kiler129/relax-intel-rmrr/blob/master/deep-dive.md).
* [roforest](https://github.com/roforest/Actions-pve-kernel): provides the basis for the GitHub workflows implemented here.
