# PVE Kernel Builder

This project aims to provide an easy way to build kernels for Proxmox VE 
with a particular set of patches. 

At the moment, the patches applied are:

* [Relax Intel RMRR](https://github.com/kiler129/relax-intel-rmrr): relax 
RMRRs on Intel platforms to allow certain PCIe devices to be passed through
to VMs (credit to [kiler129](https://github.com/kiler129/relax-intel-rmrr)).
This patch works around the dreaded `Device is ineligible for IOMMU domain 
attach due to platform RMRR requirement. Contact your platform vendor.` 
message.

## How to Build

Two options:

1. Trigger the [Build pve kernel (in container)]
(https://github.com/brunokc/pve-kernel-builder/actions/workflows/build-pve-kernel-container.yml) workflow.

This workflow will build a new kernel with the current set of patches applied 
and produce artifacts that can be downloaded. This will run on a 2-core VM
in GitHub and it will take about 2h30m to complete.

2. Build it locally

Use the build.sh script to build the kernel locally with the current set of 
patches applied. Because you are building everything locally, you can customize
the set of patches you want before building.


