# PVE Kernel Builder

[![Check version on new pve-kernel releases](https://github.com/brunokc/pve-kernel-builder/workflows/Check%20for%20new%20pve-kernel%20releases/badge.svg)](https://github.com/brunokc/pve-kernel-builder/actions?query=workflow%3A%22Check+for+new+pve-kernel+releases%22)  
Latest from [Proxmox](https://git.proxmox.com/):
<img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=proxmox&query=version.proxmox&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fmaster%2Fversion"> <sup>with</sup> <img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=kernel&query=version.kernel&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fmaster%2Fversion">
<sup>&nbsp;|&nbsp;</sup>
<img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=proxmox&query=version.proxmox&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fpve-kernel-5.15%2Fversion"> <sup>with</sup> <img src="https://img.shields.io/badge/dynamic/yaml?color=informational&label=kernel&query=version.kernel&url=https%3A%2F%2Fraw.githubusercontent.com%2Fbrunokc%2Fpve-kernel-builder%2Fmain%2Fconfig%2Fpve-kernel-5.15%2Fversion">  
Latest kernel [releases](https://github.com/brunokc/pve-kernel-builder/releases):

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
message.

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

## Acknowledgements

* [kiler129](https://github.com/kiler129/relax-intel-rmrr): provider of the Relax Intel RMRR patch. Kiler129 provides lots of good info on the [why and how the patch works](https://github.com/kiler129/relax-intel-rmrr/blob/master/deep-dive.md).
* [roforest](https://github.com/roforest/Actions-pve-kernel): provides the basis for the GitHub workflows implemented here.
