# A VM Template Build Odyssey with Proxmox/Virtualbox and Packer

## Lessons learned:

 * [On the need to install and enable the QEMU guest agent / acpid](https://forum.proxmox.com/threads/proxmox-packer-vm-quit-powerdown-failed-during-a-packer-build-anyone-have-any-ideas-why.71979/)
 * [On the need to choose VM names without forbidden charactesr so that Proxmox won't complain](https://github.com/hashicorp/packer/issues/8661)
 * [On the difference between host / kvm64 CPU types](https://pve.proxmox.com/wiki/Qemu/KVM_Virtual_Machines).  Relatedly, `virt-what` outputs `kvm` for `kvm64` CPUs and `qemu` for `host` CPUs.
